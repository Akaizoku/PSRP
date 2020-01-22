function Invoke-RiskProANTClient {
  <#
    .SYNOPSIS
    Run RiskPro ANT commands

    .DESCRIPTION
    Call RiskPro batch client using ANT batch utility client

    .PARAMETER Path
    The path parameter corresponds to the path to the RiskPro ANT batch client.

    .PARAMETER XML
    The XML parameter corresponds to the path of the ANT XML configuration file.

    .PARAMETER Operation
    The operation parameter corresponds to the ANT operation to perform.

    .PARAMETER Properties
    The optional properties parameter corresponds to the list of Java property to pass to the ANT script to overwrite default variables.

    .NOTES
    File name:      Invoke-RiskProANTClient.ps1
    Author:         Florian Carrier
    Creation date:  15/10/2019
    Last modified:  22/01/2020
  #>
  [CmdletBinding()]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the RiskPro ANT client"
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Path,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Path to the ANT XML file"
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $XML,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Name of the operation to execute"
    )]
    [ValidateNotNullOrEmpty()]
    [String]
    $Operation,
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "Java properties"
    )]
    [Alias ("JavaProperties")]
    [String]
    $Properties = ""
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define command
    $Command = Write-RiskProANTCmd -Path $Path -XML $XML -Operation $Operation -Properties $Properties -Redirect
    # Call RiskPro ANT client
    $Output = Invoke-Expression -Command $Command
    Write-Log -Type "DEBUG" -Object $Output
    # Return output
    return $Output
  }
}
