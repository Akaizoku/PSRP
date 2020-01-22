function Invoke-RiskProBatchClient {
  <#
    .SYNOPSIS
    Call RiskPro batch client

    .DESCRIPTION
    Wrapper function to create a call the RiskPro batch client

    .PARAMETER JavaPath
    The optional java path parameter corresponds to the path to the Java executable file. If not specified, please ensure that the path contains the Java home.

    .PARAMETER RiskProBatchClient
    The RiskPro batch client parameter corresponds to the path to the RiskPro batch client JAR file.

    .PARAMETER ServerURI
    The server URI parameter corresponds to the Uniform Resource Identifier (URI) of the RiskPro server.

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the RiskPro account to use for the operation.

    .PARAMETER JavaOptions
    The optional Java options parameter corresponds to the additional Java options to pass to the Java client.

    .PARAMETER Operation
    The operation parameter corresponds to the command to execute.

    .PARAMETER Parameters
    The parameters parameter corresponds to the list of parameters to use for the operation.

    .PARAMETER Class
    The class parameter corresponds to the Java class to use for the operation.

    .NOTES
    File name:      Invoke-RiskProBatchClient.ps1
    Author:         Florian CARRIER
    Creation date:  27/11/2018
    Last modified:  21/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
      HelpMessage = "Java path"
    )]
    # [ValidateNotNullOrEmpty ()]
    [String]
    $JavaPath,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "RiskPro batch client path"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("Path", "RiskProPath")]
    [String]
    $RiskProBatchClient,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "RiskPro server URI"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ServerURI,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Credentials of the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Java options"
    )]
    # [ValidateNotNullOrEmpty ()]
    [String[]]
    $JavaOptions,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Operation to perform"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Operation,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Parameters of the operation"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $Parameters,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Java class to use"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Class
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    # Build command
    if ($PSBoundParameters.ContainsKey("JavaPath") -And ($JavaPath -ne "") -And ($JavaPath -ne $null)) {
      if ($PSBoundParameters.ContainsKey("JavaOptions") -And ($JavaOptions -ne "") -And ($JavaOptions -ne $null)) {
        $CommandLine = Write-RiskProBatchCmd -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Parameters $Parameters -Class $Class
      } else {
        $CommandLine = Write-RiskProBatchCmd -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -Operation $Operation -Parameters $Parameters -Class $Class
      }
    } else {
      if ($PSBoundParameters.ContainsKey("JavaOptions") -And ($JavaOptions -ne "") -And ($JavaOptions -ne $null)) {
        $CommandLine = Write-RiskProBatchCmd -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Parameters $Parameters -Class $Class
      } else {
        $CommandLine = Write-RiskProBatchCmd -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -Operation $Operation -Parameters $Parameters -Class $Class
      }
    }
    # Execute command
	  $Output = Invoke-Expression -Command $CommandLine | Out-String
    # Return RiskPro batch client output
    return $Output
  }
}
