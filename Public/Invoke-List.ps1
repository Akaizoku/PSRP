function Invoke-List {
  <#
    .SYNOPSIS
    List files

    .DESCRIPTION
    Wrapper function to list files on the server using the RiskPro batch client

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

    .PARAMETER Directory
    The directory parameter corresponds to the path to the directory to inspect.

    .NOTES
    File name:      Invoke-List.ps1
    Author:         Florian CARRIER
    Creation date:  17/02/2020
    Last modified:  17/02/2020
  #>
  [CmdletBinding (
    SupportsShouldProcess = $true
  )]
  Param (
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
      HelpMessage = "Path to the directory to inspect"
    )]
    [ValidateNotNullOrEmpty ()]
    [Alias ("File")]
    [System.String]
    $Directory
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get utilities Java class
    $JavaClass = Get-JavaClass -Name "FileSystem"
    # Prefix directory path with expected scheme (if required)
    if ($Directory -NotMatch '(riskpro\:\/\/).*') {
      $Directory = [System.String]::Concat("riskpro://", $Directory)
    }
    # Encode URI
    $DirectoryURI = Resolve-URI -URI $Directory -RestrictedOnly
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("fs.file", $DirectoryURI)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # List files
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "list" -Parameters $Parameters -Class $JavaClass
  }
}
