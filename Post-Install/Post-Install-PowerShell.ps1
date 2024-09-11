Write-Output " - Removing Packages..."
Start-Sleep 2
Get-AppxProvisionedPackage -Online |
Where-Object -Property 'DisplayName' -In -Value @(
'Microsoft.Microsoft3DViewer';
'Microsoft.BingSearch';
'Microsoft.WindowsCalculator';
'Microsoft.WindowsCamera';
'Clipchamp.Clipchamp';
'Microsoft.WindowsAlarms';
'Microsoft.549981C3F5F10';
'Microsoft.Windows.DevHome';
'MicrosoftCorporationII.MicrosoftFamily';
'Microsoft.WindowsFeedbackHub';
'Microsoft.GetHelp';
'microsoft.windowscommunicationsapps';
'Microsoft.WindowsMaps';
'Microsoft.ZuneVideo';
'Microsoft.BingNews';
'Microsoft.MicrosoftOfficeHub';
'Microsoft.Office.OneNote';
'Microsoft.OutlookForWindows';
'Microsoft.Paint';
'Microsoft.MSPaint';
'Microsoft.People';
'Microsoft.Windows.Photos';
'Microsoft.PowerAutomateDesktop';
'MicrosoftCorporationII.QuickAssist';
'Microsoft.SkypeApp';
'Microsoft.MicrosoftSolitaireCollection';
'Microsoft.MicrosoftStickyNotes';
'MSTeams';
'Microsoft.Getstarted';
'Microsoft.Todos';
'Microsoft.WindowsSoundRecorder';
'Microsoft.BingWeather';
'Microsoft.ZuneMusic';
'Microsoft.WindowsTerminal';
'Microsoft.Xbox.TCUI';
'Microsoft.XboxApp';
'Microsoft.XboxGameOverlay';
'Microsoft.XboxGamingOverlay';
'Microsoft.XboxIdentityProvider';
'Microsoft.XboxSpeechToTextOverlay';
'Microsoft.GamingApp';
'Microsoft.YourPhone';
'Microsoft.MicrosoftEdge';
'Microsoft.MicrosoftEdge.Stable';
'Microsoft.MicrosoftEdge_8wekyb3d8bbwe';
'Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe';
'Microsoft.MicrosoftEdgeDevToolsClient_1000.19041.1023.0_neutral_neutral_8wekyb3d8bbwe';
'Microsoft.MicrosoftEdge_44.19041.1266.0_neutral__8wekyb3d8bbwe';
'Microsoft.OneDrive';
'Microsoft.MicrosoftEdgeDevToolsClient';
'Microsoft.549981C3F5F10';
'Microsoft.MixedReality.Portal';
'Microsoft.Windows.Ai.Copilot.Provider';
'Microsoft.WindowsMeetNow';
) | Remove-AppxProvisionedPackage -AllUsers -Online

Get-WindowsCapability -Online |
Where-Object -FilterScript {
($_.Name -split '~')[0] -in @(
'Browser.InternetExplorer';
'MathRecognizer';
'OpenSSH.Client';
'Microsoft.Windows.MSPaint';
'Microsoft.Windows.PowerShell.ISE';
'App.Support.QuickAssist';
'App.StepsRecorder';
'Media.WindowsMediaPlayer';
'Microsoft.Windows.WordPad';
 );
} | Remove-WindowsCapability -Online

Write-Output " - Adding Shivaay Folder and Shortcuts on Desktop..."
Start-Sleep 2

# Define the desktop and shell
$desktopPath = [System.IO.Path]::Combine($env:UserProfile, "Desktop")
$shell = New-Object -ComObject WScript.Shell

# Create Shivaay Folders in Desktop
$shivaayPath = New-Item -Path $desktopPath -Name "Shivaay" -ItemType Directory -Force
$optimizationPath = New-Item -Path $shivaayPath -Name "Optimizations" -ItemType Directory -Force
$securityPath = New-Item -Path $shivaayPath -Name "Security" -ItemType Directory -Force
$softwaresPath = New-Item -Path $shivaayPath -Name "Softwares" -ItemType Directory -Force
$managementPath = New-Item -Path $shivaayPath -Name "System Management" -ItemType Directory -Force
$interfacePath = New-Item -Path $shivaayPath -Name "User Interface" -ItemType Directory -Force

