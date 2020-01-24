function Test-Solve {
  <#
    .SYNOPSIS
    Check solve

    .DESCRIPTION
    Wrapper function to check if an analysis exists using the RiskPro batch client

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

    .PARAMETER Model
    The model parameter corresponds to the name model containing the analysis to check.

    .PARAMETER Solve
    The solve parameter corresponds to the name of the analysis to check.

    .PARAMETER Kind
    The kind parameter corresponds to the kind of the analysis to check.
    The available values are the following (see technical reference):
    - BACKTESTING: VaR Backtesting
    - CLEAN_ROLLUP: Cleaning of rollup results
    - CONTRACT_AGGREGATION: Contract aggregation
    - CONTRACT_SELECTION: Contract selection
    - COVARIANCE_MATRIX_GENERATION: Covariance matrix generation
    - CREDIT_SCORING_DATA_LOADER: Credit score data loading
    - DYNAMIC_MC: Dynamic Monte-Carlo analysis
    - DYNAMIC: Dynamic analysis
    - FINANCIAL_STUDIO_LOADER: FDA loading
    - FLAT_FILE_LOADER: V2.6 flat file loading
    - GENESIS_LOADER: DataFoundation loading
    - INCREMENTAL_RESULT_AGGREGATION: Incremental analysis aggregation
    - MC_SCENARIO: Monte-Carlo scenario generation
    - MODEL_EXPORT: Model export
    - MODEL_IMPORT: Model import
    - PDF_REPORT: PDF report export
    - PROSPECTIVE_HEDGE_TEST: Prospective hedge testing
    - RESULT_AGGREGATION: Analysis aggregation
    - RETROSPECTIVE_HEDGE_TEST: Retrospective hedge testing
    - RISK_METRICS: RiskMetric matrix loading
    - ROLLUP: Rollup
    - SCENARIO_REPORT: Scenario report
    - SELECTION_REPORT: Selection report
    - STATIC_SCENARIO: Static scenario generation
    - STATIC_VAR_SCENARIO: Static VaR scenario generation
    - STATIC: Static analysis
    - WHATIF_SCENARIO: What-if scenario generation
    - XL_IMPORT: Excel import
    - XL_REPORT: Excel report export
    - XL_TEMPLATE_REPORT: Excel template reporting

    .PARAMETER Synchronous
    The synchonous switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Test-Solve.ps1
    Author:         Florian CARRIER
    Creation date:  23/10/2019
    Last modified:  23/10/2019
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
    $Model,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Name of the analysis"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Solve,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Solve kind"
    )]
    [ValidateSet (
      "BACKTESTING",
      "CLEAN_ROLLUP",
      "CONTRACT_AGGREGATION",
      "CONTRACT_SELECTION",
      "COVARIANCE_MATRIX_GENERATION",
      "CREDIT_SCORING_DATA_LOADER",
      "DYNAMIC_MC",
      "DYNAMIC",
      "FINANCIAL_STUDIO_LOADER",
      "FLAT_FILE_LOADER",
      "GENESIS_LOADER",
      "INCREMENTAL_RESULT_AGGREGATION",
      "MC_SCENARIO",
      "MODEL_EXPORT",
      "MODEL_IMPORT",
      "PDF_REPORT",
      "PROSPECTIVE_HEDGE_TEST",
      "RESULT_AGGREGATION",
      "RETROSPECTIVE_HEDGE_TEST",
      "RISK_METRICS",
      "ROLLUP",
      "SCENARIO_REPORT",
      "SELECTION_REPORT",
      "STATIC_SCENARIO",
      "STATIC_VAR_SCENARIO",
      "STATIC",
      "WHATIF_SCENARIO",
      "XL_IMPORT",
      "XL_REPORT",
      "XL_TEMPLATE_REPORT"
    )]
    [String]
    $Kind,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $Synchronous
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get administration Java class
    $JavaClass = Get-JavaClass -Name "Utilities"
  }
  Process {
    # Query solve
  	$GetSolveID = Get-SolveID -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Solve $Solve -Kind $Kind -Synchronous:$Synchronous
    # Return outcome
    return (Test-RiskProBatchClientOutcome -Log $GetSolveID)
  }
}
