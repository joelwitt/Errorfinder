#Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
# Network drive mapping
  #net use X: \\your.server.address\path
# Load System.Windows.Forms assembly (if necessary)
if (!(Get-Module -ListAvailable | Where-Object {$_.Name -eq 'System.Windows.Forms'})) {
  Add-Type -AssemblyName System.Windows.Forms
}
# Function to display error messages
function Show-Error($message) {
  $errorDialog = New-Object System.Windows.Forms.MessageBoxDialog
  $errorDialog.Text = "Error"
  $errorDialog.Message = $message
  $errorDialog.Buttons = [System.Windows.Forms.MessageBoxButtons]::OK
  $errorDialog.Icon = [System.Windows.Forms.MessageBoxIcon]::Error
  $errorDialog.ShowDialog()
}

# Define the error patterns to search for
$errorPatterns1 = ("error")
$errorPatterns2 = ("invalid")
$errorPatterns3 = ("server:")
$errorPatterns4 = ("ora-")
$errorPatterns5 = ("sp2-")
$errorPatterns6 = ("object not found")
$errorPatterns7 = ("no permission")
$errorPatterns = @($errorPatterns1, $errorPatterns2, $errorPatterns3, $errorPatterns4, $errorPatterns5, $errorPatterns6, $errorPatterns7)


# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Search for Error Messages"
$form.Size = New-Object System.Drawing.Size(550, 120)
$form.StartPosition = 'CenterScreen'

# Folder Selection Button
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

# Folder Path Textbox
$folderPathTextBox = New-Object System.Windows.Forms.TextBox
$folderPathTextBox.Location = New-Object System.Drawing.Point(165, 10)
$folderPathTextBox.Size = New-Object System.Drawing.Size(360, 15)
$folderPathTextBox.Text = "c:\folderpath"  # Set initial path
$form.Controls.Add($folderPathTextBox)

# Execute Button
$executeButton = New-Object System.Windows.Forms.Button
$executeButton.Location = New-Object System.Drawing.Point(10, 40)
$executeButton.Size = New-Object System.Drawing.Size(515, 30)
$executeButton.Text = "Execute"
$executeButton.Add_Click({
  # Get the selected folder path
  $folderPath = $folderPathTextBox.Text

  # Check if the folder path is valid
  if (Test-Path -Path $folderPath) {
    # Search for files with error patterns
    $errorDetails = Get-ChildItem -Path $folderPath -File -Recurse | ForEach-Object {
      $filePath = $_.FullName  # Store the full file path
      try {
        $fileContent = Get-Content -Path $filePath  # Read file content
      } catch {
        Write-Error "Error reading file: $filePath"  # Handle file reading error
        continue  # Skip to next file if error occurs
      }
      # Find lines matching error patterns
      $matchingLines = $fileContent | Where-Object { $_ -match ($errorPatterns -join '|') }

      if ($matchingLines) {
        New-Object PSObject -Property @{
          FileName = $filePath.Split('\')[-1]  # Extract filename
          Content = ($matchingLines | Select-Object -First 3)  # Get 3 matching lines
          Path = $filePath.Substring(0, $filePath.LastIndexOf('\'))  # Extract path without filename
        }
      }
    }

    # Check if any files with errors were found
    if ($errorDetails) {
      # Display results in Out-GridView with line wrapping
      $errorDetails | Out-GridView

    } else {
      Write-Host "No files with error patterns found."
    }
  } else {
    # Display error message for invalid folder path
    Show-Error -Message "Invalid folder path."
  }
})
$form.Controls.Add($executeButton)
# Show the form
$form.ShowDialog()
net use x: /d
