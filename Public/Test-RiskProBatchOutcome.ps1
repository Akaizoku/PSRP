function Test-RiskProBatchOutcome {
  <#
    .SYNOPSIS
    Check RiskPro batch client command outcome

    .DESCRIPTION
    Parse the output of a RiskPro batch client command to check the status of the operation performed.

    .PARAMETER Log
    The log parameter corresponds to the RiskPro batch client output to analyse.

    .INPUTS
    System.String. You can pipe the RiskPro batch client log to Test-RiskProBatchOutcome.

    .OUTPUTS
    System.Boolean. Test-RiskProBatchOutcome returns a boolean value:
    - false:  errors were detected in the command log;
    - true:   no errors were detected in the command log.

    .NOTES
    Filename:       Test-RiskProBatchOutcome.ps1
    Author:         Florian CARRIER
    Creation date:  23/10/2019
    Last modified:  21/01/2020
    TODO            Improve parsing
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "RiskPro batch client command log",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
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
    # Check RiskPro batch command log
    if ((Select-String -InputObject $Log -Pattern "Error" -Encoding "UTF8" -SimpleMatch -Quiet) -Or (Select-String -InputObject $Log -Pattern "Exception" -Encoding "UTF8" -SimpleMatch -Quiet)) {
      # If exception is found return failure
      return $false
    } else {
      # Return success
      return $true
    }
  }
}
