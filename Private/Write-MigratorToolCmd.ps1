function Write-MigratorToolCmd {
  <#
    .SYNOPSIS
    Write RiskPro Migrator tool command

    .DESCRIPTION
    Construct command line to call the RiskPro Migrator tool

    .PARAMETER JavaPath
    The optional java path parameter corresponds to the path to the Java executable file. If not specified, please ensure that the path environment variable contains the Java home.

    .PARAMETER MigratorTool
    The migrator tool parameter corresponds to the path to the RiskPro migrator tool.

    .PARAMETER Vendor
    The vendor parameter corresponds to the type of the database.
    Two values are supported:
    - oracle: Oracle database
    - mssql:  Microsoft SQL Server database

    .PARAMETER Hostname
    The hostname parameter corresponds to the hostname of the database server.

    .PARAMETER Port
    The port parameter corresponds to the database port to reach the database server.

    .PARAMETER Database
    The database parameter corresponds to the RiskPro database instance to upgrade.

    .PARAMETER Version
    The version parameter corresponds to the target version of RiskPro for the upgrade.

    .PARAMETER Credentials
    The credentials parameter corresponds to the credentials of the database account to use for the operation.

    .PARAMETER Log
    The optional log parameter corresponds to the path to the file in which to write the migration logs.

    .PARAMETER Partitioning
    The partitioning switch specifies that the database is using partitioning.

    .PARAMETER Backup
    The backup switch specifies that the database has been backed up.

    .PARAMETER Simulation
    The simulation switch allows the execution of the migrator tool in simulation mode.

    .NOTES
    File name:      Write-MigratorToolCmd.ps1
    Author:         Florian CARRIER
    Creation date:  26/11/2019
    Last modified:  22/01/2020
  #>
  [CmdletBinding()]
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
    [Alias ('DatabaseVendor')]
    $Vendor,
    [Parameter (
      Position    = 4,
      Mandatory   = $true,
      HelpMessage = "Database server hostname"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    [Alias ('DatabaseHostname')]
    $Hostname,
    [Parameter (
      Position    = 5,
      Mandatory   = $true,
      HelpMessage = "Database server port"
    )]
    [ValidateNotNullOrEmpty ()]
    [Int]
    [Alias ('DatabasePort')]
    $Port,
    [Parameter (
      Position    = 6,
      Mandatory   = $true,
      HelpMessage = "Database instance name"
    )]
    [ValidateNotNullOrEmpty ()]
    [String]
    [Alias ('DatabaseInstanceName')]
    $Instance,
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
    # Redirect errors to standard output pipeline
    $Redirection = "2>&1"
  }
  Process {
    # Define command parameters
    $CommandParameters = "-databaseVendor ""$Vendor"" -databaseHostname ""$Hostname"" -databasePort ""$Port"" -databaseInstanceName ""$Instance"" -targetVersion ""$Version"" -username ""$($Credentials.UserName)"" -password ""$($Credentials.GetNetworkCredential().Password)"" -partitioning ""$Partitioning"" -databaseWasBackedUp ""$Backup"" -simulation ""$Simulation"""
    # Add log path
    if ($PSBoundParameters.ContainsKey("Log")) {
      $CommandParameters = $CommandParameters + " -Djava.util.logging.FileHandler.pattern=""$Log"""
    }
    # Silent switch
    if ($Silent) {
      $CommandParameters = $CommandParameters + " $Redirection"
    }
    # Write call to batch client
    $Command = "& ""$JavaPath"" -jar ""$MigratorTool"" -automatic $CommandParameters"
    # Debugging with obfuscation
    Write-Log -Type "DEBUG" -Object $Command -Obfuscate $Credentials.GetNetworkCredential().Password
    # Return command line
    return $Command
  }
}
