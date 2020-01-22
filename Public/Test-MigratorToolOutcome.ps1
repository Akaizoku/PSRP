function Test-MigratorToolOutcome {
  <#
    .SYNOPSIS
    Check RiskPro Migrator tool command outcome

    .DESCRIPTION
    Parse the output of a RiskPro Migrator tool command to check the status of the operation performed

    .PARAMETER Log
    The log parameter corresponds to the RiskPro Migrator tool output to analyse

    .INPUTS
    None. You cannot pipe objects to Test-MigratorToolOutcome.

    .OUTPUTS
    System.Boolean. Test-MigratorToolOutcome returns a boolean value:
    - false:  errors were detected in the command log;
    - true:   no errors were detected in the command log.

    .NOTES
    Filename:       Test-MigratorToolOutcome.ps1
    Author:         Florian CARRIER
    Creation date:  26/11/2019
    Last modified:  22/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "RiskPro Migrator tool command log"
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
    # Check RiskPro Migrator tool command log
    if ((Select-String -InputObject $Log -Pattern "[ERROR]" -Encoding "UTF8" -SimpleMatch -Quiet) -Or (Select-String -InputObject $Log -Pattern "[SEVERE]" -Encoding "UTF8" -SimpleMatch -Quiet)) {
      # If exception is found return failure
      return $false
    } else {
      # Return success
      return $true
    }
  }
}
