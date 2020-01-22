# RiskPro PowerShell module

RiskPro PowerShell module (PSRP) is a framework for the automation of tasks for OneSumX for Risk Management.

<!-- TOC depthFrom:2 depthTo:6 withLinks:1 updateOnSave:1 orderedList:1 -->

1.  [Usage](#usage)
    1.  [Installation](#installation)
    2.  [Import](#import)
    3.  [List available functions](#list-available-functions)
2.  [Dependencies](#dependencies)

<!-- /TOC -->

## Usage

### Installation

There are two ways of setting up the WildFly PowerShell Module on your system:
1. Download the `PSRP` module from the [Github repository](https://github.com/Akaizoku/PSRP);
1. Install the `PSRP` module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSRP).

```powershell
Install-Module -Name "PSRP" -Repository "PSGallery"
```

### Import

```powershell
Import-Module -Name "PSRP"
```

### List available functions

```powershell
Get-Command -Module "PSRP"
```

## Dependencies

This module depends on the usage of functions provided by the [PowerShell Tool Kit (PSTK)](https://www.powershellgallery.com/packages/PSTK/) module.
