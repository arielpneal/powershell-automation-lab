# Ariel Neal [Student ID: 011585609]

# instead of setting location to a working directory like last submission
# this script will be using $PSScriptRoot so paths stay relative 
# decided to use join-path to make sure path is built correctly
$DailyLogPath   = Join-Path $PSScriptRoot "DailyLog.txt"
$ContentsOutPath = Join-Path $PSScriptRoot "C916contents.txt"

# last submission the script ended after choice was made
# added a do/until loop to make sure user is continously prompted until key 5 is selected

do {
    # Menu prompt--starting off with blank line for readability 
    Write-Host "`nChoose an option (1, 2, 3, 4 or 5):"
    Write-Host "1) Locate .log files & redirect to DailyLog.txt"
    Write-Host "2) List files in Requirements1 folder -> C916contents.txt"
    Write-Host "3) Show current CPU and memory usage"
    Write-Host "4) List processes, sort by virtual size, grid view"
    Write-Host "5) Exit the script"

    # variable created to pass in future switch statement
    $Choice = Read-Host "Enter a number"

    # create switch statement--- requirement B
    switch ($Choice) {
        "1" {
            # try/catch added in for exception handling--requirement D
            try {
                # requirement B1: date precedes, append .log results
                Get-Date | Out-File -FilePath $DailyLogPath -Append
                Get-ChildItem -Path $PSScriptRoot | Where-Object { $_.Name -match "\.log$" } |
                Out-File -FilePath $DailyLogPath -Append
                Write-Host "Log file updated at $DailyLogPath"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Not enough memory to list .log files"
            }
        }
        "2" {
            try {
                # Requirement B2: List the files inside the “Requirements1” folder in tabular format
                # sorted in ascending alpha order. Direct the output into a new file called “C916contents.txt” 
                Get-ChildItem -Path $PSScriptRoot |
                Sort-Object Name |
                Format-Table -AutoSize |
                Out-File -FilePath $ContentsOutPath
                Write-Host "Contents saved to $ContentsOutPath"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Not enough memory to list folder contents"
            }
        }
        "3" {
            try {
                # Requirement B3: CPU and memory usage
                $CPU = Get-CimInstance Win32_Processor | Select-Object -ExpandProperty LoadPercentage
                $Mem = Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory
                Write-Host "CPU Usage: $CPU%"
                Write-Host "Total Memory: $($Mem.TotalVisibleMemorySize)"
                Write-Host "Free Memory: $($Mem.FreePhysicalMemory)"
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Not enough memory to get system usage"
            }
        }
        "4" {
            try {
                # Requirement B4: processes sorted by virtual size in grid view--ascending is default (won't allow me to add)
                Get-Process | Sort-Object VirtualMemorySize | Out-GridView
            }
            catch [System.OutOfMemoryException] {
                Write-Host "Error: Not enough memory to get process list"
            }
        }
        "5" {
            # Requirement B5: exit
            Write-Host "Exiting script. Until next time!"
        }
        
    }
    # ending the loop "until a user presses key 5:"
} until ($Choice -eq "5")