function Start-GenerateUDAJAR {
  <#
    .SYNOPSIS
    Start generation of UDA JAR

    .DESCRIPTION
    Wrapper function to start the generation of the UDA JAR using the RiskPro batch client

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

    .PARAMETER ModelName
    The model name parameter corresponds to the name of the model.

    .PARAMETER DatabaseUsername
    The optional database user name parameter corresponds to the name of the datbase user.

    .PARAMETER DatabaseUserPassword
    The optional database user password parameter corresponds to the password of the datbase user.

    .PARAMETER GenerateJAR
    The generate JAR switch defines if the JAR file should be generated.

    .PARAMETER UpdateDatabase
    The update database switch defines if the database schema should be updated.

    .PARAMETER SynchronousMode
    The synchronous mode switch defines if the synchronous mode should be used.

    .NOTES
    File name:      Start-GenerateUDAJAR.ps1
    Author:         Florian CARRIER
    Creation date:  12/03/2020
    Last modified:  12/03/2020
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
    [System.String]
    $JavaPath,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "RiskPro batch client path"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("Path", "RiskProPath")]
    [System.String]
    $RiskProBatchClient,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "RiskPro server URI"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
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
    [System.String[]]
    $JavaOptions,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Name of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $ModelName,
    [Parameter (
      Position    = 7,
      Mandatory   = $false,
      HelpMessage = "Name of the database user"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $DatabaseUserName,

    [Parameter (
      Position    = 8,
      Mandatory   = $false,
      HelpMessage = "Password of the database user"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $DatabaseUserPassword,
    [Parameter (
      HelpMessage = "Define if the JAR file should be generated"
    )]
    [Switch]
    $GenerateJAR,
    [Parameter (
      HelpMessage = "Define if the database schema should be updated"
    )]
    [Switch]
    $UpdateDatabase,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $SynchronousMode
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get utilities Java class
    $JavaClass = Get-JavaClass -Name "Utilities"
  }
  Process {
    # Define operation
    $Operation = "startGenerateUDAJar"
    # Define mandatory operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ut.modelName"             , $ModelName)
    $OperationParameters.Add("ut.generateJar"           , $GenerateJAR)
    $OperationParameters.Add("ut.updateDb"              , $UpdateDatabase)
    # Define optional operation parameters
    if ($PSBoundParameters.ContainsKey("DatabaseUserName"))     { $OperationParameters.Add("ut.dbUserName", $DatabaseUserName)      }
    if ($PSBoundParameters.ContainsKey("DatabaseUserPassword")) { $OperationParameters.Add("ut.dbPassword", $DatabaseUserPassword)  }
    # Configure syncrhonous mode
    $OperationParameters.Add("ws.sync", $SynchronousMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Call RiskPro batch client
    if ($PSBoundParameters.ContainsKey("JavaPath")) {
      Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Parameters $Parameters -Class $JavaClass
    } else {
      Invoke-RiskProBatchClient -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Parameters $Parameters -Class $JavaClass
    }
  }
}
