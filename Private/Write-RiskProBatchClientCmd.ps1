function Write-RiskProBatchClientCmd {
  <#
    .SYNOPSIS
    Write RiskPro batch client command

    .DESCRIPTION
    Construct command line to call the RiskPro batch client

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
    The optional parameters parameter corresponds to the list of parameters to use for the operation.

    .PARAMETER Class
    The class parameter corresponds to the Java class to use for the operation.

    .NOTES
    File name:      Write-RiskProBatchClientCmd.ps1
    Author:         Florian CARRIER
    Creation date:  27/11/2018
    Last modified:  24/01/2020
  #>
  [CmdletBinding()]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $false,
      HelpMessage = "Java path"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $JavaPath = "java",
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
      Mandatory   = $false,
      HelpMessage = "Parameters of the operation"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $Parameters,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Java class"
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
    # Command parameters
    $CommandParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $CommandParameters.Add("ws.operation"       , $Operation)
    $CommandParameters.Add("ws.epr.base"        , $ServerURI + '/batchapi')
    $CommandParameters.Add("rs.epr.base"        , $ServerURI + '/api')
    $CommandParameters.Add("od.service.address" , $ServerURI + '/res.svc')
    $CommandParameters.Add("ws.user.name"       , $Credentials.UserName)
    $CommandParameters.Add("ws.user.pswd"       , $Credentials.GetNetworkCredential().Password)
    # Format Java parameters
    $BaseParameters = ConvertTo-JavaProperty -Properties $CommandParameters
    # Construct command
    if ($PSBoundParameters.ContainsKey("JavaOptions")) {
      if ($PSBoundParameters.ContainsKey("Parameters")) {
        $Command = "& ""$JavaPath"" -classpath ""$RiskProBatchClient"" $BaseParameters $Parameters $JavaOptions $Class"
      } else {
        $Command = "& ""$JavaPath"" -classpath ""$RiskProBatchClient"" $BaseParameters $JavaOptions $Class"
      }
    } else {
      if ($PSBoundParameters.ContainsKey("Parameters")) {
        $Command = "& ""$JavaPath"" -classpath ""$RiskProBatchClient"" $BaseParameters $Parameters $Class"
      } else {
        $Command = "& ""$JavaPath"" -classpath ""$RiskProBatchClient"" $BaseParameters $Class"
      }
    }
    # Debugging with obfuscation
    Write-Log -Type "DEBUG" -Object $Command -Obfuscate $Credentials.GetNetworkCredential().Password
    # Return RiskPro batch client command
    return $Command
  }
}
