function Invoke-ModifyModel {
  <#
    .SYNOPSIS
    Modify a model

    .DESCRIPTION
    Wrapper function to modify an existing model using the RiskPro batch client

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
    The model parameter corresponds to the name of the model to modify.

    .PARAMETER SynchronousMode
    The synchonous mode switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Invoke-ModifyModel.ps1
    Author:         Florian CARRIER
    Creation date:  23/10/2019
    Last modified:  22/01/2020
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
      HelpMessage = "Name of the owner of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Owner,
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Name of the historisation model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $HistorisationModel,
    [Parameter (
      Position    = 12,
      Mandatory   = $false,
      HelpMessage = "New name of the model"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $NewName,
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
    $JavaClass = Get-JavaClass -Name "Administration"
    # Format model type
    $ModelType = Format-String -String $Type -Format "Uppercase"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ad.name", $Model)
    $OperationParameters.Add("ad.modelType", $ModelType)
    $OperationParameters.Add("ad.description", $Description)
    $OperationParameters.Add("ad.baseCurrency", $Currency)
    if ($PSBoundParameters.ContainsKey("Owner"))              { $OperationParameters.Add("ad.owner", $Owner)                                }
    if ($PSBoundParameters.ContainsKey("HistorisationModel")) { $OperationParameters.Add("ad.historizationModelName", $HistorisationModel)  }
    if ($PSBoundParameters.ContainsKey("NewName"))            { $OperationParameters.Add("ad.modelNewName", $NewName)                       }
    # Configure syncrhonous mode
    $OperationParameters.Add("ws.sync", $Synchronous)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Invoke RiskPro batch client
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "modifyModel" -Parameters $Parameters -Class $JavaClass
  }
}
