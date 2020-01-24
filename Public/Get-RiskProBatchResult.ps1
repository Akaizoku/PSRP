function Get-RiskProBatchResult {
  <#
    .SYNOPSIS
    Get RiskPro batch client command result

    .DESCRIPTION
    Wrapper function to retrieve the result of a command using the RiskPro batch client

    .PARAMETER Log
    The log parameter corresponds to the RiskPro batch client output to analyse.

    .INPUTS
    System.String. You can pipe the RiskPro batch client log to Test-RiskProBatchClientOutcome.

    .OUTPUTS
    System.String. Test-RiskProBatchClientOutcome returns the result of the RiskPro batch client command.

    .NOTES
    File name:      Get-RiskProBatchResult.ps1
    Author:         Florian CARRIER
    Creation date:  21/01/2020
    Last modified:  21/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "RiskPro batch client command log"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Log
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Define result pattern
    $ResultPattern  = [RegEx]::New('(?<=.+ws\.result\s)\d')
    # Select result from log
    # TODO fix parsing
    $RiskProBatchResult = Select-String -InputObject $GetRiskProBatchResult -Pattern $ResultPattern -Encoding "UTF8" | ForEach-Object { $_.Matches.Value }
    # Return result
    return $RiskProBatchResult
  }
}
