# Variables
$apiUrl = "https://api.github.com/repos/ShivamXD6/Optimize-Windows/releases"
$customPath = "HKLM:\Software\ShivaayOS"
if (Test-Path $customPath) {
    $shivaayPath = (Get-ItemProperty -Path $customPath -Name "ShivaayFolderPath")."ShivaayFolderPath"
} else {
    $shivaayPath = "$desktopPath\Shivaay"
}

# Functions
# Function to get the current version from the OEM information
function Get-CurrentVersion {
    $oemInfo = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation"
    
    if ($oemInfo.Model -match "ShivaayOS - V(\d+(\.\d+)?)") {
        return $matches[1]
    } 
    return "0.0"
}

$currentVersion = Get-CurrentVersion

# Function to display a decorated header
function Show-Header {
    param (
        [string]$title
    )
    Clear-Host
    $header = @"
==========================================================
               $title
==========================================================
"@
    Write-Host $header -ForegroundColor Cyan
}

# Function to fetch releases
function Fetch-Releases {
    try {
        $response = irm -Uri $apiUrl -Method Get -Headers @{ "User-Agent" = "PowerShell" }
        return $response
    } catch {
        Write-Host "Failed to fetch releases. Please check your internet connection." -ForegroundColor Red
        exit
    }
}

# Function to display changelog with preview/full toggle
function Toggle-Changelog {
    param (
        [string]$version,
        [string]$changelog,
        [switch]$isPreview
    )
    Clear-Host  # Clear previous output
    Show-Header "Changelog for version V${version}"

    if ($isPreview) {
        # Display preview (first 5 lines or a defined preview length)
        Write-Host "Changelog Preview: (Press 'T' to expand for full changelog)" -ForegroundColor Yellow
        $changelog -split "`n" | Select-Object -First 5 | ForEach-Object { Write-Host $_ -ForegroundColor Gray }
    } else {
        # Display full changelog
        Write-Host "Full Changelog (Press 'T' to collapse)" -ForegroundColor Yellow
        Write-Host $changelog -ForegroundColor Gray
    }
}

# Function to get the next versions based on the current version
function Get-NextVersions {
    param (
        [string]$currentVersion,
        [array]$releases
    )   
    $currentMajor = [int]($currentVersion.Split('.')[0])
    $currentMinor = [int]($currentVersion.Split('.')[1])
    $nextVersions = @()
    foreach ($release in $releases) {
        $releaseVersion = $release.tag_name -replace "V", "" # Extract version without 'V'
        $releaseMajor = [int]($releaseVersion.Split('.')[0])
        $releaseMinor = [int]($releaseVersion.Split('.')[1])

        # Find versions greater than the current version
        if ($releaseMajor -gt $currentMajor -or ($releaseMajor -eq $currentMajor -and $releaseMinor -gt $currentMinor)) {
            # Format as a valid version string
            if ($releaseMinor -eq 0) {
                $releaseVersion = "$releaseMajor.0"
            }
            $nextVersions += $releaseVersion
        }
    }

    # Sort versions as System.Version objects
    $nextVersions = $nextVersions | Sort-Object { [version]$_ }
    return $nextVersions
}

# Function to update OEM information
function Update-OEMInfo {
    param (
        [string]$version
    )
    reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" /v "Model" /t REG_SZ /d "ShivaayOS - V$version" /f
    Write-Host "Updated to ShivaayOS - V$version." -ForegroundColor Green
}

# Main script execution
Show-Header "Checking for Updates"
$releases = Fetch-Releases

# Get the next versions to update to
$nextVersions = Get-NextVersions -currentVersion $currentVersion -releases $releases

if ($nextVersions.Count -gt 0) {
    Write-Host "Current version: $currentVersion" -ForegroundColor Yellow
    Write-Host "Available versions to update: $($nextVersions -join ', ')" -ForegroundColor Yellow
    Write-Host ""

    foreach ($nextVersion in $nextVersions) {
        # Get changelog for the current version
        $release = $releases | Where-Object { $_.tag_name -eq "V$nextVersion" }
        $changelog = $release.body
        $isPreview = $true  # Start with preview mode

        # Toggle loop for changelog view
        do {
            Toggle-Changelog -version $nextVersion -changelog $changelog -isPreview:$isPreview
            Write-Host "Press 'T' to toggle between preview and full changelog, or 'Enter' to continue to update." -ForegroundColor Cyan
            $key = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

            # Toggle preview/full view on 'T'
            if ($key.Character -eq 'T') {
                $isPreview = -not $isPreview
            }
        } until ($key.VirtualKeyCode -eq 13)  # Continue on 'Enter'

        # Find and execute the Update.ps1 script
        $updateAsset = $release.assets | Where-Object { $_.name -eq "Update.ps1" }
        if ($updateAsset) {
            $scriptUrl = $updateAsset.browser_download_url
            Write-Host "Executing script from: $scriptUrl" -ForegroundColor Green
            try {
                irm $scriptUrl | iex
                Update-OEMInfo -version $nextVersion
                pause
            } catch {
                Write-Host "Failed to execute the script from $scriptUrl." -ForegroundColor Red
                pause
            }
        } else {
            Write-Host "Update.ps1 script not found for release: V$nextVersion" -ForegroundColor Red
            pause
        }
    }
} else {
    Write-Host "You are already on the latest version: $currentVersion" -ForegroundColor Green
    pause
}

Write-Host "Updates completed!" -ForegroundColor Cyan