function Create-Shortcut {
param (
[string]$target,
[string]$shortcutName,
[string]$shortcutType
)
$shortcutPath = Join-Path $desktopPath $shortcutName
$softPath = Join-Path $softwaresPath $shortcutName
if ($shortcutType -eq "url") {
$internetShortcut = $shell.CreateShortcut($softPath)
$internetShortcut.TargetPath = $target
$internetShortcut.Save()
} else {
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-NoProfile -ExecutionPolicy Bypass -Command `"$target`""
$shortcut.Save()
$bytes = [System.IO.File]::ReadAllBytes($shortcutPath)
$bytes[0x15] = $bytes[0x15] -bor 0x20
[System.IO.File]::WriteAllBytes($shortcutPath, $bytes)
}
}

# Create WinUtil-CTT and Activate Windows shortcut
$winUtilCommand = "irm https://christitus.com/win | iex"
Create-Shortcut -target $winUtilCommand -shortcutName 'WinUtil-CTT.lnk'
$activatedCommand = "irm https://get.activated.win | iex"
Create-Shortcut -target $activatedCommand -shortcutName 'Activate-Windows.lnk'

# Softwares
# Game Bar
$gameBar = "ms-windows-store://pdp/?productid=9nzkpstsnw4p"
Create-Shortcut -target $gameBar -shortcutName 'XBOX GameBar.url' -shortcutType "url"

# AMD Radeon Software
$amdRadeon = "ms-windows-store://pdp/?productid=9nz1bjqn6bhl"
Create-Shortcut -target $amdRadeon -shortcutName 'AMD Radeon Software.url' -shortcutType "url"

# Microsoft Tips
$msTips = "ms-windows-store://pdp/?productid=9wzdncrdtbjj"
Create-Shortcut -target $msTips -shortcutName 'Microsoft Tips.url' -shortcutType "url"

# Edge WebView
$edgeWebview = "https://developer.microsoft.com/en-us/microsoft-edge/webview2/"
Create-Shortcut -target $edgeWebview -shortcutName 'Edge WebView2.url' -shortcutType "url"

# Hi-Bit Uninstaller
$hibitUninstaller = "https://hibitsoft.ir/"
Create-Shortcut -target $hibitUninstaller -shortcutName 'Hi-Bit Uninstaller.url' -shortcutType "url"

