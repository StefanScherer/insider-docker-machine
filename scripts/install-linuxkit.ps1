$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Root = "$Env:ProgramFiles\Linux Containers"
Invoke-WebRequest -UseBasicParsing -OutFile $Env:Temp\linuxkit.zip https://github.com/friism/linuxkit/releases/download/preview-1/linuxkit.zip

Expand-Archive $Env:Temp\linuxkit.zip -DestinationPath "$Env:ProgramFiles\Linux Containers"
rm $Env:Temp\linuxkit.zip

Write-Host "Activating experimental features"
$daemonJson = "$env:ProgramData\docker\config\daemon.json"
$config = @{}
if (Test-Path $daemonJson) {
  $config = (Get-Content $daemonJson) -join "`n" | ConvertFrom-Json
}
$config = $config | Add-Member(@{ experimental = $true }) -Force -PassThru
$config | ConvertTo-Json | Set-Content $daemonJson -Encoding Ascii

[Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")

Write-Host "Now restart the Docker engine to run LCOW"
