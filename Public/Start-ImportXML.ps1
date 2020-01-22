function Start-ImportXML {
  # TODO
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param(
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Name of the model to import"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Model,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Name of the process"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Solve,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "Path to the file to import"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $File,
    [Parameter (
      Position    = 3,
      Mandatory   = $false,
      HelpMessage = "Action to perform for model elements"
    )]
    [ValidateSet ("ALL", "MERGE", "NONE")]
    [String]
    $ModelElements = "NONE",
    [Parameter (
      Position    = 4,
      Mandatory   = $false,
      HelpMessage = "Action to perform for observations"
    )]
    [ValidateSet ("INSERT", "UPDATE", "NONE")]
    [String]
    $Observations = "NONE",
    [Parameter (
      Position    = 5,
      Mandatory   = $false,
      HelpMessage = "Action to perform for contracts"
    )]
    [ValidateSet ("INSERT", "UPDATE", "OVERWRITE", "DELETE", "NONE")]
    [String]
    $Contracts = "NONE",
    [Parameter (
      Position    = 6,
      Mandatory   = $false,
      HelpMessage = "Action to perform for conterparties"
    )]
    [ValidateSet ("INSERT", "UPDATE", "OVERWRITE", "DELETE", "NONE")]
    [String]
    $Counterparties = "NONE",
    [Parameter (
      Position    = 7,
      Mandatory   = $false,
      HelpMessage = "Action to perform for business audits"
    )]
    [ValidateSet ("INSERT", "NONE")]
    [String]
    $BusinessAudits = "NONE",
    [Parameter (
      Position    = 8,
      Mandatory   = $false,
      HelpMessage = "Action to perform for libraries"
    )]
    [ValidateSet ("ALL", "NONE")]
    [String]
    $Libraries = "NONE",
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "Define level of detail for logs"
    )]
    [ValidateSet ("ERROR", "WARN", "INFO", "DEBUG")]
    [String]
    $LogLevel = "INFO",
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "Define level of detail for logs"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ForcedDataGroup,
    [Parameter (
      HelpMessage = "Define if a new model should be created"
    )]
    [Switch]
    $NewModel,
    [Parameter (
      HelpMessage = "Define if all expressions should be compiled"
    )]
    [Switch]
    $CompileExpressions,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $SyncMode = $true
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get Java class
    $JavaClass = Get-JavaClass -Name "Interface"
  }
  Process {
    # # Variables
    # $URI = Resolve-URI -URI $Path
    # if ($Remote) {
    #   $URI = "file:///$URI"
    # } else {
    #   # TODO add check if URI is not relative
    #   $URI = "riskpro://$URI"
    # }
    # $ISOTime = Get-Date -Format "yyyy-MM-dd_HHmmss"
    # # Set solve name
    # if ($ForcedDataGroup -ne "") {
    #   $SolveName = "Import_${ForcedDataGroup}_${ISOTime}"
    # } else {
    #   $SolveName = "Import_${Model}_${ISOTime}"
    # }
  	# Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ic.createNew", $NewModel)
    $OperationParameters.Add("ic.modelName", $Model)
    $OperationParameters.Add("ic.solveName", $SolveName)
    $OperationParameters.Add("ic.fileName", $URI)
    $OperationParameters.Add("ic.modelElements", $ModelElements)
    $OperationParameters.Add("ic.observations", $Observations)
    $OperationParameters.Add("ic.contracts", $Contracts)
    $OperationParameters.Add("ic.counterparties", $Counterparties)
    $OperationParameters.Add("ic.businessAudits", $BusinessAudits)
    $OperationParameters.Add("ic.libraries", $Libraries)
    $OperationParameters.Add("ic.logLevel", $LogLevel)
    $OperationParameters.Add("ic.compileAllExpressions", $CompileExpressions)
    $OperationParameters.Add("ic.forcedDataGroupName", $ForcedDataGroup)
    $OperationParameters.Add("ws.sync", $SyncMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Import XML file
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "startImportXML" -Parameters $Parameters -Class $JavaClass
  }
}
