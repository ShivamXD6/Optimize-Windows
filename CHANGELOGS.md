# Changelogs - V4.1
## Shivaay Folder Changes
 - Updated Core Isolation Script, to make sure it's disabling VBS.

## Answer File Changes
 - Disabled Aero Peek (Sometimes Irritating while Hovering mouse on taskbar icons)
 - Reduced Shutdown time from 10 to 5 seconds.
 - Hide Shortcut Icons on Desktop.
 - Added one more Registry to ensure disabling of VBS or Core Isolation.

# Changelogs - V4 - Stable
## Shivaay Folder Changes
 - Using Function for Creation of Folder files.
 - Rewrite files name of Shivaay Folder for Improved Readability.
 - Added Cleanup Script in Optimization.
 - Added Biometric Script in System Management.
 - Added Memory Reduct in Software.
 - Updated Defender Script included webthreatdef service.
 - Added Script to Toggle Compact OS (Compress / Decompress Windows Binary Files) in System Management and save upto 2-3 GB.
 - Fixed Network Navigation Toggle in File Explorer.
 - Updated Core Isolation Script, added some more parts of core Isolation.
 - Updated Edge Webview link (No browser needed to download).
 - Added Some browsers, Chrome, Brave, Firefox, Zen (Normal and Portable) to directly download from Software.
 - Fixed Update Notifications Toggle.
 - Fixed Automatic Folder Discovery Script.

