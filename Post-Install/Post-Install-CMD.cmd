@echo off
echo " - Installation Started..."
echo " ! Ignore erorrs if you get any..."
echo " - Please turn off Windows Defender, You can enable it again later..."
echo " 1. Click on 'Virus & Threat Protection'."
echo " 2. Disable all protections on the page."
echo " 3. Return Back to Terminal."
pause
start %windir%\explorer.exe windowsdefender://threat
pause

echo " - Running Powershell Script..."
timeout 2
powershell -ExecutionPolicy Bypass -File "%~dp0Post-Install-PowerShell.ps1"

echo " - Applying Local Machine Registry Tweaks..."
timeout 2

:: Disable Windows Defender Security
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiVirus" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableSpecialRunningModes" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableRoutinelyTakingAction" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "ServiceKeepAlive" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableBehaviorMonitoring" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableOnAccessProtection" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableScanOnRealtimeEnable" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" /v "DisableRealtimeMonitoring" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Signature Updates" /v "ForceUpdateFromMU" /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "DisableBlockAtFirstSeen" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Notifications" /v DisableNotifications /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f
reg delete "HKCR\*\shellex\ContextMenuHandlers\EPP" /f
reg delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f
reg delete "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f
reg delete "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f
taskkill /IM SecurityHealthSystray.exe /F

:: Hide Unused Windows Security Pages
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device performance and health" /v "UILockdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Family options" /v "UILockdown" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Account protection" /v "UILockdown" /t REG_DWORD /d 1 /f

:: Disable Core Isolation (To Improve Performance)
reg add "HKLM\SYSTEM\CurrentControlSet\Control\DeviceGuard\Scenarios\HypervisorEnforcedCodeIntegrity" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender Security Center\Device security" /v "UILockdown" /t REG_DWORD /d 1 /f

:: Disable Fault Tolerant Heap (FTH)
reg add "HKLM\SOFTWARE\Microsoft\FTH" /v "Enabled" /t REG_DWORD /d 0 /f

:: Turn on Hardware Accelerated GPU Scheduling
reg add "HKLM\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" /v "HwSchMode" /t REG_DWORD /d 2 /f

:: Displays Camera On/Off Notification for Privacy
reg add "HKLM\SOFTWARE\Microsoft\OEM\Device\Capture" /v "NoPhysicalCameraLED" /t REG_DWORD /d 1 /f

:: Disable Auto Start on BSOD
reg add "HKLM\SYSTEM\CurrentControlSet\Control\CrashControl" /v "AutoReboot" /t REG_DWORD /d 0 /f

:: Add Shivaay OS in OEM Info
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "Shivaay OS - V2.1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion" /v "RegisteredOrganization" /t REG_SZ /d "Shivaay OS - V2.1" /f
 
:: Disable Multi-Plane Overlay (MPO) (Fixes Lags or Glitches On Nvidia or AMD GPUs)
reg add "HKLM\SOFTWARE\Microsoft\Windows\Dwm" /v OverlayTestMode /t REG_DWORD /d 5 /f

:: Bypasses Microsoft Account Creation
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OOBE" /v BypassNRO /t REG_DWORD /d 1 /f

:: Hide Settings Home Page
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /t REG_SZ /d "hide:home" /f

:: Disable Processor Performance Boost mode (To avoid heat issues or thermal throttling)
reg add "HKLM\SYSTEM\ControlSet001\Control\Power\PowerSettings\54533251-82be-4824-96c1-47b60b740d00\be337238-0d82-4146-a960-4f3749d470c7" /v "Attributes" /t REG_DWORD /d 0 /f

:: Disable System Restore (Sometimes Ineffictive and Causes Problems)
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v DisableSR /t REG_DWORD /d 1 /f

:: Disable User Account Control Temporarily
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 0 /f

:: Disable Windows Spotlight and set the normal Windows Picture as the desktop background
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnLockScreen /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
:: Disable Windows Spotlight on Settings
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightActiveUser /t REG_DWORD /d 1 /f
:: Set desktop background to a normal Windows picture
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img19.jpg" /f
:: Ensure the wallpaper style is set to fill (2 is for fill, 10 is for fit)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v WallpaperStyle /t REG_SZ /d "2" /f

