$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'
stop-service docker
stop-service EventLog -force
Invoke-WebRequest "https://master.dockerproject.org/windows/x86_64/dockerd.exe" -OutFile "$env:ProgramFiles\docker\dockerd.exe" -UseBasicParsing
start-service EventLog
Invoke-WebRequest "https://master.dockerproject.org/windows/x86_64/docker.exe" -OutFile "$env:ProgramFiles\docker\docker.exe" -UseBasicParsing
start-service docker
