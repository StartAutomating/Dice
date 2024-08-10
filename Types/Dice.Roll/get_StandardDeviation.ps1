if ($this.Table -and 
    $this.Table.Columns -and 
    $this.Table.Columns['Roll']
) {
    $this.Table.Compute('STDEV(Roll)','')
}
