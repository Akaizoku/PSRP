function Grant-Role {
  <#
    .SYNOPSIS
    Grant role

    .DESCRIPTION
    Wrapper function to grant role using the RiskPro batch client

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
    The model name parameter corresponds to the name of the model on which to grant permissions.

    .PARAMETER ModelGroupName
    The model group name parameter corresponds to the name of the model group on which to grant permissions.

    .PARAMETER RoleName
    The role name parameter corresponds to the name of the role to grant.

    .PARAMETER UserName
    The user name parameter corresponds to the name of the user to grant permissions to.

    .PARAMETER UserGroupName
    The user group name parameter corresponds to the name of the user group to grant permissions to.

    .NOTES
    File name:      Grant-Role.ps1
    Author:         Florian CARRIER
    Creation date:  23/01/2020
    Last modified:  23/01/2020
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
      Position          = 6,
      Mandatory         = $true,
      HelpMessage       = "Name of the model",
      ParameterSetName  = "model-user"
    )]
    [Parameter (
      Position          = 6,
      Mandatory         = $true,
      HelpMessage       = "Name of the model",
      ParameterSetName  = "model-usergroup"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ModelName,
    [Parameter (
      Position          = 6,
      Mandatory         = $true,
      HelpMessage       = "Name of the model group",
      ParameterSetName  = "modelgroup-user"
    )]
    [Parameter (
      Position          = 6,
      Mandatory         = $true,
      HelpMessage       = "Name of the model group",
      ParameterSetName  = "modelgroup-usergroup"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $ModelGroupName,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Name of the role"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $RoleName,
    [Parameter (
      Position          = 8,
      Mandatory         = $true,
      HelpMessage       = "Name of the user",
      ParameterSetName  = "model-user"
    )]
    [Parameter (
      Position          = 8,
      Mandatory         = $true,
      HelpMessage       = "Name of the user",
      ParameterSetName  = "modelgroup-user"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $UserName,
    [Parameter (
      Position          = 8,
      Mandatory         = $true,
      HelpMessage       = "Name of the user group",
      ParameterSetName  = "model-usergroup"
    )]
    [Parameter (
      Position          = 8,
      Mandatory         = $true,
      HelpMessage       = "Name of the user group",
      ParameterSetName  = "modelgroup-usergroup"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $UserGroupName
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get administration Java class
    $JavaClass = Get-JavaClass -Name "Administration"
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    if ($PSBoundParameters.ContainsKey("ModelName"))      { $OperationParameters.Add("ad.modelName", $ModelName)            }
    if ($PSBoundParameters.ContainsKey("ModelGroupName")) { $OperationParameters.Add("ad.modelGroupName", $ModelGroupName)  }
    $OperationParameters.Add("ad.roleName", $RoleName)
    if ($PSBoundParameters.ContainsKey("UserName"))       { $OperationParameters.Add("ad.userName", $UserName)              }
    if ($PSBoundParameters.ContainsKey("UserGroupName"))  { $OperationParameters.Add("ad.groupName", $UserGroupName)        }
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Create model
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "grantRole" -Parameters $Parameters -Class $JavaClass
  }
}
