# Check for Shivaay Folder
$shivaayPath = "C:\Users\Public\Desktop\Shivaay"
if (-not (Test-Path -Path "$shivaayPath")) {
echo "Seems like Shivaay folder is missing or broken"
echo "Restoring Shivaay folder in Your Desktop"
Start-Sleep -Seconds 2
$desktopPath = "C:\Users\Public\Desktop"
$shell = New-Object -ComObject WScript.Shell
$shivaayPath = New-Item -Path $desktopPath -Name "Shivaay" -ItemType Directory -Force
$optimizationPath = New-Item -Path $shivaayPath -Name "Optimizations" -ItemType Directory -Force
$securityPath = New-Item -Path $shivaayPath -Name "Security" -ItemType Directory -Force
$softwaresPath = New-Item -Path $shivaayPath -Name "Softwares" -ItemType Directory -Force
$managementPath = New-Item -Path $shivaayPath -Name "System Management" -ItemType Directory -Force
$interfacePath = New-Item -Path $shivaayPath -Name "User Interface" -ItemType Directory -Force

# Create Shortcuts
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
$winUtilCommand = "irm https://christitus.com/win | iex"
Create-Shortcut -target $winUtilCommand -shortcutName 'WinUtil-CTT.lnk'
$activatedCommand = "irm https://get.activated.win | iex"
Create-Shortcut -target $activatedCommand -shortcutName 'Activate-Windows.lnk'
$addFeatures = "irm https://github.com/ShivamXD6/Optimize-Windows/releases/latest/download/Add-More-Features.ps1 | iex"
Create-Shortcut -target $addFeatures -shortcutName 'Add More Features.lnk'
$updateOS = "irm https://github.com/ShivamXD6/Optimize-Windows/releases/latest/download/Update.ps1 | iex"
Create-Shortcut -target $updateOS -shortcutName 'Update.lnk'

# Create Files
function Create-File {
  param (
    [string]$fileContent,
    [string]$fileName,
    [string]$fileDirectory
    )
  $outputFilePath = [System.IO.Path]::Combine($fileDirectory, "$fileName.cmd")
  $fileContent | Out-File -FilePath $outputFilePath -Encoding ASCII
}

# Softwares
# Game Bar
$gameBar = "ms-windows-store://pdp/?productid=9nzkpstsnw4p"
Create-Shortcut -target $gameBar -shortcutName 'XBOX GameBar.url' -shortcutType "url"

# AMD Radeon Software
$amdRadeon = "ms-windows-store://pdp/?productid=9nz1bjqn6bhl"
Create-Shortcut -target $amdRadeon -shortcutName 'AMD Radeon Software.url' -shortcutType "url"

# Realtek Audio Console
$realtek = "ms-windows-store://pdp/?productid=9p2b8mcsvpln"
Create-Shortcut -target $realtek -shortcutName 'Realtek Audio Console.url' -shortcutType "url"

# Microsoft Tips
$msTips = "ms-windows-store://pdp/?productid=9wzdncrdtbjj"
Create-Shortcut -target $msTips -shortcutName 'Microsoft Tips.url' -shortcutType "url"

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

# Memory Reduct
$memReduct = "https://github.com/henrypp/memreduct"
Create-Shortcut -target $memReduct -shortcutName 'Memory Reduct.url' -shortcutType "url"

# Hi-Bit Uninstaller
$hibitUninstaller = "https://hibitsoft.ir/"
Create-Shortcut -target $hibitUninstaller -shortcutName 'Hi-Bit Uninstaller.url' -shortcutType "url"

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
Create-File -fileContent $MSStore -fileName 'Uninstall - Microsoft Store' -fileDirectory $softwaresPath

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
set reg20="HKLM\SYSTEM\CurrentControlSet\Services\webthreatdefsvc"
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
reg add %reg20% /v Start /t REG_DWORD /d 2 /f
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
reg add %reg20% /v Start /t REG_DWORD /d 4 /f
ren "%~dpnx0" "Enable - Defender.cmd"
)
bcdedit /deletevalue {current} safeboot
shutdown /r /f /t 5 /c "PC will restart into normal mode in 5 seconds"
) else (
echo  1. To Toggle On/Off Defender I will boot into safemode.
echo  2. After Booting into safemode run this script again.
pause
bcdedit /set {current} safeboot minimal
shutdown /r /f /t 5 /c "PC will restart into safemode in 5 seconds"
)
"@
Create-File -fileContent $Defender -fileName 'Enable - Defender' -fileDirectory $securityPath

