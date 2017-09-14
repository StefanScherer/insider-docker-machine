$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

mkdir "$Env:ProgramFiles\Linux Containers"

Invoke-WebRequest -UseBasicParsing -OutFile $Env:Temp\linuxkit.zip https://github.com/friism/linuxkit/releases/download/preview-1/linuxkit.zip

Expand-Archive $Env:Temp\linuxkit.zip -DestinationPath "$Env:ProgramFiles\Linux Containers"
rm $Env:Temp\linuxkit.zip

[Environment]::SetEnvironmentVariable("LCOW_SUPPORTED", "1", "Machine")

Write-Host "Now restart the Docker engine to run LCOW"
