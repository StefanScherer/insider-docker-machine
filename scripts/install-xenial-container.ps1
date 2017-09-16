$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Root = "$Env:ProgramFiles\Linux Containers"
if (!(Test-Path $Root)) {
  mkdir $Root
  # Give the virtual machines group full control
  $acl = Get-Acl -Path $Root
  $vmGroupRule = new-object System.Security.AccessControl.FileSystemAccessRule("NT VIRTUAL MACHINE\Virtual Machines", "FullControl","ContainerInherit,ObjectInherit", "None", "Allow")
  $acl.SetAccessRule($vmGroupRule)
  Set-Acl -AclObject $acl -Path $Root
}

iwr -useb https://chocolatey.org/install.ps1 | iex
choco install -y 7zip

Write-Host Downloading xenial-container
Invoke-WebRequest -UseBasicParsing -OutFile $Env:Temp\container.xz https://partner-images.canonical.com/hyper-v/linux-containers/xenial/current/xenial-container-hyperv.vhdx.xz

7z x $env:TEMP\container.vhdx.xz -o"$Root"

mv "$Root\container.vhdx" "$Root\uvm.vhdx"

rm $Env:Temp\container.xz

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