:: Prevents Dev Home Installation
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate" /f

:: Prevents New Outlook for Windows Installation
reg delete "HKLM\SOFTWARE\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate" /f

:: Prevents Chat Auto Installation and Removes Chat Icon
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v ConfigureChatAutoInstall /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Chat" /v "ChatIcon" /t REG_DWORD /d 3 /f

:: Start Menu Customization
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_ProviderSet /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_WinningProvider /t REG_SZ /d B5292708-1619-419B-9923-E5D9F3925E71 /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins_LastWrite /t REG_DWORD /d 1 /f

:: Hide Removable Drives (This PC can show this drives)
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\DelegateFolders\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}" /f

:: Enable Long File Paths with Up to 32,767 Characters
reg add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v LongPathsEnabled /t REG_DWORD /d 1 /f

:: Disable News and Interests
reg add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v AllowNewsAndInterests /t REG_DWORD /d 0 /f

:: Disable Windows Consumer Features Like App Promotions etc.
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 0 /f

:: Disable Bitlocker Auto Encryption on Windows 11 24H2 and Onwards
reg add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\EnhancedStorageDevices" /v TCGSecurityActivationDisabled /t REG_DWORD /d 1 /f

:: Sets Windows Update to Only Install Security Updates and Delay Features Updates for 1 Year
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 3 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdates /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdatesPeriodInDays /t REG_DWORD /d 365 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdates /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdatesPeriodInDays /t REG_DWORD /d 365 /f

:: Disable Cortana
reg add "HKLM\Software\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f

:: Disable Activity History
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f

:: Disable Hibernation (Takes 40% space of RAM also does not make much difference in Booting for SSD Users)
powercfg /hibernate off

:: Disable Location Tracking
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v Value /t REG_SZ /d Deny /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Overrides\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f
reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f

:: Disable Telemetry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

:: Disable Windows Ink Workspace
reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowWindowsInkWorkspace /t REG_DWORD /d 0 /f

:: Disable Feedback Notifications
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f

:: Disable the Advertising ID for All Users
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f

:: Disable Windows Error Reporting
reg add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f

:: Disable Delivery Optimization
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f

:: Disable Remote Assistance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f

:: Search Windows Update for Drivers First
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 1 /f

:: Gives Multimedia Applications like Games and Video Editing a Higher Priority
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f

:: Controls whether the memory page file is cleared at shutdown. Value 0 means it will not be cleared, speeding up shutdown.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f

:: Enables NDU (Network Diagnostic Usage) Service on Startup
reg add "HKLM\SYSTEM\ControlSet001\Services\Ndu" /v Start /t REG_DWORD /d 2 /f

:: Increases IRP stack size to 30 for the LanmanServer service to Improve Network Performance and Stability
reg add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 30 /f

:: Hides the Meet Now Button on the Taskbar
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f

:: Gives Graphics Cards a Higher Priority for Gaming
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f

:: Gives the CPU a Higher Priority for Gaming
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f

:: Gives Games a higher priority in the system scheduling
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f

:: Fix Managed by your organization in Edge
reg delete "HKLM\SOFTWARE\Policies\Microsoft\Edge" /f

:: Set Registry Keys to Disable Wifi-Sense
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v Value /t REG_DWORD /d 0 /f
reg add "HKLM\Software\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v Value /t REG_DWORD /d 0 /f

:: Disable Xbox GameDVR
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v AllowGameDVR /t REG_DWORD /d 0 /f

:: Disable Tablet Mode
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v TabletMode /t REG_DWORD /d 0 /f

:: Always go to desktop mode on sign-in
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v SignInMode /t REG_DWORD /d 1 /f

:: Disable "Use my sign-in info to automatically finish setting up my device after an update or restart"
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v DisableAutomaticRestartSignOn /t REG_DWORD /d 1 /f

:: Disable OneDrive Automatic Backups of Important Folders (Documents, Pictures etc.)
reg add "HKLM\SOFTWARE\Policies\Microsoft\OneDrive" /v KFMBlockOptIn /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f

