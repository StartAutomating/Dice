<div align='center'>
<img src='Assets/Dice.svg' alt='Dice' />
<a href='https://www.powershellgallery.com/packages/dice/'>
<img src='https://img.shields.io/powershellgallery/dt/dice' />
</a>
<br/>
<a href='https://github.com/sponsors/StartAutomating'>❤️</a>
<a href='https://github.com/StartAutomating/Dice/stargazers'>⭐</a>
</div>

## Dice

Dice is a little PowerShell module that helps you take a chance.

It is meant to be a useful and educational module, primarily to help anyone understand independent probability.

~~~PowerShell
Get-Dice # List the dice that currently exist
~~~

~~~PowerShell
Read-Dice # Read the current values of the dice
~~~

~~~PowerShell
Read-Dice -Sides 6 -RollCount 2 # Roll a 6-sided die twice
~~~

~~~PowerShell
Read-Dice -Sides 2 -RollCount 10 # Flip a coin 10 times.
~~~

~~~PowerShell
Read-Dice -Sides 20 -RollCount 1kb # Roll a D20 1024 times.
~~~

## Dice in Docker

Dice creates a [Docker image](https://github.com/users/StartAutomating/packages/container/package/dice) to let you roll the dice in a service.

~~~PowerShell
# pull down the latest image
docker pull ghcr.io/startautomating/dice

# Run it locally and publish it to 6161
docker run --interactive --tty --publish 6161:80 ghcr.io/startautomating/dice
~~~