# Security
# Toggle Defender
$Defender = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
    echo Please Run as Administrator.
    pause & exit
)
set reg1="HKLM\SYSTEM\CurrentControlSet\Services\Sense"
set reg2="HKLM\SYSTEM\CurrentControlSet\Services\WdBoot"
set reg3="HKLM\SYSTEM\CurrentControlSet\Services\WdFilter"
set reg4="HKLM\SYSTEM\CurrentControlSet\Services\WdNisDrv"
set reg5="HKLM\SYSTEM\CurrentControlSet\Services\WdNisSvc"
set reg6="HKLM\SYSTEM\CurrentControlSet\Services\WinDefend"
set reg7="HKLM\SYSTEM\CurrentControlSet\Services\MDCoreSvc"
set reg8="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
set reg9="HKCR\*\shellex\ContextMenuHandlers\EPP"
set reg10="HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\InprocServer32"
set reg11="HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}\Version"
set reg12="HKCR\Directory\shellex\ContextMenuHandlers\EPP"
set reg13="HKCR\Drive\shellex\ContextMenuHandlers\EPP"
set reg14="HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}"
set reg15="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Virus and threat protection"
set reg16="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
set reg17="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender"
set reg18="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine"
set reg19="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection"
bcdedit | findstr /i "safeboot"
if %ERRORLEVEL% EQU 0 (
if "%~n0"=="Enable - Defender" (
reg add %reg1% /v Start /t REG_DWORD /d 2 /f
reg add %reg2% /v Start /t REG_DWORD /d 0 /f
reg add %reg3% /v Start /t REG_DWORD /d 0 /f
reg add %reg4% /v Start /t REG_DWORD /d 2 /f
reg add %reg5% /v Start /t REG_DWORD /d 2 /f
reg add %reg6% /v Start /t REG_DWORD /d 2 /f
reg add %reg7% /v Start /t REG_DWORD /d 2 /f
reg add %reg8% /v "SecurityHealth" /t REG_SZ /d "%windir%\system32\SecurityHealthSystray.exe" /f
reg add %reg9% /ve /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
reg add %reg10% /ve /d "C:\\Program Files\\Windows Defender\\shellext.dll" /f
reg add %reg10% /v "ThreadingModel" /d "Apartment" /f
reg add %reg11% /ve /d "10.0.18362.1" /f
reg add %reg12% /ve /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
reg add %reg13% /ve /d "{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
reg delete %reg15% /v "UILockdown" /f
reg add %reg16% /v "SmartScreenEnabled" /t REG_SZ /d "Warn" /f
reg add %reg17% /v "PUAProtection" /t REG_DWORD /d 1 /f
reg add %reg18% /v "MpEnablePus" /t REG_DWORD /d 1 /f
reg delete %reg19% /v "UILockdown" /f
ren "%~dpnx0" "Disable - Defender.cmd"
) else (
reg add %reg1% /v Start /t REG_DWORD /d 4 /f
reg add %reg2% /v Start /t REG_DWORD /d 4 /f
reg add %reg3% /v Start /t REG_DWORD /d 4 /f
reg add %reg4% /v Start /t REG_DWORD /d 4 /f
reg add %reg5% /v Start /t REG_DWORD /d 4 /f
reg add %reg6% /v Start /t REG_DWORD /d 4 /f
reg add %reg7% /v Start /t REG_DWORD /d 4 /f
reg delete %reg8% /v "SecurityHealth" /f
reg delete %reg9% /f
reg delete %reg14% /f
reg delete %reg12% /f
reg delete %reg13% /f
reg add %reg15% /v UILockdown /t REG_DWORD /d 1 /f
reg add %reg16% /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add %reg17% /v "PUAProtection" /t REG_DWORD /d 0 /f
reg add %reg18% /v "MpEnablePus" /t REG_DWORD /d 0 /f
reg add %reg19% /v "UILockdown" /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Enable - Defender.cmd"
)
bcdedit /deletevalue {current} safeboot
shutdown /r /t 3
) else (
echo  1. To Toggle On/Off Defender I will boot into safemode.
echo  2. After Booting into safemode run this script again.
pause
bcdedit /set {current} safeboot minimal
shutdown /r /t 3
)
"@
$toggleDefender = [System.IO.Path]::Combine($securityPath, 'Enable - Defender.cmd')
$Defender | Out-File -FilePath $toggleDefender -Encoding ASCII

# Toggle Core Isolation - Memory Integrity 
$memoryIntegrity = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable - Core Isolation" (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /f
set st="Disable - Core Isolation.cmd"
) else (
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d 1 /f
set st="Enable - Core Isolation.cmd"
)
ren "%~dpnx0" %st% & echo Restart to apply changes.
"@
$toggleMemoryIntegrity = [System.IO.Path]::Combine($securityPath, 'Enable - Core Isolation.cmd')
$memoryIntegrity | Out-File -FilePath $toggleMemoryIntegrity -Encoding ASCII

# Toggle Fault Tolerant Heap (FTH)
$faultHeapToggle = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable - Fault Tolerant Heap" (
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d 1 /f
set st="Disable - Fault Tolerant Heap.cmd"
) else (
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d 0 /f
set st="Enable - Fault Tolerant Heap.cmd"
)
ren "%~dpnx0" %st%
"@
$faultHeapPath = [System.IO.Path]::Combine($securityPath, 'Enable - Fault Tolerant Heap.cmd')
$faultHeapToggle | Out-File -FilePath $faultHeapPath -Encoding ASCII

