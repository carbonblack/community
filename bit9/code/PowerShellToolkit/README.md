# CB Protection API Toolkit for PowerShell
This toolkit was written specifically for PowerShell 5.1. As such, it uses code that is NOT compatible with anything below 5.0. There could potentially be issues if you use 5.0 as I have only tested it in 5.1.

## How to use
Import these modules with the new import method introduced in PowerShell 5.0
```
using module .\CBEPAPI****.psm1
```

To create a new object from the class definitions use the method introduced in PowerShell 5.0
```
$object = [CBEP****]::new()
```

To use methods of classes, simply reference them in 'dot' notation. Methods that will return data for consumption will be typecast as something OTHER than [void] in the class definitions.
```
$object.GetSomethingCool('variable1','variable2','variable3)
```


## Future implements
1. File analysis class
