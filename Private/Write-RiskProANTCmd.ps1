function Write-RiskProANTCmd {
  <#
    .SYNOPSIS
    Write RiskPro ANT commands

    .DESCRIPTION
    Genrate call to RiskPro batch client using ANT batch utility client

    .PARAMETER Path
    The path parameter corresponds to the path to the RiskPro ANT batch client.

    .PARAMETER XML
    The XML parameter corresponds to the path of the ANT XML configuration file.

    .PARAMETER Operation
    The operation parameter corresponds to the ANT operation to perform.

    .PARAMETER Properties
    The optional properties parameter corresponds to the list of Java properties to pass to the ANT script to overwrite default variables.

    .PARAMETER Redirect
    The redirect switch enables the redirection of errors to the standard output pipeline.

    .NOTES
    File name:      Write-RiskProANTCmd.ps1
    Author:         Florian Carrier
    Creation date:  16/01/2020
    Last modified:  22/01/2020
  #>
  [CmdletBinding()]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Path to the RiskPro batch client"
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
    $Properties = "",
    [Parameter (
      HelpMessage = "Enable error pipeline redirection"
    )]
    [Switch]
    $Redirect
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Redirect errors to standard output pipeline
    $Redirection = "2>&1"
  }
  Process {
    # Construct command
    $Command = """$Path"" ""$XML"" $Operation $Properties"
    # Add stream redirection if required
    if ($Redirect) {
      $Command = $Command + " " + $Redirection
    }
    # Wrap batch command
    $CommandWrapper = "cmd.exe /c '$Command'"
    Write-Log -Type "DEBUG" -Object $CommandWrapper
    # Return command
    return $CommandWrapper
  }
}
