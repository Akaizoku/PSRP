function Start-ContractSelection {
  <#
    .SYNOPSIS
    Start contract selection

    .DESCRIPTION
    Wrapper function to start the contract selection process using the RiskPro batch client

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

    .PARAMETER AccountStructureName
    The account structure name parameter corresponds to the name of the account structure.

    .PARAMETER ContractSelectionType
    The contract selection type parameter corresponds to the type of contract selection.

    Two values are available:
    - FULL
    - INCREMENTAL

    .PARAMETER SelectedContractGroup
    The optional selected contract group parameter corresponds to the name of the data group in which to place selected contracts.

    .PARAMETER NonSelectedContractGroup
    The optional non-selected data group parameter corresponds to the name of the data group in which to place non-selected contracts.

    .PARAMETER ErroneousContractGroup
    The optional erroneous contract group parameter corresponds to the name of the data group in which to place erroneous contracts.

    .PARAMETER MaxNumberOfErrorsToLog
    The optional maximum number of errors to log parameter corresponds to the maximum number of errors to log.

    .PARAMETER DataGroupNames
    The optional data group names parameter corresponds to the name of the data groups.

    .PARAMETER DataFilters
    The optional data filters parameter corresponds to the name of the data filters.

    .PARAMETER Separator
    The optional separator parameter corresponds to the character used to separate values in lists.

    .PARAMETER SynchronousMode
    The synchronous mode switch defines if the synchronous mode should be used.

    .NOTES
    File name:      Start-ContractSelection.ps1
    Author:         Florian CARRIER
    Creation date:  26/02/2020
    Last modified:  26/02/2020
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
      HelpMessage = "Name of the account structure"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $AccountStructureName,
    [Parameter (
      Position    = 10,
      Mandatory   = $true,
      HelpMessage = "Type of contract selection"
    )]
    [ValidateSet (
      "FULL",
      "INCREMENTAL"
    )]
    [System.String]
    $ContractSelectionType,
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Name of the data group in which to place selected contracts"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $SelectedContractGroup,
    [Parameter (
      Position    = 12,
      Mandatory   = $false,
      HelpMessage = "Name of the data group in which to place non-selected contracts"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $NonSelectedContractGroup,
    [Parameter (
      Position    = 13,
      Mandatory   = $false,
      HelpMessage = "Name of the data group in which to place erroneous contracts"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $ErroneousContractGroup,
    [Parameter (
      Position    = 14,
      Mandatory   = $false,
      HelpMessage = "Maximum number of errors to log"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Int32]
    $MaxNumberOfErrorsToLog,
    [Parameter (
      Position    = 15,
      Mandatory   = $false,
      HelpMessage = "Name of the data groups"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String[]]
    $DataGroupNames,
    [Parameter (
      Position    = 16,
      Mandatory   = $false,
      HelpMessage = "Name of the data filters"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String[]]
    $DataFilters,
    [Parameter (
      Position    = 17,
      Mandatory   = $false,
      HelpMessage = "Character used to separate values in lists"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $Separator,
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
    $Operation = "startContractSelection"
    # Define mandatory operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ic.modelName"             , $ModelName)
    $OperationParameters.Add("ic.resultSelectionName"   , $ResultSelectionName)
    $OperationParameters.Add("ic.solveName"             , $SolveName)
    $OperationParameters.Add("ic.accountStructureName"  , $AccountStructureName)
    $OperationParameters.Add("ic.contractSelectionType" , $ContractSelectionType)
    # Define optional operation parameters
    if ($PSBoundParameters.ContainsKey("SelectedContractGroup"))    { $OperationParameters.Add("ic.selectedContractGroup"     , $SelectedContractGroup) }
    if ($PSBoundParameters.ContainsKey("NonSelectedContractGroup")) { $OperationParameters.Add("ic.nonSelectedContractGroup"  , $NonSelectedContractGroup) }
    if ($PSBoundParameters.ContainsKey("ErroneousContractGroup"))   { $OperationParameters.Add("ic.erroneousContractGroup"    , $ErroneousContractGroup) }
    if ($PSBoundParameters.ContainsKey("MaxNumberOfErrorsToLog"))   { $OperationParameters.Add("ic.maxNumberOfErrorsToLog"    , $MaxNumberOfErrorsToLog) }
    if ($PSBoundParameters.ContainsKey("DataGroupNames"))           { $OperationParameters.Add("ic.dataGroupNames"            , $DataGroupNames) }
    if ($PSBoundParameters.ContainsKey("DataFilters"))              { $OperationParameters.Add("ic.dataFilters"               , $DataFilters) }
    if ($PSBoundParameters.ContainsKey("Separator"))                { $OperationParameters.Add("ic.separator"                 , $Separator) }
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
