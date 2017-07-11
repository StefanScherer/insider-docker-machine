# escape=`
FROM microsoft/windowsservercore AS installer-env
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

ENV VERSION 2.5.4

ENV LIBRESSLPATH C:\libressl

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ; `
  Invoke-WebRequest "https://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-$Env:VERSION-windows.zip" -OutFile libressl.zip -UseBasicParsing ; `
	Expand-Archive libressl.zip -DestinationPath $Env:Temp ; `
	New-Item -ItemType Directory -Path $Env:LIBRESSLPATH ; `
	Copy-Item $Env:Temp\libressl-$Env:VERSION-windows\x64\* $Env:LIBRESSLPATH\. ; `
	Remove-Item $Env:LIBRESSLPATH\*.pdb ; `
	$newPath = ('{0};{1}' -f $Env:LIBRESSLPATH, $Env:PATH); `
	Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment\' -Name Path -Value $newPath ; `
	Remove-Item $Env:Temp\libressl-$Env:VERSION-windows, libressl.zip -Force -Recurse ; `
	New-Item -ItemType Directory -Path $Env:LIBRESSLPATH\ssl

ARG PS_VERSION=6.0.0-beta.3
ARG PS_DOWNLOAD_SHA=FF45FE7D184B50297CA706EFAEA4E37C59807D33577521A715C147BCD5098B01
ENV PS_DOWNLOAD_URL https://github.com/PowerShell/PowerShell/releases/download/v$PS_VERSION/PowerShell-$PS_VERSION-win10-win2016-x64.zip

RUN Invoke-WebRequest $Env:PS_DOWNLOAD_URL -OutFile powershell.zip; `
    if ((Get-FileHash powershell.zip -Algorithm sha256).Hash -ne $Env:PS_DOWNLOAD_SHA) { `
        Write-Host 'CHECKSUM VERIFICATION FAILED!'; `
        exit 1; `
    }; `
    Expand-Archive powershell.zip -DestinationPath \PowerShell; `
    Remove-Item -Force powershell.zip

FROM microsoft/nanoserver

ENV ProgramFiles C:\Program Files
COPY --from=installer-env ["\\PowerShell\\", "$ProgramFiles\\PowerShell"]
ENV PSCORE="$ProgramFiles\PowerShell\PowerShell.exe"
RUN setx /M PATH "%PATH%;%ProgramFiles%\PowerShell;C:\libressl"

COPY --from=installer-env /libressl /libressl

COPY openssl.cnf /libressl/ssl/.
COPY generate-certs.ps1 generate-certs.ps1

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]
CMD . .\generate-certs.ps1
