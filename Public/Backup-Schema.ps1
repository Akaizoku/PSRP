function Backup-Schema {
  <#
    .SYNOPSIS
    Backup RiskPro database

    .DESCRIPTION
    Back-up the database for OneSumX for Risk Management

    .PARAMETER Path
    The path parameter corresponds to the path to the RiskPro ANT batch client.

    .PARAMETER XML
    The XML parameter corresponds to the path of the ANT XML configuration file.

    .PARAMETER Properties
    The optional properties parameter corresponds to the list of Java property to pass to the ANT script to overwrite default variables.

    .NOTES
    File name:      Backup-Schema.ps1
    Author:         Florian Carrier
    Creation date:  25/11/2019
    Last modified:  16/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the RiskPro ANT client"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Path to the ANT XML file"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $XML,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Java properties"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("JavaProperties")]
    [String]
    $Properties
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Back-up database
    Invoke-RiskProANTClient -Path $Path -XML $XML -Operation "backupSchema" -Properties $Properties
  }
}
