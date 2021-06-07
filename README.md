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

There are two ways of setting up the RiskPro PowerShell Module on your system:

1.  Download the `PSRP` module from the [Github repository](https://github.com/Akaizoku/PSRP);
2.  Install the `PSRP` module from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSRP).

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

| CommandType | Name                           | Version | Source |
| ----------- | ------------------------------ | ------- | ------ |
| Function    | Backup-Schema                  | 1.0.2   | PSRP   |
| Function    | Get-ModelID                    | 1.0.2   | PSRP   |
| Function    | Get-RiskProBatchResult         | 1.0.2   | PSRP   |
| Function    | Get-SolveID                    | 1.0.2   | PSRP   |
| Function    | Grant-Role                     | 1.0.2   | PSRP   |
| Function    | Invoke-CreateModel             | 1.0.2   | PSRP   |
| Function    | Invoke-CreateModelGroup        | 1.0.2   | PSRP   |
| Function    | Invoke-CreateUser              | 1.0.2   | PSRP   |
| Function    | Invoke-CreateUserGroup         | 1.0.2   | PSRP   |
| Function    | Invoke-DeleteModel             | 1.0.2   | PSRP   |
| Function    | Invoke-DeleteModelGroup        | 1.0.2   | PSRP   |
| Function    | Invoke-DeleteUser              | 1.0.2   | PSRP   |
| Function    | Invoke-List                    | 1.0.2   | PSRP   |
| Function    | Invoke-MakeDir                 | 1.0.2   | PSRP   |
| Function    | Invoke-MigratorTool            | 1.0.2   | PSRP   |
| Function    | Invoke-ModifyModel             | 1.0.2   | PSRP   |
| Function    | Invoke-ModifyModelGroup        | 1.0.2   | PSRP   |
| Function    | Invoke-ModifyUser              | 1.0.2   | PSRP   |
| Function    | Invoke-RiskProANTClient        | 1.0.2   | PSRP   |
| Function    | Invoke-RiskProBatchClient      | 1.0.2   | PSRP   |
| Function    | Invoke-Upload                  | 1.0.2   | PSRP   |
| Function    | Restore-Schema                 | 1.0.2   | PSRP   |
| Function    | Set-UserPassword               | 1.0.2   | PSRP   |
| Function    | Start-CleanRollupSolve         | 1.0.2   | PSRP   |
| Function    | Start-ExportToExcel            | 1.0.2   | PSRP   |
| Function    | Start-GenerateUDAJAR           | 1.0.2   | PSRP   |
| Function    | Start-GenesisLoader            | 1.0.2   | PSRP   |
| Function    | Start-ImportXML                | 1.0.2   | PSRP   |
| Function    | Start-Maintenance              | 1.0.2   | PSRP   |
| Function    | Start-RollupSolve              | 1.0.2   | PSRP   |
| Function    | Start-Solve                    | 1.0.2   | PSRP   |
| Function    | Test-MigratorToolOutcome       | 1.0.2   | PSRP   |
| Function    | Test-Model                     | 1.0.2   | PSRP   |
| Function    | Test-RiskProBatchClientOutcome | 1.0.2   | PSRP   |
| Function    | Test-Solve                     | 1.0.2   | PSRP   |
| Function    | Unlock-User                    | 1.0.2   | PSRP   |

## Dependencies

This module depends on the usage of functions provided by the [PowerShell Tool Kit (PSTK)](https://www.powershellgallery.com/packages/PSTK/) module.
