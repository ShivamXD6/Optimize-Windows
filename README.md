# 🎮 Gaming Unattend (Answer File) for Power Users
- Thinking about reinstalling Windows? Wait—use this answer file to reinstall and get the best Windows experience without any bloat.
- Skip the hassle of manual Windows setup—use this answer file for a fully automated installation. Auto Unattend configures everything in advance, from setup and debloating to tweaking and installing drivers, so you can sit back while Windows installs itself. Perfect for quick, effortless reinstalls!

# 📑 Table of Contents
- [🚀 Features](#-features)
- [🛠️Bypass and Customization of Windows Installation](#%EF%B8%8F-bypass-and-customization-of-windows-installation)
- [💨 Debloating and Performance Optimization](#-debloating-and-performance-optimization)
- [🔐 Privacy and Security Enhancements](#-privacy-and-security-enhancements)
- [🖥️ User Interface and Usability Enhancements](#%EF%B8%8F-user-interface-and-usability-enhancements)
- [⚙️ Selective Features Disabling](#%EF%B8%8F-selective-features-disabling)
- [⚙️ Specific System Tweaks](#%EF%B8%8F-specific-system-tweaks)
- [🛠️ Setup & Installation Guide](#-setup-&-installation-guide)
- [1. Prepare Your USB Drive](#1-prepare-your-usb-drive)
- [2. Optional Adding Drivers](#2-optional-adding-drivers)
- [3. Installing Windows Via Ventoy](#3-installing-windows-via-ventoy)
- [💖 Acknowledgements](#-acknowledgements)

## 🚀 Features

### 🛠️ Bypass and Customization of Windows Installation
- 🚧 **Bypass Windows 11 Requirements**: Allows installation on unsupported hardware.
- 🌐 **Support for Local Account (Offline Installation) During Setup**: Enables the use of a local account instead of a Microsoft account.
- 🗂️ **Show All Available Editions of Windows During Setup**: Provides options to choose different Windows editions during installation.
- 💾 **Support Automatic Drivers Installation From Pendrive/Installation Media**: Allows for driver installation directly from the installation media.
- ⚙️ **Auto OOBE Setup**: Automates the out-of-box experience setup process.

### 💨 Debloating and Performance Optimization
- 🧹 **Debloat Windows 11 Bloatware**: Removes unnecessary apps and disables telemetry, logging, history, and tracking (Excludes Microsoft Store, Edge Webview, Snipping Tool, Notepad).
- ❌ **Disables Windows Error Reporting, Update Delivery Optimization, and Windows Remote Assistance**: Disables certain Windows features that may impact performance or privacy.
- 🔒 **Configures Windows Update**: Only installs security updates and delays feature updates for 1 year.
- ⚡ **Create a Custom Power Plan (Trishula)**: Maximizes performance with 100% CPU parked.
- 🚀 **Service Optimization**: Sets numerous Windows services to manual or disabled to optimize performance.
- 🛡️ **Various Tweaks**: Applies performance, network, and privacy-related tweaks from CTT-WinUtil, Atlas, and Revi.
- 🗃️ **Disables Reserved Storage**: Frees up storage reserved by the system.

### 🔐 Privacy and Security Enhancements
- 👁️ **Disables Telemetry, Loggings, History, and Tracking**: Improves privacy by reducing data collection.
- 🚫 **Disables Smart App Control**: Disables security features that may slow down the system.
- 🛑 **Disables WPBT**: Disables the Windows Platform Binary Table for improved security.
- 🔒 **Disables LLMNR Protocol**: Disables a potentially vulnerable protocol, replaced by DNS.
- 💾 **File System Optimization**: Disables Last Access Time Stamp and Legacy 8.3 Char Length File Name Creation to enhance file system performance.

### 🖥️ User Interface and Usability Enhancements
- 🔗 **Desktop Shortcuts**: Creates useful shortcuts for CTT-WinUtil, Activation, and Revert on the desktop.
- 📋 **Configures Start Menu and Taskbar**: Customizes the Start menu and taskbar for a tailored user experience.
- 🖱️ **Context Menu Additions**: Adds context menu items like "Take Ownership" and "Run with Priority" by default.

### ⚙️ Selective Features Disabling 
- 🛡️ **Disables Windows Defender Partially**: Reduces the functionality of Windows Defender to improve performance or compatibility.
- 🎮 **Disables Xbox GameDVR**: Disables Xbox DVR features that may impact performance.
- 📵 **Disables Notifications and Background Apps**: Limits background processes and notifications to reduce resource usage.

### ⚙️ Specific System Tweaks
- 🚫 **Prevents Installation of Certain Windows Features**: Prevents installation of Dev Home, New Outlook, Chat, and Bitlocker Auto Encryption on Win 11 24H2.
- 🖥️ **Disables MPO**: Disables Multi-Plane Overlay for better graphical performance on AMD and Nvidia GPUs.
- ⚙️ **Enables SSD Trimming**: Improves SSD performance by enabling trimming to clear deleted data blocks.

> [!NOTE]
> Selective Features can be Configure from Revert Folder.

## 🛠️ Setup & Installation

### 1. Prepare Your USB Drive
1. Create a bootable USB drive using **Ventoy**.
2. Download the `GamingUnattend.zip` file.
3. Extract the contents of `Gaming-Unattend.zip` into your USB drive.
4. Confirm that the file structure on your USB drive matches the following:

    ```plaintext
    D: (Your USB Drive)
    │
    ├───$WinpeDriver$
    │   └───Add or Export Your Drivers Here
    │
    ├───ventoy
    │   │───ventoy.json
    │   └───autounattend.xml
    │
    └───WinISO
        └───Add Your Windows ISO Here
    ```

5. After confirming the file structure, add your Windows ISO file and drivers to the respective folders.

### 2. Optional: Adding Drivers
1. Create a folder named `Drivers` on your C: drive.
2. Backup your current Windows drivers to the C: drive by running the command in command prompt as administrator:

    ```cmd
    dism /online /export-driver /destination:C:\Drivers
    ```

3. Plug your USB drive/installation media into your computer.
4. Create a folder named `$WinpeDriver$` on your USB drive.
5. Copy the drivers you want to automatically install from `C:\Drivers` to `D:\$WinpeDriver$`.

> [!NOTE]
> Drivers should be placed in their respective subfolders with `.inf` files included. `.exe` driver files are not supported.

### 3. Installing Windows Via Ventoy
1. Now Restart into Boot Selection Menu (By Pressing F12, F8 or ESC Repeatedly).
2. Select your USB Drive.
3. If it Says "Verification Failed: (0x1A) Security Violation"

> [!NOTE] 
> All the steps only need to be done once for each computer when booting Ventoy at the first time.

![Ventoy Enroll Key](https://www.ventoy.net/static/img/secure_key.gif)

4. Now Select `Boot in Normal Mode`.
5. Now you'll see some commands running.
6. Select Your Language, Region and Windows Version.

> [!NOTE]
> If you don't see many windows version. Click back once and again next then you will get all Windows Versions.

7. You'll be Redirected to Custom Installation
7.1 If you want to keep your data (Just select partition where your windows is installed and click next. Don't delete any other partition.)
7.2. If you have backup all data. Then delete all partitions. Then select Unallocated Space and click Next.
8. Enter your Name and Password for Local User Account (Use Simple names without Symbols).
9. Now windows will run some more commands and restart.
10. Done Enjoy.

## 💖 Acknowledgements
 - Thanks to [MemTechTips](https://github.com/memstechtips/UnattendedWinstall) for Core file Used as a base.
 - Credits to [Schneegans](https://schneegans.de/windows/unattend-generator/), [ChrisTitusTech](https://github.com/ChrisTitusTech/winutil), [Revi](https://revi.cc) for Tweaks used in this answer File -->
