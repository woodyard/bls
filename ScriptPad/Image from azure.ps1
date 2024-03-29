#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

iex (irm az.osdcloud.com)


#================================================
#  [PostOS] AutopilotOOBE CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\System32\OOBE.cmd"
$OOBECMD = @'
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module AutopilotOOBE -Force
Start /Wait PowerShell -NoL -C Install-Module OSD -Force
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/woodyard/bls/main/oobe_dk.ps1
'@
$OOBECMD | Out-File -FilePath 'C:\Windows\System32\OOBE.cmd' -Encoding ascii -Force

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
$SetupCompleteCMD = @'
'@
$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#=======================================================================
#   Enable "Audit process tracking"
#=======================================================================
Write-Host -ForegroundColor Green "Get 'Detailed tracking' properties"
C:\Windows\System32\auditpol.exe /get /category:"Detailed Tracking"

Write-Host -ForegroundColor Green "Enable 'Audit process tracking'"
C:\Windows\System32\auditpol.exe /set /category:"Detailed Tracking" /success:enable

Write-Host -ForegroundColor Green "Get 'Audit process tracking' properties"
C:\Windows\System32\auditpol.exe /get /category:"Detailed Tracking"

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 10 seconds!"
Start-Sleep -Seconds 10
wpeutil reboot
