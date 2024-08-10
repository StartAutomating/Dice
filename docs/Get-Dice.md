Get-Dice
--------

### Synopsis
Gets the dice.

---

### Description

Get-Dice retrieves dice objects from the dice database.

---

### Examples
> EXAMPLE 1

```PowerShell
Get-Dice
```
> EXAMPLE 2

```PowerShell
dice
```

---

### Parameters
#### **Name**
The name of the dice.

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[String]`|false   |1       |true (ByPropertyName)|DiceName<br/>DieName|

#### **Side**
The number of sides on the dice.

|Type     |Required|Position|PipelineInput        |Aliases|
|---------|--------|--------|---------------------|-------|
|`[Int32]`|false   |2       |true (ByPropertyName)|Sides  |

---

### Syntax
```PowerShell
Get-Dice [[-Name] <String>] [[-Side] <Int32>] [<CommonParameters>]
```