# Toggle Core Isolation 
$memoryIntegrity = @"
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
if "%~n0"=="Enable - Core Isolation" (
reg add %reg1% /v Enabled /t REG_DWORD /d 1 /f
reg delete %reg2% /v "UILockdown" /f
reg add %reg3% /v Enabled /t REG_DWORD /d 1 /f
reg add %reg4% /v Enabled /t REG_DWORD /d 1 /f
reg add %reg5% /v RunAsPPL /t REG_DWORD /d 1 /f
ren "%~dpnx0" "Disable - Core Isolation.cmd"
) else (
reg add %reg1% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg2% /v "UILockdown" /t REG_DWORD /d 1 /f
reg add %reg3% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg4% /v Enabled /t REG_DWORD /d 0 /f
reg add %reg5% /v RunAsPPL /t REG_DWORD /d 0 /f
ren "%~dpnx0" "Enable - Core Isolation.cmd"
)
"@
Create-File -fileContent $memoryIntegrity -fileName 'Enable - Core Isolation' -fileDirectory $securityPath

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
Create-File -fileContent $unusedSecurityPages -fileName 'Show - Unused Security Pages' -fileDirectory $securityPath

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
Create-File -fileContent $hibernation -fileName 'Enable - Hibernation and Fast Startup' -fileDirectory $managementPath

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
Create-File -fileContent $gameDVR -fileName 'Enable - GameDVR' -fileDirectory $managementPath

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
Create-File -fileContent $compactOS -fileName 'Enable - Compact OS' -fileDirectory $managementPath

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
Create-File -fileContent $searchIndex -fileName 'Enable - Search Indexing' -fileDirectory $managementPath

# Toggle Notifications and Background Apps
$notification = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Policies\Microsoft\Windows\Explorer"
set reg2="HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications"
set reg3="HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications"
if "%~n0"=="Enable - Notifications and Background Apps" (
reg add %reg1% /v DisableNotificationCenter /t REG_DWORD /d 0 /f
reg add %reg2% /v ToastEnabled /t REG_DWORD /d 1 /f
reg add %reg3% /v GlobalUserDisabled /t REG_DWORD /d 0 /f
set st="Disable - Notifications and Background Apps.cmd"
) else (
reg add %reg1% /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg add %reg2% /v ToastEnabled /t REG_DWORD /d 0 /f
reg add %reg3% /v GlobalUserDisabled /t REG_DWORD /d 1 /f
set st="Enable - Notifications and Background Apps.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $notification -fileName 'Enable - Notifications and Background Apps' -fileDirectory $managementPath

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
Create-File -fileContent $printer -fileName 'Enable - Printer Spooler' -fileDirectory $managementPath

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
Create-File -fileContent $biometric -fileName 'Enable - Biometric' -fileDirectory $managementPath

# Optimizations
# Cleanup
$cleanup = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)

goto START

:SHOW
echo ===========================================
echo   %1
echo ===========================================
Start-Sleep -Seconds 2 >nul
goto :EOF

:START
for /f "tokens=*" %%A in ('powershell -command "(Get-PSDrive C).Free / 1MB"') do set "bmb=%%A" & set /a bgb=bmb/1024
call :SHOW "Clearing DNS Cache"
ipconfig /flushdns

call :SHOW "Clearing Windows Run History"
reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f

call :SHOW "Removing Temp, Log, CHK, Old and Prefetch Files"
for %%e in (tmp log chk old) do for /r C:\ %%f in (*%%e) do (del /f /q "%%f" 2>nul && echo Deleted: "%%f")
for /r %windir%\prefetch %%f in (*) do (del /f /q "%%f" 2>nul && echo Deleted: "%%f")

