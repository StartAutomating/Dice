New-Dice
--------

### Synopsis
Creates a new dice.

---

### Description

Creates a new dice, or returns an existing dice.

---

### Parameters
#### **Sides**
The number of sides on the die.

|Type     |Required|Position|PipelineInput        |Aliases           |
|---------|--------|--------|---------------------|------------------|
|`[Int32]`|false   |1       |true (ByPropertyName)|Side<br/>SideCount|

#### **Name**
The name of the die.

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[String]`|false   |2       |true (ByPropertyName)|DiceName<br/>DieName|

#### **Face**
The faces of the die.  Each face is a string that will can be displayed when the die is rolled.

|Type        |Required|Position|PipelineInput        |Aliases|
|------------|--------|--------|---------------------|-------|
|`[String[]]`|false   |3       |true (ByPropertyName)|Faces  |

---

### Notes
A dice is a simple table that represents a die.

The table has a column for the roll number, the roll result, and the number of sides on the die.

By describing a dice in a table, we can easily roll the dice, and keep track of the results.

---

### Syntax
```PowerShell
New-Dice [[-Sides] <Int32>] [[-Name] <String>] [[-Face] <String[]>] [<CommonParameters>]
```