:: Disable the "Push To Install" feature in Windows
reg add "HKLM\SOFTWARE\Policies\Microsoft\PushToInstall" /v "DisablePushToInstall" /t REG_DWORD /d 1 /f

:: Disable Consumer Account State Content
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableConsumerAccountStateContent" /t REG_DWORD /d 1 /f

:: Disable Cloud Optimized Content
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t REG_DWORD /d 1 /f

:: Deletes Microsoft Edge Registry Entries
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge" /f
reg delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge Update" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\Applications\Microsoft.MicrosoftEdge.Stable_124.0.2478.105_neutral__8wekyb3d8bbwe" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications\Microsoft.MicrosoftEdge_44.19041.1266.0_neutral__8wekyb3d8bbwe" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\InboxApplications\Microsoft.MicrosoftEdgeDevToolsClient_10.0.19041.1023_neutral__8wekyb3d8bbwe" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\S-1-5-21-2466455740-832722602-188176761-1001\Microsoft.MicrosoftEdge.Stable_124.0.2478.105_neutral__8wekyb3d8bbwe" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\S-1-5-21-2466455740-832722602-188176761-1001\Microsoft.MicrosoftEdge_44.19041.1266.0_neutral__8wekyb3d8bbwe" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Appx\AppxAllUserStore\S-1-5-21-2466455740-832722602-188176761-1001\Microsoft.MicrosoftEdgeDevToolsClient_10.0.19041.1023_neutral__8wekyb3d8bbwe" /f

:: Deleting Application Compatibility Appraiser
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0600DD45-FAF2-4131-A006-0B17509B9F78}" /f

:: Deleting Customer Experience Improvement Program
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{4738DE7A-BCC1-4E2D-B1B0-CADB044BFA81}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{6FAC31FA-4A85-4E64-BFD5-2154FF4594B3}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{FC931F16-B50A-472E-B061-B6F79A71EF59}" /f

:: Disable Recent Items - 1
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "ShowOrHideMostUsedApps" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t REG_DWORD /d "1" /f

:: Deleting Program Data Updater
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{0671EB05-7D95-4153-A32B-1426B9FE61DB}" /f

:: Deleting autochk proxy
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{87BF85F4-2CE1-4160-96EA-52F554AA28A2}" /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{8A9C643C-3D74-4099-B6BD-9C6D170898B1}" /f

:: Deleting QueueReporting
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Schedule\TaskCache\Tasks\{E3176A65-4E44-4ED3-AA73-3283660ACB9C}" /f

:: Block Automatic Upgrade from Windows 10 22H2 to Windows 11 Although Manual Upgrade is Still Allowed - Credit CyberCPU Tech
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersion" /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "TargetReleaseVersionInfo" /t REG_SZ /d "22H2" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v "ProductVersion" /t REG_SZ /d "Windows 10" /f

:: Enable Verbose Status Messages
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "verbosestatus" /t REG_DWORD /d 1 /f

:: Blocks the “Allow my organization to manage my device” and “No, sign in to this app only” pop-up message.
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WorkplaceJoin" /v BlockAADWorkplaceJoin /t REG_DWORD /d 1 /f

echo " - Applying Current User Registry Tweaks ..."
timeout 2

:: Disabling the Delivery of Personalized or Suggested Content Like App Suggestions, Tips, and Advertisements in Windows
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "FeatureManagementEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OEMPreInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "RotatingLockScreenOverlayEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SoftLandingEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContentEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v IsMiEnabled /t REG_DWORD /d 0 /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\Subscriptions" /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\SuggestedApps" /f
reg add "HKCU\SOFTWARE\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f

:: Disable Recent Items - 2
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoInstrumentation" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "ClearRecentDocsOnExit" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoRecentDocsHistory" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "NoRemoteDestinations" /t REG_DWORD /d "1" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d "0" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d "0" /f

:: Removes Copilot
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Runonce" /v "UninstallCopilot" /t REG_SZ /d "" /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f

:: Removes Store Banner in Notepad
reg add "HKCU\SOFTWARE\Microsoft\Notepad" /v ShowStoreBanner /t REG_DWORD /d 0 /f

:: Removes OneDrive
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v OneDriveSetup /f

