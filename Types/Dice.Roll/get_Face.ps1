
if ($this.Table.ExtendedProperties['Faces'] -and $this.Roll) {
    $this.Table.ExtendedProperties['Faces'][$this.Roll - 1]
} else {
    ''
}