## Answer File Changes
 - Added Full Support for 24H2.
 - Dynamically adjust Virtual Memory as per requirement upto 8GB.
 - Removed Registry for `Managed by your Organization in Edge` (as there's no policies modification for edge).
 - Fixed Disabling of Delivery Optimization.
 - Reworked on Function may fix CTT shortcut flagging as Trojan by Defender.
 - Configure Visual Effects for Snappy Experience.
 - Added comments for shutdown commands.
 - Updated Power Plan Settings.
 - Reconfigure and Removed many Services and using function for all the services.
 - Disabled UAC as it's irritating sometimes. (legacy smart screen works best)
 - Determine Win 10 or 11 then start executing some commands to avoid any issues.
 - Removed duplicate comments and rewrite comments.
 - Removed Bypass NRO Online Account Creation Registry.
 - Removed some duplicate or useless Registries thanks to Nikki.
 - Removed Edge Webview from Installed apps list.
 - Removed Edge from Default Apps.
 - Added 'Compress to' in the old context menu even in 23H2, Thanks to ThioJoe.
 - Disabled Malicious Software Removal Tool From Installing via Windows Update.
 - Fixed Disabling of Automatic Folder Discovery and Toggle File of it.
 - Added `Run as Administrator` for PowerShell Script context menu.
 - Set SuperFetch to Manual to reduce initial Disk Usage, not worth it on SSD.
 - Disable Windows Input Experience and Widgets.
 - Removed Drivers Searching through Windows Update registry, as it's already enabled by Windows by default.
 - Removed Show Detailed BSOD, as it can be scary for some users.
 - Removed MouseHover registry as it's already set to 400.
 - Prevent Installation of Edge Browser with Windows update.
 - Removed Edge Scheduled tasks (tested and not getting installed by Windows Update)
 - Using Registry for disabling Defender Auto Sample Submission, cause Powershell gives error if defender gets disabled in Pre-installation stage
 - Changed Update branch from Current to Semi-Annual to receive more stable and tested updates.
 - Reduced duration for Features Updates to 6 Months, as Semi-Annual channel will get only stable updates so delaying it much longer doesn't make sense.
 - Reduced duration of security updates from 1 year to 7 days, because Security Updates can be delayed between 0-30 days.
 - Don't Download updates Automatically, Notify for Download and Installation of Updates and Manually install.
 - Removed Registry way to disable Teredo as already using command for that.
 - Removed some files to free up some space.
 - Do not Delete scheduled tasks as it can cause issues with Task Scheduler.

# Shivaay - V3
## Shivaay Folder
 Software :-
 - Added Microsoft Store link for Following Apps
 + AMD Radeon Software 
 + Microsoft Tips
 + Realtek Audio Console 
 - Added Download Link for Following Apps
 + Edge Webview. 
 + Hi-Bit Uninstaller.
 - Added Install/Uninstall Microsoft Store Script

 User Interface :-
 - Added a Toggle script to Pin/Unpin Recycle bin in file explorer. 
 - Removed Script for Changing Default Folder Name.

## User Based Preferences
 - Enable item Check boxes in file explorer for quickly select files or folders.
 - Reverted Taskbar alignment to Center.
 - Removed Recycle Bin From Desktop.
 - Pin Recycle bin In File Explorer.

## Optimization and Improvements
 - Disabled Processor Performance Boost Mode by Default (To reduce temperature in some cases)
 - Optimized Script and Removed Unnecessary spaces from Scripts.
 - Using New Method to Toggle On or Off Windows Defender along with Smart Screen.
 - Using Variables to avoid repetition of reg paths in Shivaay Folder Scripts.
 - Disabled Storage Sense (You can enable it again from settings if you want)
 - To Improve Stability, Removed taking ownership of some C Drives Folders.
 - Removed FTH from Toggle option and Not Disabling it By Default (As some faced Crashing issues)
 - Reverted Enabling Hardware GPU Scheduling (Fixes random freeze)
 - Turn on NumLock after Windows Installation.
 - Enable Detailed BSOD by default.
 - Not changing Default Folder Name to Eternal Vault.
 - Change Script Shortcuts path under Shivaay Folder.
 - Removed Microsoft Store.
 - Miscellaneous Changes (I Forgot)

# Shivaay - V2.1
## 1) User Based Customizations
 - Hide Gallery and Network Navigation From Quick Access (Clutter for those who don't use)
 - Disable Automatic File Discovery (Improves File Explorer Responsiveness)
 - Hide Removable Drives (This PC can show this Drives) 

## 2) Disable Components/Services
 - Hibernation (Takes Excess space) 
 - Set Printer Spooler to Manual (Not everyone uses Printer)
 - Disabled Search Indexing (Resource Intensive Process)
 - Fully Disabled Windows Defender (Including Core Isolation and Fault Tolerant Heap - For Performance Gain) and Hide Unused Components of Windows Security. 
 - Added Processor Performance Boost Mode in Power Options.

## 3) Added Shivaay's Folder with Following
### Security -
 - Toggle Windows Defender 
 - Toggle Core Isolation - Memory Integrity
 - Toggle Unused Security Pages
 - Toggle Fault Tolerant Heap (FTH)

### Softwares
 - Install Game Bar (Without the XBOX bloats)
 
### System Management -
 - Toggle Hibernation and Fast Startup
 - Toggle Printer Spooler
 - Toggle Notifications and Background Apps 
 - Toggle Search Indexing
 - Toggle GameDVR

### Optimizations -
 - Toggle Update Notification (As Automatic Updates are Disabled) 
 - Toggle Automatic File Discovery
 - Toggle 8.3 Char Name File Length Creation and Last Access Time Stamp.
 - Toggle Multi-Plane Overlay

### User Interface -
 - Toggle Gallery in explorer
 - Toggle Network Navigation Pane 
 - Toggle Removable Drives in Sidebar
 - Toggle Windows 10/11 Context Menu 
 - Change New Folder Name (Just Rename that file And Run)
 - Toggle Recent Items.
 
## 4) Fixed
 - Some Kernel Logging Services not Disabled
 - UAC Dimming Desktop for Account Control
 - Reserved Storage turning on again
 - Disable Irritating Windows Security Notification also Startup
 - Improved Windows Installation Speed by fixing Scripts Syntax errors and clearing unnecessary commands.
 - End User Task With Right Click.

## 5) Miscellaneous Changes
 - Added Shivaay - Power Within (For Ultimate Performance)  
 - Show More Details on File Transfer
 - Turn on Game Mode and Hardware Accelerated GPU Scheduling 
 - Displays Camera On/Off Notification For Privacy. 
 - Disable Auto Start on BSOD, to take note of error code.
 - Enable Verbose Status Messages By Default.
 - Use Full App Name on Desktop Shortcuts (Like Firefox not Firefox - Shortcut)
 