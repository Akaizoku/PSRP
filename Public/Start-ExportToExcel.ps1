function Start-ExportToExcel {
  <#
    .SYNOPSIS
    Start export to Excel

    .DESCRIPTION
    Wrapper function to export a report to Excel using the RiskPro batch client

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
    File name:      Start-ExportToExcel.ps1
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
      HelpMessage = "Name of the export process job"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $SolveJobName,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Name of the calculation job to export"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ReportedSolveJobName,
    [Parameter (
      Position    = 9,
      Mandatory   = $true,
      HelpMessage = "Type of the solve to export"
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
    $ReportedSolveJobKind,
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "Name of the report to export"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ReportName,
    [Parameter (
      Position    = 11,
      Mandatory   = $true,
      HelpMessage = "Type of the report (see Java documentation for OlapStandardReportType class)"
    )]
    [ValidateSet (
      "BACKTESTED_VAR",
      "CAD_FRTB_CONSO",
      "CAD_FRTB_JTD",
      "CAD_FRTB_MR",
      "CAD_FRTB_MR_FLAT",
      "CAD_IRB_ADVANCED",
      "CAD_IRB_FOUNDATION",
      "CAD_MR_COM",
      "CAD_MR_COM_OVER_TIME",
      "CAD_MR_EQ",
      "CAD_MR_EQ_OVER_TIME",
      "CAD_MR_FX",
      "CAD_MR_FX_OVER_TIME",
      "CAD_MR_IR_GEN",
      "CAD_MR_IR_GEN_OVER_TIME",
      "CAD_MR_IR_SPE",
      "CAD_MR_IR_SPE_OVER_TIME",
      "CAD_MR_OPTIONS",
      "CAD_MR_OPTIONS_OVER_TIME",
      "CAD_PARTIAL_USE",
      "CAD_STANDARD",
      "DEFAULT_REPORT",
      "DYN_MC_STORED_VAR",
      "DYN_MC_STORED_VAR_TAIL",
      "DYNAMIC_BOOK_VALUE",
      "DYNAMIC_FTP",
      "DYNAMIC_FTP_SPREAD",
      "DYNAMIC_IFRS_BOOK_VALUE",
      "DYNAMIC_LIQUIDITY_GAP",
      "DYNAMIC_NPV",
      "DYNAMIC_REPO_POSITIONS",
      "DYNAMIC_REPRICING_GAP",
      "DYNAMIC_SECURITIES_IN_REPOS",
      "DYNAMIC_STOCKFLOW",
      "ECL_ALLOCATION_DETAILS",
      "EXPECTED_CREDIT_LOS_OVER_TIME",
      "EXT_LCR",
      "EXT_LCR_CONSO",
      "EXT_LCR_CONSO_OVER_TIME",
      "EXT_LCR_OVER_TIME",
      "FAKE",
      "FIXING_DATE_GAP",
      "FIXING_DATE_GAP_INTERNAL_VIEW",
      "FIXING_DATE_GAP_OVER_TIME",
      "FIXING_DATE_GAP_OVER_TIME_INTERNAL_VIEW",
      "HEDGE_EFFECTIVENESS_PROSPECTIVE_TEST",
      "HEDGE_RATIO_PROSPECTIVE_TEST",
      "HISTO_PROFIT_AND_LOSS_REPORT",
      "HISTO_VAR_NPV_PURE",
      "HISTO_VAR_NPV_TREAS",
      "HISTORICAL_VAR",
      "HISTORIZED_CONTRACT_RESULTS",
      "HISTORIZED_HEDGE_EFFECTIVENESS_RETROSPECTIVE_TEST",
      "KEY_RATE_OVER_TIME",
      "LCR_LIQUIDITY_GAP_OVER_TIME",
      "LCR_SPECIFIC_LIQUIDITY_GAP",
      "LIQUIDITY_AT_RISK",
      "LIQUIDITY_GAP_OVER_TIME",
      "MC_PROFIT_AND_LOSS_REPORT",
      "MC_VAR_NPV_PURE",
      "MC_VAR_NPV_TREAS",
      "PARAM_VAR_RISK_FACTOR_CATEGORY_DECOMPOSITION",
      "PARAM_VAR_RISK_FACTOR_FULL_DECOMPOSITION",
      "REPO_POSITIONS",
      "REPRICING_GAP_OVER_TIME",
      "SECURITIES_IN_REPOS",
      "SENSITIVITY_GAP_OVER_TIME",
      "SENSITIVTY_GAP",
      "SPREAD_EXPOSURE",
      "SPREAD_EXPOSURE_OVER_TIME",
      "SPREAD_EXPOSURE_OVER_TIME_TYPE_DECOMPOSITION",
      "SPREAD_EXPOSURE_TYPE_DECOMPOSITION",
      "STATIC_BOOK_VALUE",
      "STATIC_COM_EXPOSURE",
      "STATIC_CONTINGENT_GAP",
      "STATIC_CPI_EXPOSURE",
      "STATIC_CREDIT_VALUE_ADJUSTEMENT",
      "STATIC_CRPLUS",
      "STATIC_CURRENT_EXPOSURE",
      "STATIC_EXPECTED_CREDIT_LOSS",
      "STATIC_FTP",
      "STATIC_FX_EXPOSURE",
      "STATIC_IFRS_BOOK_VALUE",
      "STATIC_INCOME_BOOK_VALUE",
      "STATIC_INCOME_FTP",
      "STATIC_INCOME_FTP_SPREAD",
      "STATIC_INCOME_IFRS_BOOK_VALUE",
      "STATIC_INDEX_EXPOSURE",
      "STATIC_KEY_RATE",
      "STATIC_LIQUIDITY_GAP",
      "STATIC_MC_STORED_VAR",
      "STATIC_MC_STORED_VAR_TAIL",
      "STATIC_MONTECARLO",
      "STATIC_NPV",
      "STATIC_REPRICING_GAP",
      "STATIC_VOL_EXPOSURE",
      "STOCHASTIC_PFE",
      "STOCKFLOW",
      "STOCKFLOW_OVER_TIME",
      "STORED_VAR"
    )]
    [String]
    $ReportType,
    [Parameter (
      Position    = 12,
      Mandatory   = $true,
      HelpMessage = "Name of the generated Excel file"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $OutputFileName,
    [Parameter (
      Position    = 13,
      Mandatory   = $false,
      HelpMessage = "Name of the cube definition"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $CubeDefinitionName,
    [Parameter (
      Position    = 14,
      Mandatory   = $false,
      HelpMessage = "MDX query"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $MDXQuery,
    [Parameter (
      Position    = 15,
      Mandatory   = $false,
      HelpMessage = "Path to a file containing a MDX query"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $MDXFileName,
    [Parameter (
      Position    = 16,
      Mandatory   = $false,
      HelpMessage = "Full mnemonic of the account to export"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $AccountMnemonic,
    [Parameter (
      Position    = 17,
      Mandatory   = $false,
      HelpMessage = "Free form footer string to append to the report(s)"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ExtraCopyrightInfo,
    [Parameter (
      Position    = 18,
      Mandatory   = $false,
      HelpMessage = "Title of the report"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Title,
    [Parameter (
      HelpMessage = "Define if numerical figures should be exported with full precision"
    )]
    [Switch]
    $FullPrecision
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get Java class
    $JavaClass = Get-JavaClass -Name "Results"
    # Define operation
    $Operation = "startExportToExcel"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("rs.modelName", $ModelName)
    $OperationParameters.Add("rs.solveJobName", $SolveJobName)
    $OperationParameters.Add("rs.reportedSolveJobName", $ReportedSolveJobName)
    $OperationParameters.Add("rs.reportedSolveJobKind", $ReportedSolveJobKind)
    if ($PSBoundParameters.ContainsKey("ReportName"))         { $OperationParameters.Add("rs.reportName", $ReportName)                  }
    $OperationParameters.Add("rs.reportType", $ReportType)
    $OperationParameters.Add("rs.outputFileName", $OutputFileName)
    if ($PSBoundParameters.ContainsKey("CubeDefinitionName")) { $OperationParameters.Add("rs.cubeDefinitionName", $CubeDefinitionName)  }
    $OperationParameters.Add("rs.fullPrecision", $FullPrecision)
    if ($PSBoundParameters.ContainsKey("MDXQuery"))           { $OperationParameters.Add("rs.mdx", $MDXQuery)                           }
    if ($PSBoundParameters.ContainsKey("MDXFileName"))        { $OperationParameters.Add("rs.mdxFileName", $MDXFileName)                }
    if ($PSBoundParameters.ContainsKey("AccountMnemonic"))    { $OperationParameters.Add("rs.accountMnemonic", $AccountMnemonic)        }
    if ($PSBoundParameters.ContainsKey("ExtraCopyrightInfo")) { $OperationParameters.Add("rs.extraCopyrightInfo", $ExtraCopyrightInfo)  }
    if ($PSBoundParameters.ContainsKey("Title"))              { $OperationParameters.Add("rs.title", $Title)                            }
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Call RiskPro batch client
    if ($PSBoundParameters.ContainsKey("JavaPath")) {
      Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Class $JavaClass
    } else {
      Invoke-RiskProBatchClient -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation $Operation -Class $JavaClass
    }
  }
}
