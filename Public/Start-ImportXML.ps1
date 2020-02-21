function Start-ImportXML {
  <#
    .SYNOPSIS
    Import XML file

    .DESCRIPTION
    Wrapper function to import data using the RiskPro batch client

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
    The model name parameter corresponds to the name of the model in which to import data.

    .PARAMETER SolveName
    The SOLVE name parameter corresponds to the name of the solve to create.

    .PARAMETER FileName
    The file name parameter corresponds to the path to the file to import.

    .PARAMETER ModelElements
    The model elements parameter corresponds to the import configuration for model elements.

    .PARAMETER Observations
    The observations parameter corresponds to the import configuration for observations.

    .PARAMETER Contracts
    The contracts parameter corresponds to the import configuration for contracts.

    .PARAMETER Counterparties
    The counterparties parameter corresponds to the import configuration for counterparties.

    .PARAMETER BusinessAudits
    The business audits parameter corresponds to the import configuration for business audits.

    .PARAMETER Libraries
    The libraries parameter corresponds to the import configuration for Java libraries.

    .PARAMETER LogLevel
    The log level parameter corresponds to the level of logging desired.

    .PARAMETER ForcedDataGroupName
    The forced data group name corresponds to the name of the data group in which the data should be imported.

    .PARAMETER NewModel
    The new model switch specifies if a new model should be created.

    .PARAMETER CompileAllExpressions
    The compile all expressions switch specifies if all expressions should be compiled.

    .PARAMETER SynchronousMode
    The synchronous mode switch specifies if the synchronous mode should be enabled.

    .NOTES
    File name:      Start-ImportXML.ps1
    Author:         Florian CARRIER
    Creation date:  15/10/2019
    Last modified:  17/02/2020
    TODO            Add unmanaged objects parameters

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
      HelpMessage = "Name of the model to import"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ModelName,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Name of the solve"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $SolveName,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Path to the file to import"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $FileName,
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "Action to perform for model elements"
    )]
    [ValidateSet ("ALL", "MERGE", "NONE")]
    [String]
    $ModelElements = "NONE",
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "Action to perform for observations"
    )]
    [ValidateSet ("INSERT", "UPDATE", "NONE")]
    [String]
    $Observations = "NONE",
    [Parameter (
      Position    = 11,
      Mandatory   = $false,
      HelpMessage = "Action to perform for contracts"
    )]
    [ValidateSet ("INSERT", "UPDATE", "OVERWRITE", "DELETE", "NONE")]
    [String]
    $Contracts = "NONE",
    [Parameter (
      Position    = 12,
      Mandatory   = $false,
      HelpMessage = "Action to perform for conterparties"
    )]
    [ValidateSet ("INSERT", "UPDATE", "OVERWRITE", "DELETE", "NONE")]
    [String]
    $Counterparties = "NONE",
    [Parameter (
      Position    = 13,
      Mandatory   = $false,
      HelpMessage = "Action to perform for business audits"
    )]
    [ValidateSet ("INSERT", "NONE")]
    [String]
    $BusinessAudits = "NONE",
    [Parameter (
      Position    = 14,
      Mandatory   = $false,
      HelpMessage = "Action to perform for libraries"
    )]
    [ValidateSet ("ALL", "NONE")]
    [String]
    $Libraries = "NONE",
    [Parameter (
      Position    = 15,
      Mandatory   = $false,
      HelpMessage = "Define level of detail for logs"
    )]
    [ValidateSet ("ERROR", "WARN", "INFO", "DEBUG")]
    [String]
    $LogLevel = "INFO",
    [Parameter (
      Position    = 16,
      Mandatory   = $false,
      HelpMessage = "Name of the target data group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ForcedDataGroupName,
    [Parameter (
      HelpMessage = "Define if a new model should be created"
    )]
    [Switch]
    $NewModel,
    [Parameter (
      HelpMessage = "Define if all expressions should be compiled"
    )]
    [Switch]
    $CompileAllExpressions,
    [Parameter (
      HelpMessage = "Define if the synchronous mode should be enabled"
    )]
    [Switch]
    $SynchronousMode
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get Java class
    $JavaClass = Get-JavaClass -Name "Interfacing"
    # Prefix file paths with expected scheme (if required)
    if (($FileName -NotMatch '(riskpro\:\/\/).*') -And ($FileName -NotMatch '(file\:\/\/\/).*')) {
      $FileName = [System.String]::Concat("file:///", $FileName)
    }
    # Encode URI
    $FileURI = Resolve-URI -URI $FileName -RestrictedOnly
  }
  Process {
  	# Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ic.createNew"             , $NewModel)
    $OperationParameters.Add("ic.modelName"             , $ModelName)
    $OperationParameters.Add("ic.solveName"             , $SolveName)
    $OperationParameters.Add("ic.fileName"              , $FileURI)
    $OperationParameters.Add("ic.modelElements"         , $ModelElements)
    $OperationParameters.Add("ic.observations"          , $Observations)
    $OperationParameters.Add("ic.contracts"             , $Contracts)
    $OperationParameters.Add("ic.counterparties"        , $Counterparties)
    $OperationParameters.Add("ic.businessAudits"        , $BusinessAudits)
    $OperationParameters.Add("ic.libraries"             , $Libraries)
    $OperationParameters.Add("ic.logLevel"              , $LogLevel)
    $OperationParameters.Add("ic.compileAllExpressions" , $CompileAllExpressions)
    $OperationParameters.Add("ic.forcedDataGroupName"   , $ForcedDataGroupName)
    $OperationParameters.Add("ws.sync"                  , $SynchronousMode)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Import XML file
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "startImportXML" -Parameters $Parameters -Class $JavaClass
  }
}