# Show/Hide Unused Security Pages
$UnusedSecurityPages = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Hide - Unused Security Pages" (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /t REG_DWORD /d 1 /f
set st="Show - Unused Security Pages.cmd"
) else (
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /f
set st="Hide - Unused Security Pages.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleUnusedSecurityPages = [System.IO.Path]::Combine($securityPath, 'Show - Unused Security Pages.cmd')
$UnusedSecurityPages | Out-File -FilePath $toggleUnusedSecurityPages -Encoding ASCII

# System Management
# Toggle Hibernation and Fast Startup
$hibernationToggle = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Hibernation and Fast Startup" (
powercfg /hibernate on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
set st="Disable Hibernation and Fast Startup.cmd"
) else (
powercfg /hibernate off
set st="Enable Hibernation and Fast Startup.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleHibernation = [System.IO.Path]::Combine($managementPath, 'Enable Hibernation and Fast Startup')
$hibernationToggle | Out-File -FilePath "$toggleHibernation.cmd" -Encoding ASCII

# Toggle GameDVR
$gameDVR = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable GameDVR" (
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 1 /f
set st="Disable GameDVR.cmd"
) else (
reg delete "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /f
reg delete "HKCU\System\GameConfigStore" /v GameDVR_Enabled /f
reg delete "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /f
reg delete "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /f
reg delete "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /f
set st="Enable GameDVR.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleGameDVR = [System.IO.Path]::Combine($managementPath, 'Enable GameDVR')
$gameDVR | Out-File -FilePath "$toggleGameDVR.cmd" -Encoding ASCII

# Toggle Windows Search Indexing Service
$searchService = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Search Indexing" (
sc config WSearch start=auto
net start WSearch
set st="Disable Search Indexing.cmd"
) else (
net stop WSearch
sc config WSearch start=disabled
set st="Enable Search Indexing.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleSearchService = [System.IO.Path]::Combine($managementPath, 'Enable Search Indexing')
$searchService | Out-File -FilePath "$toggleSearchService.cmd" -Encoding ASCII

# Toggle Notifications and Background Apps
$notificationToggle = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Notifications and Background Apps" (
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 0 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 0 /f
set st="Disable Notifications and Background Apps.cmd"
) else (
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
set st="Enable Notifications and Background Apps.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleNotification = [System.IO.Path]::Combine($managementPath, 'Enable Notifications and Background Apps')
$notificationToggle | Out-File -FilePath "$toggleNotification.cmd" -Encoding ASCII

# Toggle Windows Printer Spooler Service
$spoolerService = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Printer Spooler" (
sc config Spooler start=auto
net start Spooler
set st="Disable Printer Spooler.cmd"
) else (
net stop Spooler
sc config Spooler start=disabled
set st="Enable Printer Spooler.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleSpoolerService = [System.IO.Path]::Combine($managementPath, 'Enable Printer Spooler')
$spoolerService | Out-File -FilePath "$toggleSpoolerService.cmd" -Encoding ASCII

# Optimizations
# Toggle Update Notifications
$updateNotifications = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Update Notifications" (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetAutoRestartNotificationDisable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v RestartNotificationsAllowed2 /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetUpdateNotificationLevel /t REG_DWORD /d 1 /f
set st="Disable Update Notifications.cmd"
) else (
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetAutoRestartNotificationDisable /f
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v RestartNotificationsAllowed2 /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v SetUpdateNotificationLevel /f
set st="Enable Update Notifications.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleUpdateNotifications = [System.IO.Path]::Combine($optimizationPath, 'Enable Update Notifications.cmd')
$updateNotifications | Out-File -FilePath $toggleUpdateNotifications -Encoding ASCII

# Toggle Automatic Folder Discovery
$automaticFolder = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Automatic Folder Discovery" (
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /t REG_DWORD /d 0 /f
set st="Disable Automatic Folder Discovery.cmd"
) else (
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /f
set st="Enable Automatic Folder Discovery.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleAutomaticFolder = [System.IO.Path]::Combine($optimizationPath, 'Enable Automatic Folder Discovery.cmd')
$automaticFolder | Out-File -FilePath $toggleAutomaticFolder -Encoding ASCII

# Toggle Last Access Time Stamp and 8.3 Char Length File Name Creation
$toggleFileSystemSettings = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Disable Last Access Time and 8.3 Name" (
fsutil behavior set disableLastAccess 1
fsutil behavior set disable8dot3 1
set st="Enable Last Access Time and 8.3 Name.cmd"
) else (
fsutil behavior set disableLastAccess 0
fsutil behavior set disable8dot3 0
set st="Disable Last Access Time and 8.3 Name.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleFileSystemSettingsPath = [System.IO.Path]::Combine($optimizationPath, 'Enable Last Access Time and 8.3 Name.cmd')
$toggleFileSystemSettings | Out-File -FilePath $toggleFileSystemSettingsPath -Encoding ASCII

# Toggle Multi-Plane Overlay
$toggleOverlayTestMode = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable Multi-Plane Overlay" (
reg delete "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /f
set st="Disable Multi-Plane Overlay.cmd"
) else (
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /t REG_DWORD /d 5 /f
set st="Enable Multi-Plane Overlay.cmd"
)
ren "%~dpnx0" %st%
"@
$toggleOverlayTestModePath = [System.IO.Path]::Combine($optimizationPath, 'Enable Multi-Plane Overlay.cmd')
$toggleOverlayTestMode | Out-File -FilePath $toggleOverlayTestModePath -Encoding ASCII

