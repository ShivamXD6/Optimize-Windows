# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to get the current version from the registry
function Get-CurrentVersion {
$modelKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation'
$orgKey = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion'
    
    $modelVersion = (Get-ItemProperty -Path $modelKey).Model
    $orgVersion = (Get-ItemProperty -Path $orgKey).RegisteredOrganization

    return $modelVersion, $orgVersion
}

# Function to update the UI
function Update-UI {
    param (
        [string]$version,
        [array]$availableUpdates,
        [hashtable]$changeLogs
    )

    # Create the form
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Update Manager"
    $form.Size = New-Object System.Drawing.Size(400, 500)
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)

    # Label for current version and update range
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Current Version: $version`nAvailable Update: $($availableUpdates[0]) to $($availableUpdates[-1])"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($label)

    # RichTextBox for showing all changelogs
    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Location = New-Object System.Drawing.Point(10, 50)
    $richTextBox.Size = New-Object System.Drawing.Size(360, 350)
    $richTextBox.ReadOnly = $true
    $richTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $richTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $richTextBox.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255)
    $richTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
    $form.Controls.Add($richTextBox)

    # Display all changelogs in the RichTextBox by default
    foreach ($update in $availableUpdates) {
        $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $richTextBox.AppendText("Changelogs for ${update}:`n")
        $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9)
        $changeLogEntries = $changeLogs[$update] -split "`n"
        for ($i = 0; $i -lt $changeLogEntries.Count; $i++) {
            $richTextBox.AppendText("$($i + 1). $($changeLogEntries[$i])`n")
        }
        $richTextBox.AppendText("`n")
    }

    # Update button
    $updateButton = New-Object System.Windows.Forms.Button
    $updateButton.Text = "Apply Updates"
    $updateButton.Location = New-Object System.Drawing.Point(10, 410)
    $updateButton.Size = New-Object System.Drawing.Size(360, 30)
    $updateButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $updateButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
    $updateButton.ForeColor = [System.Drawing.Color]::White
    $updateButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $updateButton.Add_Click({
        foreach ($selectedUpdate in $availableUpdates) {
            Apply-Update $selectedUpdate
        }
        [System.Windows.Forms.MessageBox]::Show("All updates have been applied.", "Updates Applied")
        $form.Close()
    })
    $form.Controls.Add($updateButton)

    # Show the form
    $form.ShowDialog() | Out-Null
}

# Function to apply the update
function Apply-Update {
    param (
        [string]$updateVersion
    )
    
    # Placeholder for update commands based on the version
    switch ($updateVersion) {
        "4.1" {
            Write-Host "Applying update 4.1..."
        }
        "4.5" {
            Write-Host "Applying update 4.5..."
        }
        default {
            Write-Host "No actions defined for version: $updateVersion"
        }
    }

    # Update the registry with the new version
    $newVersion = "ShivaayOS - V$updateVersion"
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation' -Name "Model" -Value $newVersion
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' -Name "RegisteredOrganization" -Value $newVersion
    Write-Host "System version updated to $newVersion."
}

# Main execution
$currentVersion, $orgVersion = Get-CurrentVersion

# Parse numeric part of current version (e.g., "4.1" from "ShivaayOS - V4.1")
$currentVersionNumeric = ($currentVersion -split "V")[-1].Trim()

# Filter available updates to exclude the current version
$availableUpdates = @("4.1", "4.5") | Where-Object { $_ -gt $currentVersionNumeric }

# Change logs for each update
$changeLogs = @{
    "4.1" = "Added Feature A.`nImproved Performance."
    "4.5" = "Fixed bugs.`nEnhanced UI.`nAdded Feature B."
}

if ($availableUpdates.Count -gt 0) {
    Update-UI -version $currentVersion -availableUpdates $availableUpdates -changeLogs $changeLogs
} else {
    [System.Windows.Forms.MessageBox]::Show("No available updates for your version.", "No Updates")
}