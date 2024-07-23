$server = "192.168.1.76"  # Replace with the IP address of your remote machine
$username = "User" #replace the user with your user VM
$password = "Wrongpassword!"

# Function to perform a single login attempt
function Perform-LoginAttempt {
    param (
        [string]$server,
        [string]$username,
        [string]$password
    )

    try {
        $command = "cmdkey /add:`"TERMSRV/$server`" /user:`"$username`" /pass:`"$password`""
        Invoke-Expression $command

        Start-Process -FilePath "mstsc.exe" -ArgumentList "/v:$server" -NoNewWindow

        Start-Sleep -Milliseconds 500

        cmdkey /delete:"TERMSRV/$server"
    }
    catch {
        Write-Output "Error in job: $_"
    }
}

# Perform 30 login attempts sequentially
for ($i = 1; $i -le 30; $i++) {
    Perform-LoginAttempt -server $server -username $username -password $password
}

Write-Host "All attempts completed"

# Kill all mstsc.exe processes after all attempts
Start-Sleep -Milliseconds 500  # Wait a short period to ensure all attempts have started
Get-Process -Name mstsc -ErrorAction SilentlyContinue | ForEach-Object { $_.Kill() }

Write-Host "All mstsc.exe processes have been terminated"
