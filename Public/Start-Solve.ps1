function Start-Solve {
  <#
    .SYNOPSIS
    Start solve

    .DESCRIPTION
    Wrapper function to start an analysis using the RiskPro batch client

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

    .PARAMETER ResultSelection
    The result selection parameter corresponds to the name of the analysis to run.

    .PARAMETER AccountStructure
    The account structure parameter corresponds to the name of the financial institution.

    .PARAMETER SolveName
    The solve name parameter corresponds to the label of the process.

    .PARAMETER AnalysisDate
    The optional analysis date parameter corresponds to the date of the analysis. It must be in the following format: dd/MM/YYYY AM/PM.

    .PARAMETER DataGroups
    The optional data groups parameter corresponds to the list of data groups to include in the analysis. The data groups must be separated using the separator specified in the corresponding parameter.

    .PARAMETER DataFilters
    The optional data filters parameter corresponds to the list of data filters to apply for the analysis. The data filters must be separated using the separator specified in the corresponding parameter.

    .PARAMETER Separator
    The optional separator parameter corresponds to the character used to separate items in the lists for data groups and data filters.

    .PARAMETER ErroneousContractGroup
    The optional erroneous contract group parameter corresponds to the name of the data group in which to place contracts which generated errors during processing.

    .PARAMETER TechnicalConfiguration
    The optional technical configuration parameter corresponds to the name of the technical configuration to use.

    .PARAMETER ContractGroupSize
    The optional contract group size parameter corresponds to the number of contracts read and passed to an available calculator for processing.

    .PARAMETER GrapeSize
    The optional grape size parameter corresponds to the number of irreducible sets of linked contracts and counterparties read and passed to an available CALCULATOR instance for processing.

    .PARAMETER Kind
    The kind parameter corresponds to the type of analysis to run.
    Two values are available:
    - Static:   static analysis
    - Dynamic:  dynamic analysis

    .PARAMETER DeleteResults
    The delete results switch defines if the results of a previous solve should be deleted.

    .PARAMETER Persistent
    The persistent results switch defines if the results should be persistently stored in the database.

    .PARAMETER SynchronousMode
    The synchonous mode switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Start-Solve.ps1
    Author:         Florian CARRIER
    Creation date:  22/10/2019
    Last modified:  28/01/2020
    TODO            Add parameter validation

    .LINK
    Invoke-RiskProBatchClient

    .LINK
    Start-StaticSolve

    .LINK
    Start-DynamicSolve
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
      Mandatory   = $true,
      HelpMessage = "Name of the result selection"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ResultSelection,
    [Parameter (
      Position    = 8,
      Mandatory   = $false,
      HelpMessage = "Name of the account structure"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $AccountStructure,
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "Name of the solve"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $SolveName,
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "Date of analysis"
    )]
    # TODO validate format DD/MM/YYYY [AM | PM]
    [ValidateNotNullOrEmpty ()]
    [String]
    $AnalysisDate,
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Name of the data groups"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $DataGroups,
    [Parameter (
      Position    = 12,
      Mandatory   = $false,
      HelpMessage = "List of data filters to apply"
    )]
    [ValidateNotNull ()]
    [String[]]
    $DataFilters,
    [Parameter (
      Position    = 13,
      Mandatory   = $false,
      HelpMessage = "The separator character in lists of values"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Separator,
    [Parameter (
      Position    = 14,
      Mandatory   = $false,
      HelpMessage = "Name of the data group for contracts that generate errors"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ErroneousContractGroup,
    [Parameter (
      Position    = 15,
      Mandatory   = $false,
      HelpMessage = "Name of the technical configuration"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $TechnicalConfiguration,
    [Parameter (
      Position    = 16,
      Mandatory   = $false,
      HelpMessage = "Number of contracts read and passed to an available CALCULATOR for processing"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    $ContractGroupSize,
    [Parameter (
      Position    = 17,
      Mandatory   = $false,
      HelpMessage = "Number of irreducible sets of linked contracts and counterparties read and passed to an available CALCULATOR for processing"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    $GrapeSize,
    [Parameter (
      Position    = 18,
      Mandatory   = $true,
      HelpMessage = "Type of solve"
    )]
    [ValidateSet (
      "Dynamic",
      "Static"
    )]
    [String]
    $Kind,
    [Parameter (
      HelpMessage = "Determines if previous analysis results should be deleted"
    )]
    [Switch]
    $DeleteResults,
    [Parameter (
      HelpMessage = "Determines if calculation results should be persistently stored in the database"
    )]
    [Switch]
    $Persistent,
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
    # Format solve kind
    $Solvekind = Format-String -String $Kind -Format "lowercase"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("sv.modelName", $ModelName)
    $OperationParameters.Add("sv.resultSelectionName", $ResultSelection)
    # Add accout structure (financial institution)
    if ($PSBoundParameters.ContainsKey("AccountStructure")) {
      $OperationParameters.Add("sv.accountStructureName", $AccountStructure)
    }
    # Add solve name
    $OperationParameters.Add("sv.solveName", $SolveName)
    if ($PSBoundParameters.ContainsKey("AnalysisDate")) {
      $OperationParameters.Add("sv.analysisDate", $AnalysisDate)
    }
    # Add list of data groups
    if ($PSBoundParameters.ContainsKey("DataGroups")) {
      $OperationParameters.Add("sv.dataGroupNames", $DataGroups)
    }
    # Add list of data filters
    if ($PSBoundParameters.ContainsKey("DataFilters")) {
      $OperationParameters.Add("sv.dataFilters", $DataFilters)
    }
    # Add separator
    if ($PSBoundParameters.ContainsKey("Separator")) {
      $OperationParameters.Add("sv.separator", $Separator)
    }
    # Add contract group for rejected contracts
    if ($PSBoundParameters.ContainsKey("ErroneousContractGroup")) {
      $OperationParameters.Add("sv.erroneousContractGroup", $ErroneousContractGroup)
    }
    # Add technical configuration
    if ($PSBoundParameters.ContainsKey("TechnicalConfiguration")) {
      $OperationParameters.Add("sv.technicalConfiguration", $TechnicalConfiguration)
    }
    # Add contract group size
    if ($PSBoundParameters.ContainsKey("ContractGroupSize")) {
      $OperationParameters.Add("sv.contractGroupSize", $ContractGroupSize)
    }
    # Add grape size
    if ($PSBoundParameters.ContainsKey("GrapeSize")) {
      $OperationParameters.Add("sv.grapeSize", $GrapeSize)
    }
    $OperationParameters.Add("sv.deleteResults", $DeleteResults)
    $OperationParameters.Add("sv.persistent", $Persitent)
    # Configure syncrhonous mode
    $OperationParameters.Add("ws.sync", $SynchronousMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Define command name
    if ($Kind -eq "Dynamic") {
      $Operation = "startDynamicSolve"
    } elseif ($Kind -eq "Static") {
      $Operation = "startStaticSolve"
    }
    # Run solve
    Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Parameters $Parameters -Class $JavaClass
  }
}
