function Start-GenesisLoader {
  <#
    .SYNOPSIS
    Start data foundation loader

    .DESCRIPTION
    Wrapper function to start the data foundation loading process using the RiskPro batch client

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

    .PARAMETER ResultSelectionName
    The result selection name parameter corresponds to the name of the result selection.

    .PARAMETER SolveName
    The solve name parameter corresponds to the name of the solve.

    .PARAMETER LotType
    The lot type parameter corresponds to the lot number.

    .PARAMETER ValidOn
    The valid on parameter corresponds to the reporting date. It should be specified using the DD/MM/YYYY [AM | PM] format.

    .PARAMETER TechnicalConfiguration
    The optional technical configuration parameter corresponds to the name of the technical configuration to use.

    .PARAMETER LoadLookupValues
    The load lookup values switch defines if lookup values should be loaded.

    .PARAMETER SynchronousMode
    The synchronous mode switch defines if the synchronous mode should be used.

    .NOTES
    File name:      Start-GenesisLoader.ps1
    Author:         Florian CARRIER
    Creation date:  11/03/2020
    Last modified:  11/03/2020
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
      Mandatory   = $true,
      HelpMessage = "Name of the result selection"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $ResultSelectionName,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Name of the solve"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $SolveName,
    [Parameter (
      Position    = 9,
      Mandatory   = $true,
      HelpMessage = "Lot type"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Int32]
    $LotType,
    [Parameter (
      Position    = 10,
      Mandatory   = $true,
      HelpMessage = "Valid on date (DD/MM/YYYY [AM | PM] format)"
    )]
    [ValidatePattern ('\d{2}/\d{2}/\d{4} AM|PM')]
    [System.String]
    $ValidOn,
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Name of the technical configuration"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $TechnicalConfiguration,
    [Parameter (
      HelpMessage = "Define if the lookup values should be loaded"
    )]
    [Switch]
    $LoadLookupValues,
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
    $JavaClass = Get-JavaClass -Name "Interfacing"
  }
  Process {
    # Define operation
    $Operation = "startGenesisLoader"
    # Define mandatory operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ic.modelName"             , $ModelName)
    $OperationParameters.Add("ic.resultSelectionName"   , $ResultSelectionName)
    $OperationParameters.Add("ic.solveName"             , $SolveName)
    $OperationParameters.Add("ic.lotType"               , $LotType)
    $OperationParameters.Add("ic.validOn"               , $ValidOn)
    $OperationParameters.Add("ic.loadLookupValues"      , $LoadLookupValues)
    # Define optional operation parameters
    if ($PSBoundParameters.ContainsKey("TechnicalConfiguration")) { $OperationParameters.Add("ic.technicalConfiguration", $TechnicalConfiguration) }
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
