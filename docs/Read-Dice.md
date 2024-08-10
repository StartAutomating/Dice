Read-Dice
---------

### Synopsis
Reads the dice

---

### Description

Rolls the dice N times and reads the results.

---

### Related Links
* [Get-Dice](Get-Dice.md)

* [New-Dice](New-Dice.md)

---

### Parameters
#### **Sides**
The number of sides on the dice.

|Type     |Required|Position|PipelineInput        |Aliases        |
|---------|--------|--------|---------------------|---------------|
|`[Int32]`|false   |1       |true (ByPropertyName)|Side<br/>Number|

#### **Name**
The name of the dice.

|Type      |Required|Position|PipelineInput        |Aliases             |
|----------|--------|--------|---------------------|--------------------|
|`[String]`|false   |2       |true (ByPropertyName)|DiceName<br/>DieName|

#### **RollCount**
The number of rolls of the dice.

|Type     |Required|Position|PipelineInput        |Aliases       |
|---------|--------|--------|---------------------|--------------|
|`[Int32]`|false   |3       |true (ByPropertyName)|Rolls<br/>Roll|

---

### Syntax
```PowerShell
Read-Dice [[-Sides] <Int32>] [[-Name] <String>] [[-RollCount] <Int32>] [<CommonParameters>]
```