:: Align the taskbar to the left on Windows 11
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f

:: Display only Search Icon on Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v SearchboxTaskbarMode /t REG_DWORD /d 1 /f

:: Show More Details on File Explorer
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v "EnthusiastMode" /t REG_DWORD /d 1 /f

:: Change New Folder name to "Eternal Vault"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "RenameNameTemplate" /t REG_SZ /d "Eternal Vault" /f

:: Turn on Game Mode
reg add "HKCU\Software\Microsoft\GameBar" /v "AllowAutoGameMode" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t REG_DWORD /d 1 /f

:: Disable Recommendations in the Start Menu
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_IrisRecommendations /t REG_DWORD /d 0 /f

:: Hides or Removes People from Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\People" /v PeopleBand /t REG_DWORD /d 0 /f

:: Hides Task View Button on Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f

:: Hides and Removes News and Interests from PC and Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsTaskbarViewMode /t REG_DWORD /d 2 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feeds" /v ShellFeedsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Feeds" /v EnableFeeds /t REG_DWORD /d 0 /f

:: Disable User Account Sync
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v SettingSyncEnabled /t REG_DWORD /d 0 /f

:: File Explorer Customization
:: Hide Network Navigation Pane
reg add "HKCU\SOFTWARE\Classes\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f

:: Disable Automatic Folder Discovery (Improves Responsiveness)
reg delete "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\Shell\Bags\AllFolders\Shell" /v FolderType /f

:: Hide Gallary From File Explorer
reg add "HKCU\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /v System.IsPinnedToNameSpaceTree /t REG_DWORD /d 0 /f

:: Use Full App Name on Desktop Shortcuts (Like Firefox not Firefox - Shortcut)
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\NamingTemplates" /v "ShortcutNameTemplate" /t REG_SZ /d "\"%%s.lnk\"" /f

:: Disable Location Services
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v LocationServicesEnabled /t REG_DWORD /d 0 /f

:: Disable Input Personalization Settings
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f

:: Disable Automatic Feedback Sampling
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feedback" /v AutoSample /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Feedback" /v ServiceEnabled /t REG_DWORD /d 0 /f

:: Disable "Let websites provide locally relevant content by accessing my language list"
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f

:: Disable Background Apps
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f

:: Disable App Diagnostics
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppDiagnostics" /v AppDiagnosticsEnabled /t REG_DWORD /d 0 /f

:: Disable Delivery Optimization
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 0 /f

:: Disable Tablet Mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ImmersiveShell" /v TabletMode /t REG_DWORD /d 0 /f

:: Disable Use Sign-In Info for User Account
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication" /v UseSignInInfo /t REG_DWORD /d 0 /f

:: Disable Maps Auto Download
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Maps" /v AutoDownload /t REG_DWORD /d 0 /f

:: Disable Telemetry and Ads
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t REG_DWORD /d 0 /f

:: Manages and displays the status of ongoing operations, such as file copy, move, delete, etc.
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\OperationStatusManager" /v EnthusiastMode /t REG_DWORD /d 1 /f

:: Set File Explorer to Open This PC instead of Quick Access
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v LaunchTo /t REG_DWORD /d 1 /f

:: Set Display for Performance
reg add "HKCU\Control Panel\Desktop" /v MenuShowDelay /t REG_DWORD /d 1 /f

:: On Shutdown, Windows will automatically close any running applications
reg add "HKCU\Control Panel\Desktop" /v AutoEndTasks /t REG_DWORD /d 1 /f

:: Sets the Mouse hover time to 400 milliseconds
reg add "HKCU\Control Panel\Mouse" /v MouseHoverTime /t REG_SZ /d "400" /f

:: Hides the Meet Now Button on the Taskbar
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f

:: Disable the Second Out-Of-Box Experience
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\UserProfileEngagement" /v ScoobeSystemSettingEnabled /t REG_DWORD /d 0 /f

:: Set Registry Keys to Enable End Task With Right Click
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v TaskbarEndTask /t REG_DWORD /d 1 /f

:: Disable Notification Tray and Calendar
reg add "HKCU\Software\Policies\Microsoft\Windows\Explorer" /v DisableNotificationCenter /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v ToastEnabled /t REG_DWORD /d 0 /f

