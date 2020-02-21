function Start-Maintenance {
  <#
    .SYNOPSIS
    Start maintenance

    .DESCRIPTION
    Wrapper function to start maintenance using the RiskPro batch client

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

    .NOTES
    File name:      Start-Maintenance.ps1
    Author:         Florian CARRIER
    Creation date:  24/01/2020
    Last modified:  24/01/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
      HelpMessage = "Java path"
    )]
    [ValidateNotNullOrEmpty ()]
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
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $JavaOptions
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get utilities Java class
    $JavaClass = Get-JavaClass -Name "Administration"
  }
  Process {
    # Define operation
    $Operation = "startMaintenance"
    # Call RiskPro batch client
    if ($PSBoundParameters.ContainsKey("JavaPath")) {
      Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Class $JavaClass
    } else {
      Invoke-RiskProBatchClient -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Class $JavaClass
    }
  }
}
