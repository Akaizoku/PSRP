function Invoke-MigratorTool {
  <#
    .SYNOPSIS
    Call RiskPro Migrator tool

    .DESCRIPTION
    Wrapper function to create a call the RiskPro Migrator tool batch client

    .PARAMETER JavaPath
    The optional java path parameter corresponds to the path to the Java executable file. If not specified, please ensure that the path environment variable contains the Java home.

    .PARAMETER MigratorTool
    The migrator tool parameter corresponds to the path to the RiskPro migrator tool.

    .PARAMETER DatabaseVendor
    The database vendor parameter corresponds to the type of the database.
    Two values are supported:
    - oracle: Oracle database
    - mssql:  Microsoft SQL Server database

    .PARAMETER DatabaseHost
    The database host parameter corresponds to the hostname of the database server.

    .PARAMETER DatabasePort
    The database port parameter corresponds to the database port to reach the database server.

    .PARAMETER DatabaseInstance
    The database instance parameter corresponds to the RiskPro database instance to upgrade.

    .PARAMETER Version
    The version parameter corresponds to the target version of RiskPro for the upgrade

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the RiskPro account to use for the operation.

    .PARAMETER Operation
    The operation parameter corresponds to the command to execute.

    .PARAMETER Parameters
    The parameters parameter corresponds to the list of parameters to use for the operation.

    .PARAMETER Class
    The class parameter corresponds to the Java class to use for the operation.

    .PARAMETER Log
    The optional log parameter corresponds to the path to the file in which to write the migration logs.

    .NOTES
    File name:      Invoke-RiskProBatchClient.ps1
    Author:         Florian CARRIER
    Creation date:  26/11/2019
    Last modified:  22/01/2020
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
    [String]
    $JavaPath,
    [Parameter (
      Position    = 2,
      Mandatory   = $true,
      HelpMessage = "RiskPro Migrator tool path"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    [Alias ('Path', 'MigratorToolPath')]
    $MigratorTool,
    [Parameter (
      Position    = 3,
      Mandatory   = $true,
      HelpMessage = "Database vendor"
    )]
    [ValidateSet (
      'oracle',
      'mssql'
    )]
    [String]
    [Alias ('Vendor')]
    $DatabaseVendor,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Database server hostname"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    [Alias ('Hostname')]
    $DatabaseHost,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Database server port"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    [Alias ('Port')]
    $DatabasePort,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Database instance name"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    [Alias ('InstanceName')]
    $DatabaseInstance,
    [Parameter (
      Position    = 7,
      Mandatory   = $true,
      HelpMessage = "Target version"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Version,
    [Parameter (
      Position    = 8,
      Mandatory   = $true,
      HelpMessage = "Credentials of the database user"
    )]
    [ValidateNotNullOrEmpty ()]
    [System.Management.Automation.PSCredential]
    $Credentials,
    [Parameter (
      Position    = 9,
      Mandatory   = $false,
      HelpMessage = "Log output path"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    $Log,
    [Parameter (
      HelpMessage = "Specify that the database is using partitioning"
    )]
    [Switch]
    $Partitioning,
    [Parameter (
      HelpMessage = "Specify that the database has been backed-up"
    )]
    [Switch]
    $Backup,
    [Parameter (
      HelpMessage = "Run migrator tool in simulation mode"
    )]
    [Switch]
    $Simulation,
    [Parameter (
      HelpMessage = "Suppress console output"
    )]
    [Switch]
    $Silent
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
    # Ceck Java path parameter
    if (-Not ($PSBoundParameters.ContainsKey('JavaPath'))) {
      # If not specified, use Path environment variable
      $JavaPath = "java"
    }
  }
  Process {
    # Build command
    if ($PSBoundParameters.ContainsKey("Log")) {
      $Command = Write-MigratorToolCmd -JavaPath $JavaPath -MigratorTool $MigratorTool -Vendor $DatabaseVendor -Hostname $DatabaseHost -Port $DatabasePort -Instance $DatabaseInstance -Version $Version -Credentials $Credentials -Log $Log -Partitioning:$Partitioning -Backup:$Backup -Simulation:$Simulation -Silent:$Silent
    } else {
      $Command = Write-MigratorToolCmd -JavaPath $JavaPath -MigratorTool $MigratorTool -Vendor $DatabaseVendor -Hostname $DatabaseHost -Port $DatabasePort -Instance $DatabaseInstance -Version $Version -Credentials $Credentials -Partitioning:$Partitioning -Backup:$Backup -Simulation:$Simulation -Silent:$Silent
    }
    # Run migrator tool
	  $Output = Invoke-Expression -Command $Command | Out-String
    Write-Log -Type "DEBUG" -Object $Output
    # Return RiskPro migrator tool output
    return $Output
  }
}
