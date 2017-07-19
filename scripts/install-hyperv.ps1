if ((GWMI Win32_Processor).VirtualizationFirmwareEnabled[0] -and (GWMI Win32_Processor).SecondLevelAddressTranslationExtensions[0]) {
  Write-Host "Install Hyper-V feature"
  Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
} else {
  Write-Host "Skipping installation of Hyper-V feature"
}

# https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/insider-known-issues
Get-ComputeProcess | ? IsTemplate -eq $true | Stop-ComputeProcess -Force
Set-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Virtualization\Containers\' -Name TemplateVmCount -Type dword -Value 0 -Force