:: Set Classic Right-Click Menu for Windows 11
reg add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /t REG_SZ /d "" /f

:: Disable Xbox GameDVR
reg add "HKCU\System\GameConfigStore" /v GameDVR_FSEBehavior /t REG_DWORD /d 2 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_Enabled /t REG_DWORD /d 0 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_DXGIHonorFSEWindowsCompatible /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_HonorUserFSEBehaviorMode /t REG_DWORD /d 1 /f
reg add "HKCU\System\GameConfigStore" /v GameDVR_EFSEFeatureFlags /t REG_DWORD /d 0 /f

:: Disable Bing Search in Start Menu
reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f

:: Enables NumLock on Startup
reg add "HKCU\Control Panel\Keyboard" /v InitialKeyboardIndicators /t REG_SZ /d 2 /f

:: Disable Sticky Keys
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d "506" /f
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v HotkeyFlags /t REG_SZ /d "58" /f

:: Enables Show File Extensions
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f

:: Enables Dark Mode
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v AppsUseLightTheme /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v ColorPrevalence /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v EnableTransparency /t REG_DWORD /d 1 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize" /v SystemUsesLightTheme /t REG_DWORD /d 0 /f

:: Set Desktop Background Dark Mode Wallpaper
reg add "HKCU\Control Panel\Desktop" /v Wallpaper /t REG_SZ /d "C:\Windows\Web\Wallpaper\Windows\img19.jpg" /f

:: WINDOWS 10 TASKBAR CUSTOMIZATIONS
:: Makes Taskbar Transparent in Windows 10
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarAcrylicOpacity" /t REG_DWORD /d 0 /f
:: Makes Taskbar Small in Windows 10
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSmallIcons" /t REG_DWORD /d 1 /f

:: Disable Last Access Time Stamp and Legacy 8.3 Char Length File Name Creation - This Can Improve File System Performance
fsutil behavior set disableLastAccess 1
fsutil behavior set disable8dot3 1

:: Restore Windows Photo Viewer and Set as Default Program for Image Files
:: Restore Windows Photo Viewer
reg add "HKCU\SOFTWARE\Classes\.bmp" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.cr2" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.dib" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.gif" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.ico" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.jfif" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.jpe" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.jpeg" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.jpg" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.jxr" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.png" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.tif" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.tiff" /ve /d "PhotoViewer.FileAssoc.Tiff" /f
reg add "HKCU\SOFTWARE\Classes\.wdp" /ve /d "PhotoViewer.FileAssoc.Tiff" /f

:: Create Relevant File Associations
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.bmp\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.cr2\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.dib\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.gif\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.ico\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jfif\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpe\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpeg\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jpg\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.jxr\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.png\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tif\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.tiff\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.wdp\OpenWithProgids" /v "PhotoViewer.FileAssoc.Tiff" /t REG_NONE /f

:: Disable Windows Recall on Copilot+ PC - Credit Britec09
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsAI" /f
reg add "HKCU\Software\Policies\Microsoft\Windows\WindowsAI" /v "DisableAIDataAnalysis" /t REG_DWORD /d 1 /f
reg add "HKCU\Software\Policies\Microsoft\Windows\Windows AI" /v "TurnOffSavingSnapshots" /t REG_DWORD /d 1 /f

:: Disable Wallpaper JPEG Quality Reduction in Windows 10 
reg add "HKCU\Control Panel\Desktop" /v "JPEGImportQuality" /t REG_DWORD /d 100 /f

:: Sets "When Windows Detects Communication Activity" under "System > Sound > More sound settings > Communications" to "Do Nothing"
reg add "HKCU\Software\Microsoft\Multimedia\Audio" /v "UserDuckingPreference" /t REG_DWORD /d 3 /f

:: Enables User Account Control (Without Dimming Desktop)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v EnableLUA /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "PromptOnSecureDesktop" /t REG_DWORD /d "0" /f

echo " - Importing Registry File..."
reg import "%~dp0Post-Install-Registry.reg"
timeout 2

echo " - Restarting PC to Apply All Changes..."
timeout 2
shutdown /r -t 1