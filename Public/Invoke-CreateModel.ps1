function Invoke-CreateModel {
  <#
    .SYNOPSIS
    Create a model

    .DESCRIPTION
    Wrapper function to create a new model using the RiskPro batch client

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
    The model parameter corresponds to the name of the model to create.

    .PARAMETER Synchronous
    The synchonous switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Invoke-CreateModel.ps1
    Author:         Florian CARRIER
    Creation date:  22/10/2019
    Last modified:  22/01/2020
    TODO            Add parameter validation
    WARNING         Synchronous mode not supported for operation 'createModel'!
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
    [Alias ("Name")]
    [String]
    $Model,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Type of model"
    )]
    [ValidateSet (
      "Production",
      "Historisation",
      "Historization",
      "Archive"
    )]
    [String]
    $Type,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Description of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Description,
    [Parameter (
      Position    = 9,
      Mandatory   = $true,
      HelpMessage = "Base currency of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Currency,
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "Fiscal year anchor date"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $FiscalYearStart,
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Business year anchor date"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $BusinessYearStart,
    [Parameter (
      Position    = 12,
      Mandatory   = $false,
      HelpMessage = "Name of the reference model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ReferenceModel,
    [Parameter (
      Position    = 13,
      Mandatory   = $false,
      HelpMessage = "Name of the owner of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Owner,
    [Parameter (
      Position    = 14,
      Mandatory   = $false,
      HelpMessage = "Name of the model group in which to set the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ModelGroup,
    [Parameter (
      Position    = 15,
      Mandatory   = $false,
      HelpMessage = "Name of the template model to use"
    )]
    [ValidateSet (
      "EMPTY",
      "IFRS",
      "CAD_Model",
      "LIQUIDITY_TEMPLATE_WITH_CONTRACTS",
      "INSURANCE_TEMPLATE_WITH_CONTRACTS",
      "ALM_TEMP_1_1_WITH_CONTRACTS",
      "SAMPLE_MODEL"
    )]
    [String]
    $Template,
    [Parameter (
      Position    = 16,
      Mandatory   = $false,
      HelpMessage = "Name of the historisation model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $HistorisationModel,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $SynchronousMode = $true
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get administration Java class
    $JavaClass = Get-JavaClass -Name "Administration"
    # Format model type
    if ($Type -eq "Historisation") {
      $Type = "Historization"
    }
    $ModelType = Format-String -String $Type -Format "Uppercase"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ad.name", $Model)
    $OperationParameters.Add("ad.modelType", $ModelType)
    $OperationParameters.Add("ad.description", $Description)
    $OperationParameters.Add("ad.baseCurrency", $Currency)
    $OperationParameters.Add("ad.fiscalYearStart", $FiscalYearStart)
    $OperationParameters.Add("ad.businessYearStart", $BusinessYearStart)
    if ($PSBoundParameters.ContainsKey("ReferenceModel"))     { $OperationParameters.Add("ad.referenceModelName", $ReferenceModel)          }
    if ($PSBoundParameters.ContainsKey("Owner"))              { $OperationParameters.Add("ad.owner", $Owner)                                }
    if ($PSBoundParameters.ContainsKey("ModelGroup"))         { $OperationParameters.Add("ad.modelGroupName", $ModelGroup)                  }
    if ($PSBoundParameters.ContainsKey("Template"))           { $OperationParameters.Add("ad.factoryType", $Template)                       }
    if ($PSBoundParameters.ContainsKey("HistorisationModel")) { $OperationParameters.Add("ad.historizationModelName", $HistorisationModel)  }
    # Configure syncrhonous mode
    $OperationParameters.Add("ws.sync", $SynchronousMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Create model
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "createModel" -Parameters $Parameters -Class $JavaClass
  }
}
