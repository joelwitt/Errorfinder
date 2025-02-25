# Error Message Finder

This PowerShell script is designed to search for specific error patterns in text files within a selected folder. It provides a graphical user interface (GUI) to select the folder and execute the search. The results are displayed in an Out-GridView window.

## Features

- Select a folder to search for error messages.
- Define custom error patterns to search for.
- Display the first three matching lines of each file containing errors.
- Show error messages if the folder path is invalid or if there are issues reading files.

## Usage

1. **Run the Script**: Open a PowerShell window and execute the script.
2. **Select Folder**: Click the "Select Folder" button to choose the folder you want to search.
3. **Execute Search**: Click the "Execute" button to start the search for error messages.
4. **View Results**: The results will be displayed in an Out-GridView window.

## Requirements

- Windows PowerShell
- .NET Framework

## Notes

- Ensure that the script has the necessary permissions to read files in the selected folder.
- Customize the `$errorPatterns` array to search for specific error patterns relevant to your use case.

## License

This project is licensed under the MIT License.

## Disclaimer

This script is provided as-is without any guarantees. Use it at your own risk.