call :SHOW "Cleaning Windows Update Cache"
del /q /f /s "%SystemRoot%\SoftwareDistribution\Download\*"

call :SHOW "Clearing Event Logs"
for /f "tokens=*" %%G in ('wevtutil el') do (
echo Clearing Event Log %%G...
wevtutil cl "%%G"
)

call :SHOW "Cleaning further with Disk Cleanup"
cleanmgr /d C: /VERYLOWDISK

call :SHOW "Repairing System Image"
dism /online /Cleanup-Image /StartComponentCleanup /ResetBase

call :SHOW "Fixing All Corrupted Files"
sfc /scannow

call :SHOW "Cleaning Empty Folders"
for /d /r C:\ %%d in (*) do rd "%%d" 2>nul && echo Deleted: %%d

call :SHOW "Cleaning Recycle Bin and System Restore Points"
vssadmin delete shadows /all /quiet
powershell -command "Clear-RecycleBin -Force" >nul 2>&1

call :SHOW "Before Cleanup: %bmb% MB (~ %bgb% GB) Free"
for /f "tokens=*" %%A in ('powershell -command "(Get-PSDrive C).Free / 1MB"') do set "amb=%%A" & set /a agb=amb/1024
call :SHOW "After Cleanup: %amb% MB (~ %agb% GB) Free"

for /f "tokens=*" %%D in ('powershell -command "%amb% - %bmb%"') do set "tot=%%D" & set /a tgb=tot/1024
call :SHOW "Freed Space: %tot% MB (~ %tgb% GB)"

pause
goto :EOF

"@
Create-File -fileContent $cleanup -fileName 'Cleanup' -fileDirectory $optimizationPath

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
Create-File -fileContent $updateNotify -fileName 'Disable - Update Notifications' -fileDirectory $optimizationPath

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
Create-File -fileContent $automaticFolder -fileName 'Enable - Automatic Folder Discovery' -fileDirectory $optimizationPath

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
Create-File -fileContent $timeChar -fileName 'Enable - Last Access Time and 8.3 Name' -fileDirectory $optimizationPath

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
Create-File -fileContent $MPO -fileName 'Enable - Multi-Plane Overlay' -fileDirectory $optimizationPath

# User Interface
# Toggle Gallery in File Explorer
$gallery = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}"
if "%~n0"=="Show - Gallery In File Explorer" (
reg add %reg1% /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 1 /f
set st="Hide - Gallery In File Explorer.cmd"
) else (
reg delete %reg1% /v System.IsPinnedToNameSpaceTree /f
set st="Show - Gallery In File Explorer.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $gallery -fileName 'Show - Gallery In File Explorer' -fileDirectory $interfacePath

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
Create-File -fileContent $netNavigation -fileName 'Show - Network Navigation In File Explorer' -fileDirectory $interfacePath

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
Create-File -fileContent $recycleBin -fileName 'Unpin - Recycle Bin In File Explorer' -fileDirectory $interfacePath

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
Create-File -fileContent $rmvDrives -fileName 'Show - Removable Drives In File Explorer Quick Access' -fileDirectory $interfacePath

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
Create-File -fileContent $contextMenu -fileName 'Enable - New Context Menu' -fileDirectory $interfacePath

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
Create-File -fileContent $recentItems -fileName 'Enable - Recent Items' -fileDirectory $interfacePath

echo "Restored Shivaay Folder"
Start-Sleep -Seconds 2
}

# 1+ Define and Create Directories
$contextMenu = New-Item -Path "$shivaayPath\Context Menu" -ItemType Directory -Force
$addTweaks = New-Item -Path "$shivaayPath\Additional Tweaks" -ItemType Directory -Force
$usefulShortcuts = New-Item -Path "$shivaayPath\Shortcuts" -ItemType Directory -Force