# User Interface
# Toggle Gallery in File Explorer
$toggleGalleryExplorer = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Show - Gallery In File Explorer" (
reg add "HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f
set st="Hide - Gallery In File Explorer.cmd"
) else (
reg delete "HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v System.IsPinnedToNameSpaceTree /f
set st="Show - Gallery In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleGalleryExplorerPath = [System.IO.Path]::Combine($interfacePath, 'Show - Gallery In File Explorer.cmd')
$toggleGalleryExplorer | Out-File -FilePath $toggleGalleryExplorerPath -Encoding ASCII

# Toggle Network Navigation Pane in File Explorer
$toggleNetworkNavigation = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Show - Network Navigation In File Explorer" (
reg add "HKCU\SOFTWARE\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v System.IsPinnedToNameSpaceTree /t REG_SZ /d "1" /f
set st="Hide - Network Navigation In File Explorer.cmd"
) else (
reg delete "HKCU\SOFTWARE\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v System.IsPinnedToNameSpaceTree /f
set st="Show - Network Navigation In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleNetworkNavigationPath = [System.IO.Path]::Combine($interfacePath, 'Show - Network Navigation In File Explorer.cmd')
$toggleNetworkNavigation | Out-File -FilePath $toggleNetworkNavigationPath -Encoding ASCII

# Toggle Removable Drives in File Explorer
$toggleRemovableDrives = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Show - Removable Drives In File Explorer Quick Access" (
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /ve /d "Removable Drives" /f
reg add "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /ve /d "Removable Drives" /f
set st="Hide - Removable Drives In File Explorer Quick Access.cmd"
) else (
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /v /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /v /f
set st="Show - Removable Drives In File Explorer Quick Access.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleRemovableDrivesPath = [System.IO.Path]::Combine($interfacePath, 'Show - Removable Drives In File Explorer Quick Access.cmd')
$toggleRemovableDrives | Out-File -FilePath $toggleRemovableDrivesPath -Encoding ASCII

# Toggle Context Menu
$contextMenu = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Enable - NEW Context Menu" (
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
set st="Enable - OLD Context Menu.cmd"
) else (
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f
set st="Enable - NEW Context Menu.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleContextMenuPath = [System.IO.Path]::Combine($interfacePath, 'Enable - NEW Context Menu.cmd')
$contextMenu | Out-File -FilePath $toggleContextMenuPath -Encoding ASCII

# Change New Folder Name
$FolderName = @"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "RenameNameTemplate" /t REG_SZ /d %~n0 /f
"@
$NewFolderName = [System.IO.Path]::Combine($interfacePath, 'Change Me and Run to Change Default New Folder Name.cmd')
$FolderName | Out-File -FilePath $NewFolderName -Encoding ASCII

# Toggle Recent Items in Windows
$toggleRecentItems = @"
@echo off & net session >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set srt=%~n0
if "%srt%"=="Disable - Recent Items" (
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f
set st="Enable - Recent Items.cmd"
) else (
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /f
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /f
reg delete "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "1" /f
set st="Disable - Recent Items.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
$toggleRecentItemsPath = [System.IO.Path]::Combine($interfacePath, 'Enable - Recent Items.cmd')
$toggleRecentItems | Out-File -FilePath $toggleRecentItemsPath -Encoding ASCII

Write-Output " - Running Various Tweaks..."
Start-Sleep 2

# Enables .NET Framework 3.5
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:X:\sources\sxs /LimitAccess

# Configure Maximum Password Age in Windows
net.exe accounts /maxpwage:UNLIMITED

# Allow Execution of PowerShell Script Files
Set-ExecutionPolicy -Scope 'LocalMachine' -ExecutionPolicy 'AllSigned' -Force

# Groups or splits svchost.exe processes based on the amount of physical memory in the system to optimize performance
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
$icaclsCommand = "icacls `"$autoLoggerDir`" /deny SYSTEM:`"(OI)(CI)F`""
Invoke-Expression $icaclsCommand | Out-Null

# Disable Defender Auto Sample Submission
Set-MpPreference -SubmitSamplesConsent 2 -ErrorAction Continue | Out-Null

# Removes Microsoft Edge
foreach ($line in $lines) {
if ($line -like '*Architecture : *') {
$architecture = $line -replace 'Architecture : ',''
# If the architecture is x64, replace it with amd64
if ($architecture -eq 'x64') {
$architecture = 'amd64'
}
Write-Host "Architecture: $architecture"
break
}
}

if (-not $architecture) {
Write-Host "Architecture information not found."
}
Remove-Item -Path "C:\Program Files (x86)\Microsoft\Edge" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeWebView" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeUpdate" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Program Files (x86)\Microsoft\EdgeCore" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Users\Public\Desktop\Microsoft Edge.lnk" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Microsoft Edge.lnk" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Windows\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" -Recurse -Force -ErrorAction Continue
Remove-Item -Path "C:\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe" -Recurse -Force -ErrorAction Continue

if ($architecture -eq 'amd64') {
$folderPath = Get-ChildItem -Path "C:\Windows\WinSxS" -Filter "amd64_microsoft-edge-webview_31bf3856ad364e35*" -Directory | Select-Object -ExpandProperty FullName

if ($folderPath) {
& 'takeown' '/f' $folderPath '/r' 
& icacls $folderPath "/grant" "$($adminGroup.Value):(F)" '/T' '/C' 
Remove-Item -Path $folderPath -Recurse -Force 
} else {
Write-Host "Folder not found."
}
} elseif ($architecture -eq 'arm64') {
$folderPath = Get-ChildItem -Path "C:\Windows\WinSxS" -Filter "arm64_microsoft-edge-webview_31bf3856ad364e35*" -Directory | Select-Object -ExpandProperty FullName

if ($folderPath) {
& 'takeown' '/f' $folderPath '/r'
& icacls $folderPath"/grant" "$($adminGroup.Value):(F)" '/T' '/C' 
Remove-Item -Path $folderPath -Recurse -Force 
} else {
Write-Host "Folder not found."
}
} else {
Write-Host "Unknown architecture: $architecture"
}
& 'takeown' '/f' "C:\Windows\System32\Microsoft-Edge-Webview" '/r' 
& 'icacls' "C:\Windows\System32\Microsoft-Edge-Webview" '/grant' "$($adminGroup.Value):(F)" '/T' '/C' 
Remove-Item -Path "C:\Windows\System32\Microsoft-Edge-Webview" -Recurse -Force

# Removes OneDrive
Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.lnk" -ErrorAction Continue
Remove-Item "C:\Users\Default\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\OneDrive.exe" -ErrorAction Continue
Remove-Item "C:\Windows\System32\OneDriveSetup.exe" -ErrorAction Continue
Remove-Item "C:\Windows\SysWOW64\OneDriveSetup.exe" -ErrorAction Continue
 
# Removes Microsoft Teams
$TeamsPath = [System.IO.Path]::Combine($env:LOCALAPPDATA, 'Microsoft', 'Teams')
$TeamsUpdateExePath = [System.IO.Path]::Combine($TeamsPath, 'Update.exe')

Stop-Process -Name "*teams*" -Force -ErrorAction Continue

if ([System.IO.File]::Exists($TeamsUpdateExePath)) {
# Uninstall app
$proc = Start-Process $TeamsUpdateExePath "-uninstall -s" -PassThru
$proc.WaitForExit()
}

Get-AppxPackage "*Teams*" | Remove-AppxPackage -ErrorAction Continue
Get-AppxPackage "*Teams*" -AllUsers | Remove-AppxPackage -AllUsers -ErrorAction Continue

if ([System.IO.Directory]::Exists($TeamsPath)) {
Remove-Item $TeamsPath -Force -Recurse -ErrorAction Continue
}

# Uninstall from Uninstall registry key UninstallString
$us = (Get-ChildItem -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall, HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall | Get-ItemProperty | Where-Object { $_.DisplayName -like '*Teams*'}).UninstallString
if ($us.Length -gt 0) {
$us = ($us.Replace('/I', '/uninstall ') + ' /quiet').Replace('', ' ')
$FilePath = ($us.Substring(0, $us.IndexOf('.exe') + 4).Trim())
$ProcessArgs = ($us.Substring($us.IndexOf('.exe') + 5).Trim().replace('', ' '))
$proc = Start-Process -FilePath $FilePath -Args $ProcessArgs -PassThru
$proc.WaitForExit()
}

# Disable Teredo
$registryKeysTeredo = @(
@{Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"; Name = "DisabledComponents"; Type = "DWord"; Value = 1}
)
foreach ($key in $registryKeysTeredo) {
New-ItemProperty -Path $key.Path -Name $key.Name -PropertyType $key.Type -Value $key.Value -Force
}
netsh interface teredo set state disabled

# "Disable Telemetry"
# "Disable Scheduled Tasks"
$scheduledTasks = @(
"Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
"Microsoft\Windows\Application Experience\ProgramDataUpdater",
"Microsoft\Windows\Autochk\Proxy",
"Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
"Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
"Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
"Microsoft\Windows\Feedback\Siuf\DmClient",
"Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
"Microsoft\Windows\Windows Error Reporting\QueueReporting",
"Microsoft\Windows\Application Experience\MareBackup",
"Microsoft\Windows\Application Experience\StartupAppTask",
"Microsoft\Windows\Application Experience\PcaPatchDbTask",
"Microsoft\Windows\Maps\MapsUpdateTask"
)
foreach ($task in $scheduledTasks) {
schtasks /Change /TN $task /Disable
}

# Disable Reserved Storage (To free up some space)
DISM /Online /Set-ReservedStorageState /State:Disabled
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ReserveManager" /v "ShippedWithReserves" /t REG_DWORD /d 0 /f

Write-Output " - Setting Various Services to Manual..."
Start-Sleep 2

# Set Services to Manual
Set-Service -Name 'AJRouter' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'ALG' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppIDSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppMgmt' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppReadiness' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppVClient' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'AppXSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Appinfo' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AssignedAccessManagerSvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'AudioEndpointBuilder' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'AudioSrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Audiosrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'AxInstSV' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BDESVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BFE' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'BITS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BTAGService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BcastDVRUserService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BrokerInfrastructure' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Browser' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BthAvctpSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'BthHFSrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CDPSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CDPUserSvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'COMSysApp' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CaptureService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CertPropSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ClipSVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ConsentUxUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CoreMessagingRegistrar' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CredentialEnrollmentManagerUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CryptSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CscService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DPS' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DcomLaunch' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DcpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevQueryBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceAssociationBrokerSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceAssociationService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceInstall' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevicePickerUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevicesFlowUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Dhcp' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DiagTrack' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'DialogBlockingService' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'DispBrokerDesktopSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DisplayEnhancementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DmEnrollmentSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Dnscache' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DoSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DsSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DsmSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DusmSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'EFS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EapHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EntAppSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EventLog' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'EventSystem' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'FDResPub' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Fax' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'FontCache' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'FrameServer' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'FrameServerMonitor' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'GraphicsPerfSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HomeGroupListener' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HomeGroupProvider' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HvHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IEEtwCollectorService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IKEEXT' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'InstallService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'InventorySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IpxlatCfgSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'KeyIso' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'KtmRm' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'LSM' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LanmanServer' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LanmanWorkstation' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LicenseManager' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'LxpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MSDTC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MSiSCSI' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MapsBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'McpManagementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MessagingService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MicrosoftEdgeElevationService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MixedRealityOpenXRSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MpsSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'MsKeyboardFilter' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NPSMSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NaturalAuthentication' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcbService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcdAutoSetup' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NetSetupSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NetTcpPortSharing' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'Netlogon' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Netman' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NgcCtnrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NgcSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NlaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'OneSyncSvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'P9RdrService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PNRPAutoReg' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PNRPsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PcaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PeerDistSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PenService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PerfHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PhoneSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PimIndexMaintenanceSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PlugPlay' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PolicyAgent' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Power' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'PrintNotify' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PrintWorkflowUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ProfSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'PushToInstall' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'QWAVE' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RasAuto' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RasMan' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RemoteAccess' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'RemoteRegistry' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'RetailDemo' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RmSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RpcEptMapper' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'RpcLocator' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RpcSs' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SCPolicySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SCardSvr' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SDRSVC' -StartupType Manual -ErrorAction Continue 
Set-Service -Name 'SEMgrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SENS' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SNMPTRAP' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SNMPTrap' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SSDPSRV' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SamSs' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'ScDeviceEnum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Schedule' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SecurityHealthService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Sense' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensorDataService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensorService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SessionEnv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SgrmBroker' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SharedAccess' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SharedRealitySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ShellHWDetection' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SmsRouter' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Spooler' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SstpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StateRepository' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StiSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StorSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SysMain' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SystemEventsBroker' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TabletInputService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TapiSrv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TermService' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TextInputManagementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Themes' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TieringEngineService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TimeBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TimeBrokerSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TokenBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TrkWks' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TroubleshootingSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TrustedInstaller' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UI0Detect' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UdkUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UevAgentService' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'UmRdpService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UnistoreSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UserDataSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UserManager' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'UsoSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VGAuthService' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'VMTools' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'VSS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VacSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VaultSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'W32Time' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WEPHOSTSVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WFDSConMgrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WMPNetworkSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WManSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WPDBusEnum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WSService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WSearch' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'WaaSMedicSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WalletService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WarpJITSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WbioSrvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Wcmsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WcsPlugInService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdNisSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdiServiceHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdiSystemHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WebClient' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Wecsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WerSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WiaRpc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WinDefend' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WinHttpAutoProxySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WinRM' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Winmgmt' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WlanSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WpcMonSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WpnService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WpnUserService_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WwanSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XblAuthManager' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XblGameSave' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XboxGipSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XboxNetApiSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'autotimesvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'bthserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'camsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'cbdhsvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'cloudidsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dcsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'defragsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'diagnosticshub.standardcollector.service' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'diagsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dmwappushservice' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dot3svc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'edgeupdate' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'edgeupdatem' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'embeddedmode' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'fdPHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'fhsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'gpsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'hidserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'icssvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'iphlpsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'lfsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'lltdsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'lmhosts' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'mpssvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'msiserver' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'netprofm' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'nsi' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'p2pimsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'p2psvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'perceptionsimulation' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'pla' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'seclogon' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'shpamsvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'smphost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'spectrum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'sppsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ssh-agent' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'svsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'swprv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'tiledatamodelsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'tzautoupdate' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'uhssvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'upnphost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vds' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vm3dservice' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicguestinterface' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicheartbeat' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmickvpexchange' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicrdv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicshutdown' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmictimesync' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicvmsession' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicvss' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmvss' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wbengine' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wcncsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'webthreatdefsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'webthreatdefusersvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'wercplsupport' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wisvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wlidsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wlpasvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wmiApSrv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'workfolderssvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wuauserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wudfsvc' -StartupType Manual -ErrorAction Continue