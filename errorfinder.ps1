# Allow PowerShell to run this script
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser

# Load System.Windows.Forms assembly (only if needed)
if (!(Get-Module -ListAvailable | Where-Object {$_.Name -eq 'System.Windows.Forms'})) {
    Add-Type -AssemblyName System.Windows.Forms
}

# Function to display an error pop-up
function Show-Error($message) {
    [System.Windows.Forms.MessageBox]::Show($message, "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
}

# Function to display an informational pop-up
function Show-Info($message) {
    [System.Windows.Forms.MessageBox]::Show($message, "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Define keywords or patterns to identify errors in files
$errorPatterns = @("error", "invalid", "object not found", "no permission")

# Create the main user interface form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Error Message Finder"
$form.Size = New-Object System.Drawing.Size(550, 120)
$form.StartPosition = 'CenterScreen'
$form.TopMost = $true # Keep the form on top of other windows

# Add a button for selecting a folder
$folderBrowseButton = New-Object System.Windows.Forms.Button
$folderBrowseButton.Location = New-Object System.Drawing.Point(10, 10)
$folderBrowseButton.Size = New-Object System.Drawing.Size(150, 20)
$folderBrowseButton.Text = "Select Folder"
$folderBrowseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.ShowNewFolderButton = $false
    $dialog.SelectedPath = $folderPathTextBox.Text
    $result = $dialog.ShowDialog()
    if ($result -eq "OK") {
        $folderPathTextBox.Text = $dialog.SelectedPath
    }
})
$form.Controls.Add($folderBrowseButton)

# Add a textbox to display or input the folder path
$folderPathTextBox = New-Object System.Windows.Forms.TextBox
$folderPathTextBox.Location = New-Object System.Drawing.Point(165, 10)
$folderPathTextBox.Size = New-Object System.Drawing.Size(360, 15)
$folderPathTextBox.Text = "C:\ExampleFolder"  # Default path (customize as needed)
$form.Controls.Add($folderPathTextBox)

# Add an "Execute" button to start processing
$executeButton = New-Object System.Windows.Forms.Button
$executeButton.Location = New-Object System.Drawing.Point(10, 40)
$executeButton.Size = New-Object System.Drawing.Size(515, 30)
$executeButton.Text = "Search for Errors"
$executeButton.Add_Click({
    # Retrieve the user-specified folder path
    $folderPath = $folderPathTextBox.Text

    # Verify that the folder exists
    if (Test-Path -Path $folderPath) {
        # Search for errors in files under the specified folder
        $errorDetails = Get-ChildItem -Path $folderPath -File -Recurse | ForEach-Object {
            $filePath = $_.FullName # Full path of the file
            try {
                $fileContent = Get-Content -Path $filePath -Raw # Load file content as a single string
            } catch {
                Write-Warning "Unable to read file: $filePath"
                continue # Skip to the next file if an error occurs
            }
            # Find lines matching error patterns
            $matchingLines = $fileContent -split "`r`n" | ForEach-Object {
                $matches = @()
                foreach ($pattern in $errorPatterns) {
                    # Use Regex to find all matches and calculate column indices
                    $regex = [regex]::new([regex]::Escape($pattern), [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
                    $matches += $regex.Matches($_) | ForEach-Object {
                        [PSCustomObject]@{
                            Column = $_.Index + 1 # Adjust to 1-based index
                            Pattern = $_.Value
                        }
                    }
                }
                if ($matches.Count -gt 0) {
                    [PSCustomObject]@{
                        Line        = $_
                        LineNumber  = ($fileContent -split "`r`n").IndexOf($_) + 1 # Line number (1-based)
                        Columns     = ($matches | ForEach-Object { $_.Column }) -join ", "
                        Patterns    = ($matches | ForEach-Object { $_.Pattern }) -join ", "
                        FileName    = $filePath.Split('\')[-1] # Extract filename
                        FilePath    = $filePath # Full file path
                    }
                }
            }
            $matchingLines
        }

        # Display results or notify the user if no errors are found
        if ($errorDetails) {
            $errorDetails | Out-GridView -Title "Search Results"
        } else {
            Show-Info "No files with matching error patterns were found."
        }
    } else {
        # Notify the user if the folder path is invalid
        Show-Error "The specified folder path does not exist."
    }
})
$form.Controls.Add($executeButton)

# Display the form to the user
$form.ShowDialog()
