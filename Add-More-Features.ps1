# 0+ Check if the script is running with administrative privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Re-launch the script with elevated privileges
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 1+ Directories and Functions
$desktopPath = "C:\Users\Public\Desktop"
$customPath = "HKLM:\Software\ShivaayOS"
if (Test-Path $customPath) {
    $shivaayPath = (Get-ItemProperty -Path $customPath -Name "ShivaayFolderPath")."ShivaayFolderPath"
} else {
    $shivaayPath = "$desktopPath\Shivaay"
}
$optimizationPath = "$shivaayPath\Optimizations"
$securityPath = "$shivaayPath\Security"
$softwaresPath = "$shivaayPath\Softwares"
$managementPath = "$shivaayPath\System Management"
$interfacePath = "$shivaayPath\User Interface"

# 1.1+ Create Shortcut
function Create-Shortcut {
  param (
    [string]$target,
    [string]$shortcutName,
    [string]$shortcutType,
    [string]$shortcutPath = $shivaayPath
    )
  $shell = New-Object -ComObject WScript.Shell
  $fullPath = Join-Path $shortcutPath $shortcutName
  $softPath = Join-Path $softwaresPath $shortcutName
  if ($shortcutType -eq "url") {
    $internetShortcut = $shell.CreateShortcut($softPath)
    $internetShortcut.TargetPath = $target
    $internetShortcut.Save()
  } else {
    $shortcut = $shell.CreateShortcut($fullPath)
    $shortcut.TargetPath = "powershell.exe"
    $shortcut.Arguments = "-NoProfile -ExecutionPolicy RemoteSigned -Command `"$target`""
    $shortcut.Save()
    }
}

# 1.2+ Create Files
function Create-File {
  param (
    [string]$fileContent,
    [string]$fileName,
    [string]$fileDirectory
  )
  $outputFilePath = [System.IO.Path]::Combine($fileDirectory, "$fileName")
  $fileContent | Out-File -FilePath $outputFilePath -Encoding ASCII
}

# 1.3+ Add Features
if (-not (Test-Path "$customPath\Features")) { New-Item -Path "$customPath" -Name "Features" -Force | Out-Null }
function Add-Fea {
  param (
    [string]$FN,
    [string]$FC,
    [string]$Loc,
    [bool]$SCUT = $false
    )
     $featureExists = (Get-ItemProperty -Path "$customPath\Features" -Name $FN -ErrorAction SilentlyContinue) -ne $null
    # Check if feature already added or not exist
    if (-not $featureExists) {
      Write-Host "- Adding $FN -> $Loc"
      Set-ItemProperty -Path "$customPath\Features" -Name $FN -Value Yes
      $global:AF="yes"
      Start-Sleep -Milliseconds 100
      if ($SCUT) {
        Create-Shortcut -target $FC -shortcutName $FN -shortcutType "url"
      } else {
        Create-File -fileContent $FC -fileName $FN -fileDirectory $Loc
        }
    }
}

# 2+ Check for Shivaay Folder if not exist, restore it
if (-not (Test-Path -Path "$optimizationPath")) {
$optimizationPath = New-Item -Path "$shivaayPath\Optimizations" -ItemType Directory -Force
$securityPath = New-Item -Path "$shivaayPath\Security" -ItemType Directory -Force
$softwaresPath = New-Item -Path "$shivaayPath\Softwares" -ItemType Directory -Force
$managementPath = New-Item -Path "$shivaayPath\System Management" -ItemType Directory -Force
$interfacePath = New-Item -Path "$shivaayPath\User Interface" -ItemType Directory -Force

Write-Host ""
Write-Host "! Warning: The 'Shivaay' folder is missing or broken." -ForegroundColor Red
Write-Host "- Restoring the 'Shivaay' folder to $shivaayPath..." -ForegroundColor Yellow
Start-Sleep -Seconds 2

# 2.1+ Create Shortcuts
$winUtilCommand = "irm https://christitus.com/win | iex"
Create-Shortcut -target $winUtilCommand -shortcutName 'WinUtil-CTT.lnk'
$activatedCommand = "irm https://get.activated.win | iex"
Create-Shortcut -target $activatedCommand -shortcutName 'Activate-Windows.lnk'
$addFeatures = "irm https://github.com/ShivamXD6/Optimize-Windows/releases/latest/download/Add-More-Features.ps1 | iex"
Create-Shortcut -target $addFeatures -shortcutName 'Add More Features.lnk'
$updateOS = "irm https://raw.githubusercontent.com/ShivamXD6/Optimize-Windows/main/Updates.ps1 | iex"
Create-Shortcut -target $updateOS -shortcutName 'Update.lnk'

# Softwares
# Game Bar
$gameBar = "ms-windows-store://pdp/?productid=9nzkpstsnw4p"
Create-Shortcut -target $gameBar -shortcutName 'XBOX GameBar.url' -shortcutType "url"

# Microsoft Edge Browser
$edgeBrowser = "iwr -Uri 'https://go.microsoft.com/fwlink/?linkid=2109047&Channel=Stable&language=en' -OutFile C:\Users\Public\Desktop\EdgeBrowser.exe"
Create-Shortcut -target $edgeBrowser -shortcutName 'Edge Browser Installer.lnk' -shortcutPath $softwaresPath

# Edge WebView
$edgeWebview = "iwr -Uri 'https://go.microsoft.com/fwlink/p/?LinkId=2124703' -OutFile C:\Users\Public\Desktop\EdgeWebview.exe"
Create-Shortcut -target $edgeWebview -shortcutName 'Edge WebView2 Runtime.lnk' -shortcutPath $softwaresPath

# Google Chrome Browser 
$chrome = "iwr -Uri 'https://dl.google.com/chrome/install/latest/chrome_installer.exe' -OutFile C:\Users\Public\Desktop\Chrome.exe"
Create-Shortcut -target $chrome -shortcutName 'Google Chrome Installer.lnk' -shortcutPath $softwaresPath

# Brave Browser
$brave = "iwr -Uri 'https://laptop-updates.brave.com/latest/winx64' -OutFile C:\Users\Public\Desktop\Brave.exe"
Create-Shortcut -target $brave -shortcutName 'Brave Browser Installer.lnk' -shortcutPath $softwaresPath

# Firefox Browser 
$firefox = "iwr -Uri 'https://download.mozilla.org/?product=firefox-latest-ssl&os=win&lang=en-US' -OutFile C:\Users\Public\Desktop\Firefox.exe"
Create-Shortcut -target $firefox -shortcutName 'Mozilla Firefox Installer.lnk' -shortcutPath $softwaresPath

# Zen Browser
$zen = "iwr -Uri 'https://github.com/zen-browser/desktop/releases/latest/download/zen.installer.exe' -OutFile C:\Users\Public\Desktop\Zen.exe"
Create-Shortcut -target $zen -shortcutName 'Zen Browser Installer.lnk' -shortcutPath $softwaresPath

# Zeb Browser Portable
$zenPort = "iwr -Uri 'https://github.com/zen-browser/desktop/releases/latest/download/zen.win-specific.zip' -OutFile C:\Users\Public\Desktop\ZenPortable.zip"
Create-Shortcut -target $zenPort -shortcutName 'Zen Browser Portable.lnk' -shortcutPath $softwaresPath

# Install/Uninstall Microsoft Store
$MSStore = @'
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Install Microsoft Store" (
call :INMS
) else (
call :UNMS
)

:INMS
PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage -AllUsers Microsoft.WindowsStore | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register \"$($_.InstallLocation)\AppXManifest.xml\"}"
ren "%~dpnx0" "Uninstall - Microsoft Store.cmd"
exit /b

:UNMS
PowerShell -ExecutionPolicy Bypass -Command "Get-AppxPackage -Allusers Microsoft.WindowsStore | Remove-AppxPackage"
ren "%~dpnx0" "Install - Microsoft Store.cmd"
exit /b
'@
Create-File -fileContent $MSStore -fileName 'Uninstall - Microsoft Store.cmd' -fileDirectory $softwaresPath

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
set reg16="HKLM\SYSTEM\CurrentControlSet\Services\webthreatdefsvc"
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
reg add %reg16% /v Start /t REG_DWORD /d 2 /f
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
reg add %reg16% /v Start /t REG_DWORD /d 4 /f
ren "%~dpnx0" "Enable - Defender.cmd"
)
bcdedit /deletevalue {current} safeboot
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Userinit" /t REG_SZ /d "C:\Windows\system32\userinit.exe" /f
shutdown /r /f /t 1
) else (
bcdedit /set {current} safeboot minimal
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v "Userinit" /t REG_SZ /d "explorer.exe, cmd /c \"%~dpnx0\"" /f
shutdown /r /f /t 1
)
"@
Create-File -fileContent $Defender -fileName 'Enable - Defender.cmd' -fileDirectory $securityPath

# Toggle Smart Screen
$smartScreen = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender"
set reg3="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine"
set reg4="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\App and Browser protection"
if "%~n0"=="Enable - Smart Screen" (
reg add %reg1% /v "SmartScreenEnabled" /t REG_SZ /d "Warn" /f
reg add %reg2% /v "PUAProtection" /t REG_DWORD /d 1 /f
reg add %reg3% /v "MpEnablePus" /t REG_DWORD /d 1 /f
reg delete %reg4% /v "UILockdown" /f
ren "%~dpnx0" "Disable - Smart Screen.cmd"
) else (
reg add %reg1% /v "SmartScreenEnabled" /t REG_SZ /d "Off" /f
reg add %reg2% /v "PUAProtection" /t REG_DWORD /d 0 /f
reg add %reg3% /v "MpEnablePus" /t REG_DWORD /d 0 /f
reg add %reg4% /v "UILockdown" /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Enable - Smart Screen.cmd"
)
"@
Create-File -fileContent $smartScreen -fileName 'Enable - Smart Screen.cmd' -fileDirectory $securityPath

# Toggle Core Isolation 
$coreIsolation = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security"
set reg3="HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\KernelShadowStacks"
set reg4="HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\CredentialGuard"
set reg5="HKLM\SYSTEM\CurrentControlSet\Control\Lsa"
set reg6="HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard"

if "%~n0"=="Enable - Core Isolation" (
reg add %reg1% /v Enabled /t REG_DWORD /d 1 /f
reg delete %reg2% /v "UILockdown" /f
reg add %reg3% /v Enabled /t REG_DWORD /d 1 /f
reg add %reg4% /v Enabled /t REG_DWORD /d 1 /f
reg add %reg5% /v RunAsPPL /t REG_DWORD /d 1 /f
reg add %reg6% /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Disable - Core Isolation.cmd"
) else (
reg add %reg1% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg2% /v "UILockdown" /t REG_DWORD /d 1 /f
reg add %reg3% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg4% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg5% /v RunAsPPL /t REG_DWORD /d 0 /f
reg add %reg6% /v "EnableVirtualizationBasedSecurity" /t REG_DWORD /d 0 /f
ren "%~dpnx0" "Enable - Core Isolation.cmd"
)
"@
Create-File -fileContent $coreIsolation -fileName 'Disable - Core Isolation.cmd' -fileDirectory $securityPath

# System Management
# Toggle Hibernation and Fast Startup
$hibernation = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Hibernation and Fast Startup" (
powercfg /hibernate on
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Power" /v HiberbootEnabled /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Disable - Hibernation and Fast Startup.cmd"
) else (
powercfg /hibernate off
ren "%~dpnx0" "Enable - Hibernation and Fast Startup.cmd"
)
"@
Create-File -fileContent $hibernation -fileName 'Enable - Hibernation and Fast Startup.cmd' -fileDirectory $managementPath

# Toggle Update Notifications
$updateNotify = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if "%~n0"=="Enable - Update Notifications" (
reg delete %reg1% /v RestartNotificationsAllowed2 /f
reg delete %reg2% /v SetAutoRestartNotificationDisable /f
reg delete %reg2% /v SetUpdateNotificationLevel /f
ren "%~dpnx0" "Disable - Update Notifications.cmd"
) else (
reg add %reg1% /v RestartNotificationsAllowed2 /t REG_DWORD /d 0 /f
reg add %reg2% /v SetAutoRestartNotificationDisable /t REG_DWORD /d 1 /f
reg add %reg2% /v SetUpdateNotificationLevel /t REG_DWORD /d 2 /f
ren "%~dpnx0" "Enable - Update Notifications.cmd"
)
"@
Create-File -fileContent $updateNotify -fileName 'Disable - Update Notifications.cmd' -fileDirectory $managementPath

# Toggle Notifications and Background Apps
$notification = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Policies\Microsoft\Windows\Explorer"
set reg2="HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
set reg3="HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
if "%~n0"=="Enable - Notifications and Background Apps" (
reg add %reg1% /v DisableNotificationCenter /t REG_DWORD /d 0 /f
reg add %reg2% /v ToastEnabled /t REG_DWORD /d 1 /f
reg delete %reg3% /v "LetAppsRunInBackground" /f
set st="Disable - Notifications and Background Apps.cmd"
) else (
reg add %reg1% /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg add %reg2% /v ToastEnabled /t REG_DWORD /d 0 /f
reg add %reg3% /v "LetAppsRunInBackground" /t REG_DWORD /d 2 /f
set st="Enable - Notifications and Background Apps.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $notification -fileName 'Enable - Notifications and Background Apps.cmd' -fileDirectory $managementPath

# Optimizations
# Cleanup
$cleanup = @'
# Ensure the script runs as Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Output "Please run this script as Administrator."
    Pause
    Exit
}

# Ignore Errors and Continue
$ErrorActionPreference = 'SilentlyContinue'

# Function to display sections
function Show-Message ($message) {
    Write-Output "==========================================="
    Write-Output "  $message"
    Write-Output "==========================================="
    Start-Sleep -Seconds 2
}

# Kill Cleanup Manager
Get-Process -Name cleanmgr -EA 0 | Stop-Process -Force -EA 0

# Show initial disk space
$initialFreeMB = (Get-PSDrive -Name C).Free / 1MB
$initialFreeGB = [math]::Round($initialFreeMB / 1024, 2)

Show-Message "Using Disk Cleanup with custom configuration"
$volumeCache = @{
    "Active Setup Temp Folders" = 2
    "BranchCache" = 2
    "Content Indexer Cleaner" = 2
    "Delivery Optimization Files" = 2
    "Device Driver Packages" = 2
    "Diagnostic Data Viewer database files" = 2
    "Downloaded Program Files" = 2
    "Feedback Hub Archive log files" = 2
    "Internet Cache Files" = 2
    "Language Pack" = 2
    "Offline Pages Files" = 2
    "Old ChkDsk Files" = 2
    "Recycle Bin" = 2
    "RetailDemo Offline Content" = 2
    "Setup Log Files" = 2
    "System error memory dump files" = 2
    "System error minidump files" = 2
    "Temporary Files" = 2
    "Temporary Setup Files" = 2
    "Temporary Sync Files" = 2
    "Update Cleanup" = 2
    "Upgrade Discarded Files" = 2
    "User file versions" = 2
    "Windows Defender" = 2
    "Windows Error Reporting Files" = 2
    "Windows ESD installation files" = 2
    "Windows Reset Log Files" = 2
    "Windows Upgrade Log Files" = 2
}
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
foreach ($item in $volumeCache.GetEnumerator()) {
    $keyPath = Join-Path $registryPath $item.Key
    if (Test-Path $keyPath) {
        New-ItemProperty -Path $keyPath -Name StateFlags1337 -Value $item.Value -PropertyType DWord | Out-Null
    }
}
Start-Process -FilePath "$env:SystemRoot\system32\cleanmgr.exe" -ArgumentList "/sagerun:1337" -Wait:$false

Show-Message "Cleaning up leftovers"
$foldersToRemove = @(
    "CbsTemp",
    "Logs",
    "Panther",
    "Prefetch",
    "SoftwareDistribution",
    "System32\LogFiles",
    "System32\LogFiles\WMI",
    "System32\SleepStudy",
    "System32\sru",
    "System32\WDI\LogFiles",
    "System32\winevt\Logs",
    "SystemTemp",
    "Temp"
)

foreach ($folderName in $foldersToRemove) {
    $folderPath = Join-Path $env:SystemRoot $folderName
    if (Test-Path $folderPath) {
        Remove-Item -Path "$folderPath\*" -Force -Recurse | Out-Null
    }
}
Remove-Item -Path "C:\Program Files\WindowsApps\MicrosoftWindows.Client.WebExperience*" -Recurse -Force

Show-Message "Cleaning up %TEMP% and Log Files"
Get-ChildItem -Path "$env:TEMP" | Remove-Item -Recurse -Force
Get-ChildItem -Path "$env:SystemRoot" -Filter *.log -File -Recurse -Force | Remove-Item -Recurse -Force | Out-Null

Show-Message "Cleaning up Event Logs"
Get-EventLog -LogName * | ForEach-Object { Clear-EventLog $_.Log }

# Run DISM Component Cleanup
Show-Message "Cleaning up WinSxS components"
Dism /online /Cleanup-Image /StartComponentCleanup /ResetBase

# Clean Edge Update Downloads
Show-Message "Cleaning up EdgeUpdate Downloads"
$edgeUpdatePath = ${env:ProgramFiles(x86)} + "\Microsoft\EdgeUpdate\Download"
if (Test-Path -Path $edgeUpdatePath) {
    Remove-Item -Path $edgeUpdatePath -Force -Recurse | Out-Null
}

# Clean Empty Folders
Show-Message "Cleaning Empty Folders"
Get-ChildItem -Directory -Path "C:\" -Recurse -ErrorAction SilentlyContinue |
Where-Object { try { ($_.GetFiles().Count -eq 0) -and ($_.GetDirectories().Count -eq 0) } catch { $false } } |
ForEach-Object {
    try {
        Remove-Item $_.FullName -Force -Recurse -ErrorAction SilentlyContinue
        Write-Output "Deleted Empty Folder: $($_.FullName)"
    } catch {}
}

# Clean System Restore Points
Show-Message "Cleaning System Restore Points"
vssadmin delete shadows /all /quiet | Out-Null

# Show freed space
$finalFreeMB = (Get-PSDrive -Name C).Free / 1MB
$finalFreeGB = [math]::Round($finalFreeMB / 1024, 2)
$freedSpaceMB = $finalFreeMB - $initialFreeMB
$freedSpaceGB = [math]::Round($freedSpaceMB / 1024, 2)

Show-Message "Before Cleanup: $initialFreeMB MB ($initialFreeGB GB) Free"
Show-Message "After Cleanup: $finalFreeMB MB ($finalFreeGB GB) Free"
Show-Message "Freed Space: $freedSpaceMB MB ($freedSpaceGB GB)"

Pause
'@
Create-File -fileContent $cleanup -fileName 'Cleanup.ps1' -fileDirectory $optimizationPath

# Toggle GameDVR
$gameDVR = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\System\GameConfigStore"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR"
if "%~n0"=="Enable - GameDVR" (
reg add %reg1% /v GameDVR_FSEBehavior /t REG_DWORD /d 0 /f
reg add %reg1% /v GameDVR_Enabled /t REG_DWORD /d 1 /f
reg add %reg1% /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 0 /f
reg add %reg1% /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 0 /f
reg add %reg1% /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 1 /f
reg add %reg2% /v AllowGameDVR /t REG_DWORD /d 1 /f
    ren "%~dpnx0" "Disable - GameDVR.cmd"
) else (
reg delete %reg1% /v GameDVR_FSEBehavior /f
reg delete %reg1% /v GameDVR_Enabled /f
reg delete %reg1% /v GameDVR_DXGIHonorFSEWindowsCompatible /f
reg delete %reg1% /v GameDVR_HonorUserFSEBehaviorMode /f
reg delete %reg1% /v GameDVR_EFSEFeatureFlags /f
reg delete %reg2% /v AllowGameDVR /f
ren "%~dpnx0" "Enable - GameDVR.cmd"
)
"@
Create-File -fileContent $gameDVR -fileName 'Enable - GameDVR.cmd' -fileDirectory $optimizationPath

# Toggle Search Indexing Service
$searchIndex = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Search Indexing" (
sc config WSearch start=auto
net start WSearch
set st="Disable - Search Indexing.cmd"
) else (
net stop WSearch
sc config WSearch start=disabled
set st="Enable - Search Indexing.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $searchIndex -fileName 'Enable - Search Indexing.cmd' -fileDirectory $optimizationPath

# User Interface
# Toggle Gallery in File Explorer
$gallery = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
set reg2="HKCU\Software\Classes\CLSID\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}"
if "%~n0"=="Show - Gallery and Home In File Explorer" (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f
reg add %reg2% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f
set st="Hide - Gallery and Home In File Explorer.cmd"
) else (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0  /f
reg add %reg2% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f
set st="Show - Gallery and Home In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $gallery -fileName 'Show - Gallery and Home In File Explorer.cmd' -fileDirectory $interfacePath

# Toggle Recent Items in Windows
$recentItems = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer"
set reg3="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
set reg4="HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer"
set reg5="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
if "%~n0%"=="Disable - Recent Items" (
reg add %reg1% /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f
reg add %reg1% /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add %reg2% /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "1" /f
reg add %reg2% /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f
reg add %reg3% /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add %reg3% /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f
reg add %reg3% /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add %reg4% /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f
reg add %reg5% /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add %reg5% /v "Start_TrackDocs" /t REG_DWORD /d "0" /f
set st="Enable - Recent Items.cmd"
) else (
reg delete %reg1% /v "NoStartMenuMFUprogramsList" /f
reg delete %reg1% /v "NoRecentDocsHistory" /f
reg delete %reg2% /v "ShowOrHideMostUsedApps" /f
reg delete %reg2% /v "HideRecentlyAddedApps" /f
reg delete %reg3% /v "NoInstrumentation" /f
reg delete %reg3% /v "ClearRecentDocsOnExit" /f
reg delete %reg3% /v "NoRecentDocsHistory" /f
reg delete %reg4% /v "NoRemoteDestinations" /f
reg add %reg5% /v "Start_TrackProgs" /t REG_DWORD /d "1" /f
reg add %reg5% /v "Start_TrackDocs" /t REG_DWORD /d "1" /f
set st="Disable - Recent Items.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $recentItems -fileName 'Enable - Recent Items.cmd' -fileDirectory $interfacePath

Write-Host "- Successfully restored the 'Shivaay' folder!" -ForegroundColor Green
Write-Host ""

}
Write-Host "- Adding additional features..." -ForegroundColor Yellow
Write-Host "- Script Version - V3" -ForegroundColor Blue
Write-Host ""

$contextMenus = New-Item -Path "$shivaayPath\Context Menu" -ItemType Directory -Force
$usefulShortcuts = New-Item -Path "$shivaayPath\Shortcuts" -ItemType Directory -Force

# 3+ Softwares
# AMD Radeon
$amdRadeon = "ms-windows-store://pdp/?productid=9nz1bjqn6bhl"
Add-Fea -FC $amdRadeon -FN "AMD Radeon Software.url" -Loc $softwaresPath -SCUT $true

# Realtek Audio Console
$realtek = "ms-windows-store://pdp/?productid=9p2b8mcsvpln"
Add-Fea -FC $realtek -FN "Realtek Audio Console.url" -Loc $softwaresPath -SCUT $true

# Microsoft Tips
$msTips = "ms-windows-store://pdp/?productid=9wzdncrdtbjj"
Add-Fea -FC $msTips -FN "Microsoft Tips.url" -Loc $softwaresPath -SCUT $true

# Memory Reduct
$memReduct = "https://github.com/henrypp/memreduct"
Add-Fea -FC $memReduct -FN "Memory Reduct.url" -Loc $softwaresPath -SCUT $true

# Hi-Bit Uninstaller
$hibitUninstaller = "https://hibitsoft.ir/"
Add-Fea -FC $hibitUninstaller -FN "Hi-Bit Uninstaller.url" -Loc $softwaresPath -SCUT $true

# 4+ Security
# Show/Hide Unused Security Pages
$unusedSecurityPages = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health"
set reg2="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options"
set reg3="HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection"
if "%~n0"=="Hide - Unused Security Pages" (
reg add %reg1% /v "UILockdown" /t REG_DWORD /d 1 /f
reg add %reg2% /v "UILockdown" /t REG_DWORD /d 1 /f
reg add %reg3% /v "UILockdown" /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Show - Unused Security Pages.cmd"
) else (
reg delete %reg1% /v "UILockdown" /f
reg delete %reg2% /v "UILockdown" /f
reg delete %reg3% /v "UILockdown" /f
ren "%~dpnx0" "Hide - Unused Security Pages.cmd"
)
"@
Add-Fea -FC $unusedSecurityPages -FN "Show - Unused Security Pages.cmd" -Loc $securityPath

# 5+ System Management
# Toggle Printer Service
$printer = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Printer Spooler" (
sc config Spooler start=auto
net start Spooler
ren "%~dpnx0" "Disable - Printer Spooler.cmd"
) else (
net stop Spooler
sc config Spooler start=disabled
ren "%~dpnx0" "Enable - Printer Spooler.cmd"
)
"@
Add-Fea -FC $printer -FN "Enable - Printer Spooler.cmd" -Loc $managementPath

# Toggle Biometric Service
$biometric = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Biometric" (
sc config WbioSrvc start=auto
net start WbioSrvc
ren "%~dpnx0" "Disable - Biometric.cmd"
) else (
net stop WbioSrvc
sc config WbioSrvc start=disabled
ren "%~dpnx0" "Enable - Biometric.cmd"
)
"@
Add-Fea -FC $biometric -FN "Enable - Biometric.cmd" -Loc $managementPath

# Toggle Legacy Photo Viewer Association
$photoViewer = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set key="PhotoViewer.FileAssoc.Tiff"
set reg="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts"
if "%~n0"=="Remove - Legacy Photo Viewer" (
reg delete "%reg%\.bmp\OpenWithProgids" /v %key% /f
reg delete "%reg%\.cr2\OpenWithProgids" /v %key% /f
reg delete "%reg%\.dib\OpenWithProgids" /v %key% /f
reg delete "%reg%\.gif\OpenWithProgids" /v %key% /f
reg delete "%reg%\.ico\OpenWithProgids" /v %key% /f
reg delete "%reg%\.jfif\OpenWithProgids" /v %key% /f
reg delete "%reg%\.jpe\OpenWithProgids" /v %key% /f
reg delete "%reg%\.jpeg\OpenWithProgids" /v %key% /f
reg delete "%reg%\.jpg\OpenWithProgids" /v %key% /f
reg delete "%reg%\.jxr\OpenWithProgids" /v %key% /f
reg delete "%reg%\.png\OpenWithProgids" /v %key% /f
reg delete "%reg%\.tif\OpenWithProgids" /v %key% /f
reg delete "%reg%\.tiff\OpenWithProgids" /v %key% /f
reg delete "%reg%\.wdp\OpenWithProgids" /v %key% /f
ren "%~dpnx0" "Restore - Legacy Photo Viewer.cmd"
) else (
reg add "%reg%\.bmp\OpenWithProgids" /v %key% /f
reg add "%reg%\.cr2\OpenWithProgids" /v %key% /f
reg add "%reg%\.dib\OpenWithProgids" /v %key% /f
reg add "%reg%\.gif\OpenWithProgids" /v %key% /f
reg add "%reg%\.ico\OpenWithProgids" /v %key% /f
reg add "%reg%\.jfif\OpenWithProgids" /v %key% /f
reg add "%reg%\.jpe\OpenWithProgids" /v %key% /f
reg add "%reg%\.jpeg\OpenWithProgids" /v %key% /f
reg add "%reg%\.jpg\OpenWithProgids" /v %key% /f
reg add "%reg%\.jxr\OpenWithProgids" /v %key% /f
reg add "%reg%\.png\OpenWithProgids" /v %key% /f
reg add "%reg%\.tif\OpenWithProgids" /v %key% /f
reg add "%reg%\.tiff\OpenWithProgids" /v %key% /f
reg add "%reg%\.wdp\OpenWithProgids" /v %key% /f
ren "%~dpnx0" "Remove - Legacy Photo Viewer.cmd"
)
"@
Add-Fea -FC $photoViewer -FN "Restore - Legacy Photo Viewer.cmd" -Loc $managementPath

# Configure Shivaay OS Settings
$shivaayOS = @'
# Set Console UI colors
$CY = [System.ConsoleColor]::Cyan
$GR = [System.ConsoleColor]::Green
$YE = [System.ConsoleColor]::Yellow
$MA = [System.ConsoleColor]::Magenta
$WH = [System.ConsoleColor]::White
$RE = [System.ConsoleColor]::Red

# Define registry paths
$registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
$shivaayFolderRegistryPath = "HKLM:\Software\ShivaayOS"
$shivaayFolderRegistryValueName = "ShivaayFolderPath"

# Fetch information from registry for OS name and version
$osName = (Get-ItemProperty -Path $registryPath -Name "Model").Model -replace " - V\d+\.\d+$", ""
$osVersion = (Get-ItemProperty -Path $registryPath -Name "Model").Model -replace ".*- V", "V"

# Fetch Shivaay Folder Path from registry or use default if not set
if (Test-Path $shivaayFolderRegistryPath) {
    $currentShivaayFolder = (Get-ItemProperty -Path $shivaayFolderRegistryPath -Name $shivaayFolderRegistryValueName).$shivaayFolderRegistryValueName
} else {
    $currentShivaayFolder = "C:\Users\Public\Desktop\Shivaay"
}

# Default values for reset
$defaultOSName = "ShivaayOS"
$defaultShivaayFolder = "C:\Users\Public\Desktop\Shivaay"

function Show-UI {
    Clear-Host
    Write-Host "==================================" -ForegroundColor $WH
    Write-Host "       ShivaayOS Config      " -ForegroundColor $CY
    Write-Host "==================================" -ForegroundColor $WH
    Write-Host
    Write-Host "Current OS Name       : " -ForegroundColor $CY -NoNewline; Write-Host "$osName" -ForegroundColor $WH
    Write-Host "Current Version       : " -ForegroundColor $GR -NoNewline; Write-Host "$osVersion" -ForegroundColor $WH
    Write-Host "Current Shivaay Folder: " -ForegroundColor $YE -NoNewline; Write-Host "$currentShivaayFolder" -ForegroundColor $WH
    Write-Host
    Write-Host "==================================" -ForegroundColor $WH
}

function Update-Registry {
    param (
        [string]$newOSName
    )
    # Update the OS name without modifying version
    $newModel = "$newOSName - $osVersion"
    Set-ItemProperty -Path $registryPath -Name "Model" -Value $newModel
    $osName = $newOSName # Update variable for display
    Write-Host "OS Name updated to: $newOSName" -ForegroundColor $GR
    Show-UI # Refresh UI after update
}

function Update-ShivaayFolderInRegistry {
    param (
        [string]$newShivaayFolder
    )
    # Ensure the registry path exists
    if (-not (Test-Path $shivaayFolderRegistryPath)) {
        New-Item -Path $shivaayFolderRegistryPath -Force | Out-Null
    }
    # Update the Shivaay Folder path in the registry
    Set-ItemProperty -Path $shivaayFolderRegistryPath -Name $shivaayFolderRegistryValueName -Value $newShivaayFolder
    $currentShivaayFolder = $newShivaayFolder # Update variable for display
    Write-Host "Shivaay Folder Path updated to: $newShivaayFolder" -ForegroundColor $GR
    Show-UI # Refresh UI after update
}

function Reset-Settings {
    # Reset OS Name and Shivaay Folder to default values also resets reg values related to OS
    Update-Registry -newOSName $defaultOSName
    Update-ShivaayFolderInRegistry -newShivaayFolder $defaultShivaayFolder
    Remove-Item -Path "HKLM:\Software\ShivaayOS\Features" -Recurse -Force | Out-Null
    Write-Host "Settings have been reset to default values." -ForegroundColor $GR
    Show-UI # Refresh UI after reset
}

function Show-Menu {
    Write-Host "Choose an option:" -ForegroundColor $MA
    Write-Host "1. Change OS Name" -ForegroundColor $CY
    Write-Host "2. Change Shivaay Folder Path" -ForegroundColor $YE
    Write-Host "3. Reset Settings to Default" -ForegroundColor $RE
    Write-Host "4. Exit" -ForegroundColor $WH
    $choice = Read-Host "Enter your choice (1-4)"
    return $choice
}

function Get-UserInput {
    $exitFlag = $false
    while (-not $exitFlag) {
        $choice = Show-Menu
        switch ($choice) {
            1 {
                Write-Host "Enter new OS Name:" -ForegroundColor $CY
                $newOSName = Read-Host
                if ($newOSName -ne "") {
                    Update-Registry -newOSName $newOSName
                } else {
                    Write-Host "OS Name not changed." -ForegroundColor $WH
                }
            }
            2 {
                while ($true) {
                    Write-Host "Enter new Shivaay Folder Path:" -ForegroundColor $YE
                    $newShivaayFolder = Read-Host

                    # Strip surrounding quotes if present
                    $newShivaayFolder = $newShivaayFolder -replace '^"|"$', ''

                    if ($newShivaayFolder -eq "") {
                        Write-Host "Shivaay Folder Path not changed." -ForegroundColor $WH
                        break
                    } elseif (Test-Path -Path $newShivaayFolder -PathType Container) {
                        Update-ShivaayFolderInRegistry -newShivaayFolder $newShivaayFolder
                        break
                    } else {
                        Write-Host "Invalid directory path. Please enter a valid folder path." -ForegroundColor $RE
                    }
                }
            }
            3 {
                Reset-Settings
            }
            4 {
                Write-Host "Exiting..." -ForegroundColor $GR
                $exitFlag = $true
            }
            Default {
                Write-Host "Invalid choice. Please select a valid option." -ForegroundColor $RE
            }
        }
    }
}

# Display UI and Prompt for input
Show-UI
Get-UserInput
'@
Add-Fea -FC $shivaayOS -FN "Configure ShivaayOS.ps1" -Loc $managementPath

# 6+ Optimizations
# Toggle Compact OS Mode
$compactOS = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Compact OS" (
compact /CompactOS:always
ren "%~dpnx0" "Disable - Compact OS.cmd"
) else (
compact /CompactOS:never
ren "%~dpnx0" "Enable - Compact OS.cmd"
)
"@
Add-Fea -FC $compactOS -FN "Enable - Compact OS.cmd" -Loc $optimizationPath

# Toggle Last Access Time Stamp and 8.3 Char Length File Name Creation
$timeChar = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Disable - Last Access Time and 8.3 Name" (
fsutil behavior set disableLastAccess 1
fsutil behavior set disable8dot3 1
ren "%~dpnx0" "Enable - Last Access Time and 8.3 Name.cmd"
) else (
fsutil behavior set disableLastAccess 0
fsutil behavior set disable8dot3 0
ren "%~dpnx0" "Disable - Last Access Time and 8.3 Name.cmd"
)
"@
Add-Fea -FC $timeChar -FN "Enable - Last Access Time and 8.3 Name.cmd" -Loc $optimizationPath

# Toggle Multi-Plane Overlay
$MPO = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\Windows\Dwm"
if "%~n0"=="Enable - Multi-Plane Overlay" (
reg delete %reg1% /v OverlayTestMode /f
ren "%~dpnx0" "Disable - Multi-Plane Overlay.cmd"
) else (
reg add %reg1% /v OverlayTestMode /t REG_DWORD /d 5 /f
ren "%~dpnx0" "Enable - Multi-Plane Overlay.cmd"
)
"@
Add-Fea -FC $MPO -FN "Enable - Multi-Plane Overlay.cmd" -Loc $optimizationPath

# Toggle Delivery Optimization
$deliveryOptimization = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - Delivery Optimization" (
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /f
ren "%~dpnx0" "Disable - Delivery Optimization.cmd"
) else (
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f
ren "%~dpnx0" "Enable - Delivery Optimization.cmd"
)
"@
Add-Fea -FC $deliveryOptimization -FN "Enable - Delivery Optimization.cmd" -Loc $optimizationPath

# Toggle SuperFetch
$superFetch = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - SuperFetch" (
sc config SysMain start=auto
net start SysMain
ren "%~dpnx0" "Disable - SuperFetch.cmd"
) else (
sc config SysMain start=disabled
net stop SysMain
ren "%~dpnx0" "Enable - SuperFetch.cmd"
)
"@
Add-Fea -FC $superFetch -FN "Enable - SuperFetch.cmd" -Loc $optimizationPath

# 7+ User Interface
# Toggle Automatic Folder Discovery
$automaticFolder = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell"
if "%~n0"=="Enable - Automatic Folder Discovery" (
reg delete %reg1% /f
ren "%~dpnx0" "Disable - Automatic Folder Discovery.cmd"
) else (
reg add %reg1% /v "FolderType" /t REG_SZ /d "NotSpecified" /f
ren "%~dpnx0" "Enable - Automatic Folder Discovery.cmd"
)
"@
Add-Fea -FC $automaticFolder -FN "Enable - Automatic Folder Discovery.cmd" -Loc $interfacePath

# Toggle Network Navigation Pane in File Explorer
$netNavigation = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\SOFTWARE\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}"
if "%~n0%"=="Show - Network Navigation In File Explorer" (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_SZ /d 1 /f
set st="Hide - Network Navigation In File Explorer.cmd"
) else (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_SZ /d 0 /f
set st="Show - Network Navigation In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Add-Fea -FC $netNavigation -FN "Show - Network Navigation In File Explorer.cmd" -Loc $interfacePath

# Toggle Recycle Bin in File Explorer
$recycleBin = @"
@echo off
reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Classes\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}"
if "%~n0%"=="Pin - Recycle Bin In File Explorer" (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f
set st="Unpin - Recycle Bin In File Explorer.cmd"
) else (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f
set st="Pin - Recycle Bin In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Add-Fea -FC $recycleBin -FN "Unpin - Recycle Bin In File Explorer.cmd" -Loc $interfacePath

# Toggle Removable Drives in File Explorer
$rmvDrives = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
set reg2="HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}"
if "%~n0%"=="Show - Removable Drives In File Explorer Quick Access" (
reg add %reg1% /ve /d "Removable Drives" /f
reg add %reg2% /ve /d "Removable Drives" /f
set st="Hide - Removable Drives In File Explorer Quick Access.cmd"
) else (
reg delete %reg1% /f
reg delete %reg2% /f
set st="Show - Removable Drives In File Explorer Quick Access.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Add-Fea -FC $rmvDrives -FN "Show - Removable Drives In File Explorer Quick Access.cmd" -Loc $interfacePath

# Toggle Context Menu
$contextMenu = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Enable - New Context Menu" (
reg delete "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}" /f
set st="Enable - Old Context Menu.cmd"
) else (
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f
set st="Enable - New Context Menu.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Add-Fea -FC $contextMenu -FN "Enable - New Context Menu.cmd" -Loc $interfacePath

# 8+ Context Menu
# Get File Hash
$fileHash = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Add - Get File Hash" (
reg add "HKCR\*\shell\GetFileHash" /v "MUIVerb" /t REG_SZ /d "Get File Hash" /f
reg add "HKCR\*\shell\GetFileHash" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKCR\*\shell\GetFileHash\shell\01SHA1" /v "MUIVerb" /t REG_SZ /d "SHA1" /f
reg add "HKCR\*\shell\GetFileHash\shell\01SHA1\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm SHA1 | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\02SHA256" /v "MUIVerb" /t REG_SZ /d "SHA256" /f
reg add "HKCR\*\shell\GetFileHash\shell\02SHA256\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm SHA256 | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\03SHA384" /v "MUIVerb" /t REG_SZ /d "SHA384" /f
reg add "HKCR\*\shell\GetFileHash\shell\03SHA384\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm SHA384 | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\04SHA512" /v "MUIVerb" /t REG_SZ /d "SHA512" /f
reg add "HKCR\*\shell\GetFileHash\shell\04SHA512\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm SHA512 | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\05MACTripleDES" /v "MUIVerb" /t REG_SZ /d "MACTripleDES" /f
reg add "HKCR\*\shell\GetFileHash\shell\05MACTripleDES\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm MACTripleDES | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\06MD5" /v "MUIVerb" /t REG_SZ /d "MD5" /f
reg add "HKCR\*\shell\GetFileHash\shell\06MD5\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm MD5 | format-list" /f
reg add "HKCR\*\shell\GetFileHash\shell\07RIPEMD160" /v "MUIVerb" /t REG_SZ /d "RIPEMD160" /f
reg add "HKCR\*\shell\GetFileHash\shell\07RIPEMD160\command" /ve /t REG_SZ /d "powershell.exe -noexit get-filehash -literalpath '%%1' -algorithm RIPEMD160 | format-list" /f
ren "%~dpnx0" "Remove - Get File Hash.cmd"
) else (
reg delete "HKCR\*\shell\GetFileHash" /f
ren "%~dpnx0" "Add - Get File Hash.cmd"
)
"@
Add-Fea -FC $fileHash -FN "Add - Get File Hash.cmd" -Loc $contextMenus

# Select Power Plan
$powerPlan = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Add - Select Power Plan" (
reg add "HKCR\DesktopBackground\Shell\PowerPlan" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan" /v "MUIVerb" /t REG_SZ /d "Select Performance Mode" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan" /v "Position" /t REG_SZ /d "Middle" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan" /v "SubCommands" /t REG_SZ /d "" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu" /v "MUIVerb" /t REG_SZ /d "Eco Mode" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\01menu\command" /ve /t REG_SZ /d "powercfg.exe /setactive a1841308-3541-4fab-bc81-f71556f20b4a" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu" /v "MUIVerb" /t REG_SZ /d "Adaptive Mode" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\02menu\command" /ve /t REG_SZ /d "powercfg.exe /setactive 381b4222-f694-41f0-9685-ff5bb260df2e" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu" /v "MUIVerb" /t REG_SZ /d "Turbo Mode" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\03menu\command" /ve /t REG_SZ /d "powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu" /v "MUIVerb" /t REG_SZ /d "Shivaay - Power Within" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\04menu\command" /ve /t REG_SZ /d "powercfg.exe /setactive 3ff9831b-6f80-4830-8178-736cd4229e7b" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu" /v "MUIVerb" /t REG_SZ /d "Open Power Options" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu" /v "Icon" /t REG_SZ /d "powercpl.dll" /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu" /v "CommandFlags" /t REG_DWORD /d 32 /f
reg add "HKCR\DesktopBackground\Shell\PowerPlan\shell\05menu\command" /ve /t REG_SZ /d "control.exe powercfg.cpl" /f
ren "%~dpnx0" "Remove - Select Power Plan.cmd"
) else (
reg delete "HKCR\DesktopBackground\Shell\PowerPlan" /f
ren "%~dpnx0" "Add - Select Power Plan.cmd"
)
"@
Add-Fea -FC $powerPlan -FN "Add - Select Power Plan.cmd" -Loc $contextMenus

# 9+ Useful Shortcuts
# God Mode
$godMode = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
"@
Add-Fea -FC $godMode -FN "Open - God Mode.cmd" -Loc $usefulShortcuts

# Startup Programs
$startPro = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
explorer shell:startup
"@
Add-Fea -FC $startPro -FN "Open - Startup Programs.cmd" -Loc $usefulShortcuts

# Apps Data
$appData = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
explorer %appdata%
timeout /t 3
explorer %localappdata%
"@
Add-Fea -FC $appData -FN "Open - Apps Data.cmd" -Loc $usefulShortcuts

# Reboot to BIOS Settings
$rebootBios = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
shutdown /r /fw /f /t 5 /c "Rebooting PC into BIOS Settings in 5 Seconds"
"@
Add-Fea -FC $rebootBios -FN "Reboot to - BIOS Settings.cmd" -Loc $usefulShortcuts

# Reboot to Normal or Safemode
$rebootSmode = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
if "%~n0"=="Reboot to - Safe Mode" (
bcdedit /set {current} safeboot minimal
shutdown /r /f /t 5 /c "PC will restart into Safemode in 5 seconds"
ren "%~dpnx0" "Reboot to - Normal Mode.cmd"
) else (
bcdedit /deletevalue {current} safeboot
shutdown /r /f /t 5 /c "PC will restart into Normal mode in 5 seconds"
ren "%~dpnx0" "Reboot to - Safe Mode.cmd"
)
"@
Add-Fea -FC $rebootSmode -FN "Reboot to - Safe Mode.cmd" -Loc $usefulShortcuts

Write-Host ""
if ($AF -eq "yes") { Write-Host "- All additional features have been successfully added!" -ForegroundColor Green } else { Write-Host "! Additional features are already added, please try again later" -ForegroundColor Red }

pause