param(
[string[]]
$ListenerPrefix = @('http://localhost:6161/')
)

# If we're running in a container and the listener prefix is not http://*:80/,
if ($env:IN_CONTAINER -and $listenerPrefix -ne 'http://*:80/') {
    # then set the listener prefix to http://*:80/ (listen to all incoming requests on port 80).
    $listenerPrefix = 'http://*:80/'
}

# If we do not have a global DiceHttpListener object,   
if (-not $global:DiceHttpListener) {
    # then create a new HttpListener object.
    $global:DiceHttpListener = [Net.HttpListener]::new()
    # and add the listener prefixes.
    foreach ($prefix in $ListenerPrefix) {
        if ($global:DiceHttpListener.Prefixes -notcontains $prefix) {
            $global:DiceHttpListener.Prefixes.Add($prefix)
        }    
    }
}

# The DiceServerJob will start the HttpListener and listen for incoming requests.
$script:DiceServerJob = 
    Start-ThreadJob -Name DiceServer -ScriptBlock {
        param([Net.HttpListener]$Listener)
        # Start the listener.
        try { $Listener.Start() }
        # If the listener cannot start, write a warning and return.
        catch { Write-Warning "Could not start listener: $_" ;return }
        # While the listener is running,
        while ($true) {
            # get the context of the incoming request.
            $listener.GetContextAsync() |
                . { process {
                    # by enumerating the result, we effectively 'await' the result
                    $context = $(try { $_.Result } catch { $_ })
                    # and can just return a context object
                    $context
                } }
        }    
    } -ArgumentList $global:DiceHttpListener

# If PowerShell is exiting, close the HttpListener.
Register-EngineEvent -SourceIdentifier PowerShell.Exiting -Action {
    $global:DiceHttpListener.Close()
}

# Keep track of the creation time of the DiceServerJob.
$DiceServerJob | Add-Member -MemberType NoteProperty Created -Value ([DateTime]::now) -Force
# Jobs have .Output, which in turn has a .DataAdded event.
# this allows us to have an event-driven webserver.
$subscriber = Register-ObjectEvent -InputObject $DiceServerJob.Output -EventName DataAdded -Action {
    $context = $event.Sender[$event.SourceEventArgs.Index]
    # When a context is added to the output, create a new event with the context and the time.
    New-Event -SourceIdentifier HTTP.Request -MessageData ($event.MessageData + [Ordered]@{
        Context = $context        
        Time    = [DateTime]::Now
    })
} -SupportEvent -MessageData ([Ordered]@{Job = $DiceServerJob})
# Add the subscriber to the DiceServerJob (just in case).
$DiceServerJob | Add-Member -MemberType NoteProperty OutputSubscriber -Value $subscriber -Force

# Our custom 'HTTP.Request' event will process the incoming requests.
Register-EngineEvent -SourceIdentifier HTTP.Request -Action {
    $context = $event.MessageData.Context
    # Get the request and response objects from the context.
    $request, $response = $context.Request, $context.Response
    # Do everything from here on in a try/catch block, so errors don't hurt the server.
    try {
        # Forget favicons.
        if ($request.Url.LocalPath -eq '/favicon.ico') {
            $response.StatusCode = 404
            $response.Close()
            return
        }
        # If the request is for the root, return "No Dice".
        $outputMessage =
            if ($request.Url.LocalPath -eq '/') {
                "No Dice"
            }             
            else {
                # Otherwise, get the segments of the URL.
                $strippedSegments = $request.Url.Segments -replace '/$' -ne ''
                # If the segments are integers, get the integer segments.
                $intSegments = @(foreach ($segment in $strippedSegments) {
                    if ($segment -as [int]) {
                        $segment -as [int]
                    }
                }) -as [int[]]
                # If there is only one segment, roll a dice with that many sides.
                if ($intSegments.Count -eq 1) {
                    Read-Dice -Sides $intSegments[0] | Format-Custom | Out-String  
                } elseif ($intSegments -ge 2) {
                    # If there are two segments, roll a dice with the first segment as the number of sides and the second segment as the number of rolls.
                    Read-Dice -Sides $intSegments[0] -RollCount $intSegments[1] | Format-Custom | Out-String
                } else {
                    # Otherwise, return "No Dice".
                    "No Dice"
                }                
            }
        
        # At this point our output message is a string, so we can convert it to bytes.
        $outputBuffer = $OutputEncoding.GetBytes($outputMessage)        
        # and write the output buffer to the response stream.
        $response.OutputStream.Write($outputBuffer, 0, $outputBuffer.Length)
        # and we're done.
        $response.Close()
    } catch {
        # If anything goes wrong, write a warning
        # (this will be written to the console, making it easier for an admin to see what went wrong).
        Write-Warning "Error processing request: $_"
    }    
}

# Write a message to the console that the dice server has started.
@{"Message" = "Dice server started on $listenerPrefix @ $([datetime]::now.ToString('o'))"} | ConvertTo-Json | Out-Host

# Wait for the PowerShell.Exiting event.
while ($true) {
    $exiting = Wait-Event -SourceIdentifier PowerShell.Exiting -Timeout (Get-Random -Minimum 1 -Maximum 5)
    if ($exiting) {
        # If the DiceServerJob is still running, stop it.
        $DiceServerJob | Stop-Job
        # and break out of the loop.
        break
    }
}