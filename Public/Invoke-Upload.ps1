function Invoke-Upload {
  <#
    .SYNOPSIS
    Publish file

    .DESCRIPTION
    Wrapper function to upload a file on the server using the RiskPro batch client

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

    .PARAMETER FilePath
    The file path parameter corresponds to the path to the file to upload.

    .PARAMETER DestinationPath
    The destination path parameter corresponds to the server-side destination path of the file.

    .NOTES
    File name:      Invoke-Upload.ps1
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
      HelpMessage = "Path to the file"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $FilePath,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Destination path of the file"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.String]
    $DestinationPath
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Get utilities Java class
    $JavaClass = Get-JavaClass -Name "FileSystem"
    # Prefix file paths with expected scheme (if required)
    if ($FilePath -NotMatch '(file\:\/\/\/).*') {
      $FilePath = [System.String]::Concat("file:///", $FilePath)
    }
    if ($DestinationPath -NotMatch '(riskpro\:\/\/).*') {
      $DestinationPath = [System.String]::Concat("riskpro://", $DestinationPath)
    }
    # Encode URIs
    $FileURI        = Resolve-URI -URI $FilePath        -RestrictedOnly
    $DestinationURI = Resolve-URI -URI $DestinationPath -RestrictedOnly
  }
  Process {
    # Define operation parameters
    $OperationParameters = New-Object -TypeName "System.Collections.Specialized.OrderedDictionary"
    $OperationParameters.Add("fs.sourceFile", $FileURI)
    $OperationParameters.Add("fs.destFile"  , $DestinationURI)
    # Format Java parameters
    $Parameters = ConvertTo-JavaProperty -Properties $OperationParameters
    # Upload file
  	Invoke-RiskProBatchClient -JavaPath $JavaPath -RiskProPath $RiskProBatchClient -ServerURI $ServerURI -Credentials $Credentials -JavaOptions $JavaOptions -Operation "upload" -Parameters $Parameters -Class $JavaClass
  }
}
