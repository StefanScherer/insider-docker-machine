param ([String] $machineHome, [String] $machineName, [String] $machineIp)

if (!(Test-Path $env:USERPROFILE\.docker)) {
  mkdir $env:USERPROFILE\.docker
}

$ips = ((Get-NetIPAddress -AddressFamily IPv4).IPAddress) -Join ','

if (!$machineIp) {
  $machineIp=(Get-NetIPAddress -AddressFamily IPv4 `
    | Where-Object -FilterScript { `
      ( ! ($_.InterfaceAlias).StartsWith("vEthernet (HNS Internal NIC)") ) `
      -And $_.IPAddress -Ne "127.0.0.1" `
      -And $_.IPAddress -Ne "10.0.2.15" `
    }).IPAddress
}

$homeDir = $machineHome
if ($machineHome.startsWith('/')) {
  $homeDir = "C:$machineHome" # /Users/stefan from Mac -> C:/Users/stefan
}

docker run --rm `
  -e SERVER_NAME=$(hostname) `
  -e IP_ADDRESSES=$ips `
  -e MACHINE_HOME=$machineHome `
  -e MACHINE_NAME=$machineName `
  -e MACHINE_IP=$machineIp `
  -v "$env:USERPROFILE\.docker:C:\Users\ContainerAdministrator\.docker" `
  -v "$env:USERPROFILE\.docker:C:\machine\.docker" `
  -v "C:\ProgramData\docker:C:\ProgramData\docker" `
  stefanscherer/dockertls-windows:insider

rm -recurse "$homeDir\.docker\machine\machines\$machineName"
Copy-Item -Recurse "$env:USERPROFILE\.docker\machine\machines\$machineName" "$homeDir\.docker\machine\machines\$machineName"

Write-host Restarting Docker
stop-service docker
dockerd --unregister-service
dockerd --register-service
start-service docker

Write-Host Opening Docker TLS port
& netsh advfirewall firewall add rule name="Docker TLS" dir=in action=allow protocol=TCP localport=2376
