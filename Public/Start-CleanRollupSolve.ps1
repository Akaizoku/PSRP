function Start-CleanRollupSolve {
  <#
    .SYNOPSIS
    Start roll-up solve

    .DESCRIPTION
    Wrapper function to start a clean-roll-up solve using the RiskPro batch client

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
    The optional result selection name parameter corresponds to the name of the analysis to run.

    .PARAMETER SolveName
    The solve name parameter corresponds to the label of the process.

    .PARAMETER TechnicalConfiguration
    The optional technical configuration parameter corresponds to the name of the technical parameter definition.

    .PARAMETER BeginDate
    The begin date parameter corresponds to the begin date for the purge operation.

    .PARAMETER EndDate
    The end date parameter corresponds to the end date for the purge operation.

    .PARAMETER SynchronousMode
    The synchonous mode switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Start-CleanRollupSolve.ps1
    Author:         Florian CARRIER
    Creation date:  21/02/2020
    Last modified:  21/02/2020

    .LINK
    Invoke-RiskProBatchClient
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
      HelpMessage = "Name of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ModelName,
    [Parameter (
      Position    = 7,
      Mandatory   = $false,
      HelpMessage = "Name of the result selection"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ResultSelectionName,
    [Parameter (
      Position    = 9,
      Mandatory   = $true,
      HelpMessage = "Name of the solve"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $SolveName,
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "Name of the technical configuration"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $TechnicalConfiguration,
    [Parameter (
      Position    = 10,
      Mandatory   = $true,
      HelpMessage = "Begin date"
    )]
    # TODO validate format DD/MM/YYYY [AM | PM]
    [ValidateNotNullOrEmpty ()]
    [String]
    $BeginDate,
    [Parameter (
      Position    = 11,
      Mandatory   = $true,
      HelpMessage = "End date"
    )]
    # TODO validate format DD/MM/YYYY [AM | PM]
    [ValidateNotNullOrEmpty ()]
    [String]
    $EndDate,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $SynchronousMode
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get administration Java class
    $JavaClass = Get-JavaClass -Name "Solve"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("sv.modelName", $ModelName)
    if ($PSBoundParameters.ContainsKey("ResultSelectionName"))    { $OperationParameters.Add("sv.resultSelectionName", $ResultSelectionName) }
    $OperationParameters.Add("sv.solveName", $SolveName)
    if ($PSBoundParameters.ContainsKey("TechnicalConfiguration")) { $OperationParameters.Add("sv.technicalConfiguration", $TechnicalConfiguration) }
    $OperationParameters.Add("sv.beginDate", $BeginDate)
    $OperationParameters.Add("sv.endDate", $EndDate)
    # Configure syncrhonous mode
    $OperationParameters.Add("ws.sync", $SynchronousMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Run solve
    Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "startCleanRollupSolve" -Parameters $Parameters -Class $JavaClass
  }
}
