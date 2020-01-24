function Invoke-CreateUser {
  <#
    .SYNOPSIS
    Create user

    .DESCRIPTION
    Wrapper function to create a new user using the RiskPro batch client

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

    .PARAMETER UserName
    The user name parameter corresponds to the name of the user to create.

    .PARAMETER EmployeeName
    The employee name parameter corresponds to the full name of the user.

    .PARAMETER UserGroups
    The optional user groups parameter corresponds to the list of user group in which to add the user.

    .NOTES
    File name:      Invoke-CreateUser.ps1
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
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Name of the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("Name")]
    [String]
    $UserName,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Full name of the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("FullName")]
    [String]
    $EmployeeName,
    [Parameter (
      Position    = 7,
      Mandatory   = $false,
      HelpMessage = "List of users groups in which to add the user"
    )]
    [ValidateNotNullOrEmpty ()]
    [String[]]
    $UserGroups
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
    $OperationParameters.Add("ad.userName", $UserName)
    $OperationParameters.Add("ad.employeeName", $EmployeeName)
    if ($PSBoundParameters.ContainsKey("UserGroups")) { $OperationParameters.Add("ad.userGroups", $UserGroups) }
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Create model
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "createUser" -Parameters $Parameters -Class $JavaClass
  }
}
