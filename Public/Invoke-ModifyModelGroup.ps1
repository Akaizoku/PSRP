function Invoke-ModifyModelGroup {
  <#
    .SYNOPSIS
    Modify model group

    .DESCRIPTION
    Wrapper function to modify an existing model group using the RiskPro batch client

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

    .PARAMETER ModelGroup
    The model group parameter corresponds to the name of the model group to modify.

    .PARAMETER NewName
    The new name parameter corresponds to the new name of the model group.

    .PARAMETER Models
    The models parameter corresponds to the list of models with which to overwrite the existing models in the model group.

    .PARAMETER ModelsToAdd
    The models parameter corresponds to the list of models to add to the model group.

    .PARAMETER ModelsToRemove
    The models parameter corresponds to the list of models to remove to the model group.

    .PARAMETER Synchronous
    The synchonous switch defines if the operation should be run in synchronous mode.

    .NOTES
    File name:      Invoke-ModifyModelGroup.ps1
    Author:         Florian CARRIER
    Creation date:  22/10/2019
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
      HelpMessage = "Name of the model group"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("Name")]
    [String]
    $ModelGroup,
    [Parameter (
      Position    = 7,
      Mandatory   = $false,
      HelpMessage = "New name of the model group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $NewName,
    [Parameter (
      Position    = 8,
      Mandatory   = $false,
      HelpMessage = "List of models to overwrite to the model group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $Models,
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "List of models to add to the model group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $ModelsToAdd,
    [Parameter (
      Position    = 10,
      Mandatory   = $false,
      HelpMessage = "List of models to remove to the model group"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $ModelsToRemove,
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
    # Format models list
    # TODO semicolon separated list of models
  }
  Process {
  	# Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("ad.modelGroupName", $Name)
    $OperationParameters.Add("ad.modelGroupNewName", $NewName)
    if ($PSBoundParameters.ContainsKey("Models"))         { $OperationParameters.Add("ad.models", $Models)                  }
    if ($PSBoundParameters.ContainsKey("ModelsToAdd"))    { $OperationParameters.Add("ad.modelsToAdd", $ModelsToAdd)        }
    if ($PSBoundParameters.ContainsKey("ModelsToRemove")) { $OperationParameters.Add("ad.modelsToRemove", $ModelsToRemove)  }
    # Configure synchronous mode
    $OperationParameters.Add("ws.sync", $Synchronous)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Invoke RiskPro batch client
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "modifyModelGroup" -Parameters $Parameters -Class $JavaClass
  }
}
