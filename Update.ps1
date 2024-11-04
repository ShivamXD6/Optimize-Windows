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
    $form.Size = New-Object System.Drawing.Size(400, 500)  # Size of the form
    $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
    $form.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)  # Light background color

    # Label for current version
    $label = New-Object System.Windows.Forms.Label
    $label.Text = "Current Version: $version`nAvailable Updates:"
    $label.AutoSize = $true
    $label.Location = New-Object System.Drawing.Point(10, 10)
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $form.Controls.Add($label)

    # CheckBox list for available updates
    $checkBoxes = @()
    $yPos = 50

    foreach ($update in $availableUpdates) {
        $checkBox = New-Object System.Windows.Forms.CheckBox
        $checkBox.Text = $update
        $checkBox.Location = New-Object System.Drawing.Point(10, $yPos)
        $checkBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
        $checkBox.BackColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
        $checkBoxes += $checkBox
        $form.Controls.Add($checkBox)
        $yPos += 30
    }

    # RichTextBox for showing change logs
    $richTextBox = New-Object System.Windows.Forms.RichTextBox
    $richTextBox.Location = New-Object System.Drawing.Point(10, $yPos)
    $richTextBox.Size = New-Object System.Drawing.Size(360, 300)  # Further increased vertical size
    $richTextBox.ReadOnly = $true
    $richTextBox.ScrollBars = [System.Windows.Forms.RichTextBoxScrollBars]::Vertical
    $richTextBox.Font = New-Object System.Drawing.Font("Segoe UI", 9)
    $richTextBox.BackColor = [System.Drawing.Color]::FromArgb(255, 255, 255)  # White background
    $richTextBox.BorderStyle = [System.Windows.Forms.BorderStyle]::Fixed3D
    $form.Controls.Add($richTextBox)

    # Update changelog based on selection
    foreach ($checkBox in $checkBoxes) {
        $checkBox.Add_CheckedChanged({
            $richTextBox.Clear()
            $selectedUpdates = $checkBoxes | Where-Object { $_.Checked } | ForEach-Object { $_.Text }
            if ($selectedUpdates.Count -gt 0) {
                foreach ($update in $selectedUpdates) {
                    $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
                    $richTextBox.AppendText("Changelogs for $($update):`n")  # Bold changelog headers
                    $richTextBox.SelectionFont = New-Object System.Drawing.Font("Segoe UI", 9)  # Reset to normal
                    $changeLogEntries = $changeLogs[$update] -split "`n"
                    for ($i = 0; $i -lt $changeLogEntries.Count; $i++) {
                        $richTextBox.AppendText("$($i + 1). $($changeLogEntries[$i])`n")  # Fixed variable reference
                    }
                    $richTextBox.AppendText("`n")
                }
            }
        })
    }

    # Update button
    $updateButton = New-Object System.Windows.Forms.Button
    $updateButton.Text = "Apply Updates"
    $updateButton.Location = New-Object System.Drawing.Point(10, [int]($yPos + 310))  # Adjusted placement of the button
    $updateButton.Size = New-Object System.Drawing.Size(360, 30)
    $updateButton.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
    $updateButton.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)  # Button color
    $updateButton.ForeColor = [System.Drawing.Color]::White  # Button text color
    $updateButton.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat  # Flat button style
    $updateButton.Add_Click({
        $selectedUpdates = $checkBoxes | Where-Object { $_.Checked } | ForEach-Object { $_.Text }
        if ($selectedUpdates.Count -gt 0) {
            foreach ($selectedUpdate in $selectedUpdates) {
                # Call the function to apply the update
                Apply-Update $selectedUpdate
            }
            [System.Windows.Forms.MessageBox]::Show("Selected updates have been applied.", "Updates Applied")
            $form.Close()
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please select at least one update.", "No Selection")
        }
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
            # Add commands for 4.1 update
            Write-Host "Applying update 4.1..."
        }
        "4.5" {
            # Add commands for 4.5 update
            Write-Host "Applying update 4.5..."
        }
        default {
            Write-Host "No actions defined for version: $updateVersion"
        }
    }
}

# Main execution
$currentVersion, $orgVersion = Get-CurrentVersion

if ($currentVersion -like "ShivaayOS - V4*") {
    $updates = @("4.1", "4.5")
} elseif ($currentVersion -like "ShivaayOS - V4.1") {
    $updates = @("4.5")
} else {
    $updates = @()
}

# Change logs for each update
$changeLogs = @{
    "4.1" = "Added Feature A.`nImproved Performance."
    "4.5" = "Fixed bugs.`nEnhanced UI.`nAdded Feature B."
}

if ($updates.Count -gt 0) {
    Update-UI -version $currentVersion -availableUpdates $updates -changeLogs $changeLogs
} else {
    [System.Windows.Forms.MessageBox]::Show("No available updates for your version.", "No Updates")
}