<#
  .SYNOPSIS
  RiskPro PowerShell module

  .DESCRIPTION
  PowerShell library for RiskPro

  .NOTES
  File name:     PSRP.ps1
  Author:        Florian Carrier
  Creation date: 14/01/2019
  Last modified: 15/10/2019
  Dependencies:  - PowerShell Tool Kit (PSTK)
                 - SQL Server PowerShell module (SQLServer or SQLPS)

  .LINK
  https://www.powershellgallery.com/packages/PSTK

  .LINK
  https://docs.microsoft.com/en-us/sql/powershell/download-sql-server-ps-module
#>

# Get public and private function definition files
$Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1"  -ErrorAction "SilentlyContinue" )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction "SilentlyContinue" )

# Import files using dot sourcing
foreach ($File in @($Public + $Private)) {
  try   { . $File.FullName }
  catch { Write-Error -Message "Failed to import function $($File.FullName): $_" }
}

# Export public functions
Export-ModuleMember -Function $Public.BaseName
