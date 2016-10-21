[CmdletBinding()]
param(
    [string]$server,
    [string]$appPoolName
)

Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Internal"
Import-Module "Microsoft.TeamFoundation.DistributedTask.Task.Common"

Write-Verbose "Entering script $($MyInvocation.MyCommand.Name)"
Write-Verbose "Parameter Values"
$PSBoundParameters.Keys | % { Write-HOST "  ${_} = $($PSBoundParameters[$_])" }
$command = {
    param(
        [string]$appPoolName
    )
    Import-Module WebAdministration
    Write-Host "Start Application Pool Task: Starting..."
    $appPoolPath = "IIS:\AppPools\$AppPoolName"    
    if(Test-Path $appPoolPath) {
        Write-Host "Checking Application Pool State..."
	    $ApplicationPoolStatus = Get-WebAppPoolState $appPoolName
        if ($ApplicationPoolStatus.Value -ne "Started")
	    {
            Write-Host "Starting application pool: $appPoolName"
            Start-WebAppPool -Name $appPoolName
	    } else {
            Write-Host "Application pool already running."
        }
    } else {
        Write-Host "Application pool not found: $appPoolName"
    }
    Write-Host "Start Application Pool Task: Completed"
}
Invoke-Command -ComputerName $server $command -ArgumentList $appPoolName