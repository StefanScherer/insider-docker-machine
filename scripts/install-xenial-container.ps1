$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

iwr -useb https://chocolatey.org/install.ps1 | iex
choco install -y 7zip

Write-Host Downloading xenial-container
$Root = "$Env:ProgramFiles\Linux Containers"
Invoke-WebRequest -UseBasicParsing -OutFile $Env:Temp\container.vhdx.xz https://partner-images.canonical.com/hyper-v/linux-containers/xenial/current/xenial-container-hyperv.vhdx.xz

7z x $env:TEMP\container.vhdx.xz -o"$Root"

mv "$Root\container.vhdx" "$Root\uvm.vhdx"

rm $Env:Temp\container.vhdx.xz

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
