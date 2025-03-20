# **Error Message Finder**
A **PowerShell tool** that simplifies the process of identifying and locating error messages in log files. This script provides a user-friendly graphical interface to select a folder, search for specific error patterns, and display results with detailed information such as line number, column number, and file details.

## **Features**
- User-friendly **Graphical User Interface (GUI)** using Windows Forms.
- Supports recursive searches across all files in a specified folder.
- Detects and highlights error messages based on customizable patterns.
- Displays detailed results, including:
  - Line numbers where errors are found.
  - Column positions of matching keywords.
  - Patterns matched in each file.
  - File names and paths.
- Interactive result visualization via PowerShell’s `Out-GridView`.
- Error handling for invalid folder paths or unreadable files.

---

## **Usage**
Follow these steps to run and use the script:

### 1. **Prerequisites**
- PowerShell installed (minimum version 5.1 recommended).
- Windows operating system with `.NET Framework` support for Windows Forms.

### 2. **Running the Script**
1. Open a PowerShell terminal.
2. Set the script execution policy to unrestricted (if not already set):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
3. Run the script:
    ```powershell
    .\ErrorMessageFinder.ps1
    ```

### 3. **Using the Interface**
  - Step 1: Click "Select Folder" to choose the directory containing the files you want to scan.

  - Step 2: Adjust the folder path if needed in the input box.

  - Step 3: Click "Search for Errors" to start the analysis.

  - Step 4: View the results in an interactive table (Out-GridView) or a message box if no errors are found.

---

## **Results Explanation**
The results are presented as a table with the following columns:

- Line: The content of the line where the error was detected.

- LineNumber: The line number within the file (1-based index).

- Columns: The exact column numbers where matching patterns were found.

- Patterns: The keywords that matched within the line.

- FileName: The name of the file containing the error.

- FilePath: The full path to the file.

---

## Customization

### Error Patterns
The script comes with default error patterns such as:
   ```powershell
$errorPatterns = @("error", "invalid", "server:", "ora-", "sp2-", "object not found", "no permission")
```

- You can modify or extend the `$errorPatterns` array to include patterns relevant to your use case.

---


### Error Handling
If a file cannot be read (e.g., due to permission issues), the script will skip it and log a warning.

If no matching errors are found, the script will notify the user via an informational pop-up.

---


### Known Limitations
Requires Windows OS due to the dependency on System.Windows.Forms.

Large files may increase processing time.

Columns and patterns are case-insensitive by default but can be adjusted in the regex if needed.

---

## Examples
### Example Log File
Here’s an example of a log file that the script can analyze:

```plaintext
2025-03-09 22:10:00 - ERROR: Disk read failure at sector 2048.
2025-03-09 22:20:00 - INVALID: User input invalid, please try again.
2025-03-09 23:20:00 - ERROR: SP2-0640: Not connected.
```
### Result Output
| Line | LineNumber | Columns | Patterns | FileName       | FilePath          |
| ---------- |------------|---------|----------|----------------|-------------------|
| Some value | 13         | 43      | ERROR    | sample-log.txt | C:\ExampleFolder  |
| Some value | 14         | 43      | ERROR    | sample-log.txt | C:\ExampleFolder  |

---

## License
This script is open-source and can be freely modified. Please attribute the original author if used or redistributed.
