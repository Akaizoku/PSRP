function Get-JavaClass {
  <#
    .SYNOPSIS
    Get Java class

    .DESCRIPTION
    Return the full name of a Java class

    .PARAMETER Class
    The class parameter corresponds to the short name (or type) of the Java class.

    .INPUTS
    System.String. You can pipe the class name to Get-JavaClass.

    .OUTPUTS
    System.String. Get-JavaClass returns the full name of the Java class.

    .NOTES
    File name:      Get-JavaClass.ps1
    Author:         Florian Carrier
    Creation date:  21/10/2019
    Last modified:  16/01/2020
  #>
  [CmdletBinding(
    SupportsShouldProcess = $true
  )]
  Param (
    [Parameter (
      Position    = 1,
      Mandatory   = $true,
      HelpMessage = "Name of the Java class",
      ValueFromPipeline               = $true,
      ValueFromPipelineByPropertyName = $true
    )]
    [ValidateSet (
      "Administration",
      "FileSystem",
      "Interfacing",
      "Monitoring",
      "Results",
      "Solve",
      "Utilities",
      "WorkspaceManagement"
    )]
    [String]
    $Name
  )
  Begin {
    # Get global preference variables
    Get-CallerPreference -Cmdlet $PSCmdlet -SessionState $ExecutionContext.SessionState
  }
  Process {
    switch ($Name) {
      "Administration"      { $Class = "com.frsglobal.pub.batch.client.cli.AdministrationClient"      }
      "FileSystem"          { $Class = "com.frsglobal.pub.batch.client.cli.FileSystemClient"          }
      "Interfacing"         { $Class = "com.frsglobal.pub.batch.client.cli.InterfacingClient"         }
      "Monitoring"          { $Class = "com.frsglobal.pub.batch.client.cli.MonitoringClient"          }
      "Results"             { $Class = "com.frsglobal.pub.batch.client.cli.ResultsClient"             }
      "Solve"               { $Class = "com.frsglobal.pub.batch.client.cli.SolveClient"               }
      "Utilities"		        { $Class = "com.frsglobal.pub.batch.client.cli.UtilitiesClient"           }
      "WorkspaceManagement" { $Class = "com.frsglobal.pub.batch.client.cli.WorkspaceManagementClient" }
    }
    # Return Java class full name
    return $Class
  }
}