# 2+ Functions
function Create-File {
  param (
    [string]$fileContent,
    [string]$fileName,
    [string]$fileDirectory
    )
  $outputFilePath = [System.IO.Path]::Combine($fileDirectory, "$fileName.cmd")
  $fileContent | Out-File -FilePath $outputFilePath -Encoding ASCII
}
echo "Preparing Directories and Functions"
Start-Sleep -Seconds 2

# 3+ Context Menu
# 3.1+ Get File Hash
echo "Adding Get File Hash - Context Menu"
Start-Sleep -Seconds 2
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
Create-File -fileContent $fileHash -fileName 'Add - Get File Hash' -fileDirectory $contextMenu

# 3.2+ Select Power Plan
echo "Adding Select Power Plan - Context Menu"
Start-Sleep -Seconds 2
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
Create-File -fileContent $powerPlan -fileName 'Add - Select Power Plan' -fileDirectory $contextMenu

# 4+ Additional Tweaks
# 4.1+ Toggle Delivery Optimization
echo "Adding Toggle Delivery Optimization - Additional Tweaks"
Start-Sleep -Seconds 2
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
Create-File -fileContent $deliveryOptimization -fileName 'Enable - Delivery Optimization' -fileDirectory $addTweaks

# 4.2+ Toggle SuperFetch
echo "Adding Toggle SuperFetch - Additional Tweaks"
Start-Sleep -Seconds 2
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
Create-File -fileContent $superFetch -fileName 'Enable - SuperFetch' -fileDirectory $addTweaks

# 4.3+ Toggle Shortcut Icon
echo "Adding Toggle Shortcut Icon - Additional Tweaks"
Start-Sleep -Seconds 2
$shortcutIcon = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
set reg1="HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
if "%~n0"=="Show - Shortcut Icon" (
@echo off
reg delete %reg1% /f
set st="Hide - Shortcut Icon.cmd"
) else (
reg add %reg1% /v "29" /t REG_SZ /d "" /f
set st="Show - Shortcut Icon.cmd"
)
ren "%~dpnx0" %st% & taskkill /f /im explorer.exe & start explorer.exe
"@
Create-File -fileContent $shortcutIcon -fileName 'Show - Shortcut Icon' -fileDirectory $addTweaks

# 5+ Useful Shortcuts
# 5.1+ God Mode
echo "Adding God Mode - Shortcut"
Start-Sleep -Seconds 2
$godMode = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
explorer shell:::{ED7BA470-8E54-465E-825C-99712043E01C}
"@
Create-File -fileContent $godMode -fileName 'Open - God Mode' -fileDirectory $usefulShortcuts

# 5.2+ Startup Programs
echo "Adding Startup Programs - Shortcut"
Start-Sleep -Seconds 2
$startPro = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
explorer shell:startup
"@
Create-File -fileContent $startPro -fileName 'Open - Startup Programs' -fileDirectory $usefulShortcuts

# 5.3+ Apps Data
echo "Adding Apps Data - Shortcut"
Start-Sleep -Seconds 2
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
Create-File -fileContent $appData -fileName 'Open - Apps Data' -fileDirectory $usefulShortcuts

# 5.4+ Reboot to BIOS Settings
echo "Adding Reboot to BIOS Settings - Shortcut"
Start-Sleep -Seconds 2
$rebootBios = @"
@echo off & reg query "HKU\S-1-5-19" >nul 2>&1
if %errorLevel% neq 0 (
echo Please Run as Administrator.
pause & exit
)
shutdown /r /fw /f /t 5 /c "Rebooting PC into BIOS Settings in 5 Seconds"
"@
Create-File -fileContent $rebootBios -fileName 'Reboot to - BIOS Settings' -fileDirectory $usefulShortcuts

# 5.5+ Reboot to Normal or Safemode
echo "Adding Reboot to Safe Mode or Normal Mode - Shortcut"
Start-Sleep -Seconds 2
$rebootBios = @"
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
Create-File -fileContent $rebootBios -fileName 'Reboot to - Safe Mode' -fileDirectory $usefulShortcuts