#Author: Matthew Hinton

#Purpose:  A script that checks the below parameters. Then writes the results to a file.

#Parameters:

#Server uptime

#Server disk space

#five most recent error entries in Application and System log 

#check and list running Windows services

#check status of hosted websites

#------------

# Variables #

#------------

#Current Date

$CurrentDate = get-date -format yyyy.MM.dd

#Current Time in 24 hour format

$CurrentTime = get-date -uformat %R

#Current Date and time for file

$CurrentDateTime = get-date -format FileDateTime

 

#Store results in the below

#Change this directory location as needed.

#Example: $Dir = "D:\temp\logfiles\"

#Do not leave off trailing "\"

$Dir = "D:\goplant_logs\"

#Logfile will be current date with "server_report" appended to it

$LogFileName = $CurrentDateTime + "_server_report.txt"

#Edit the above variables as needed. This next variable is used in the script.

$PathToLogFileName = $Dir + $LogFileName

 

#Servername  

#maybe use $env:computername instead of localhost

$ServerName = $env:computername

 

#Variable to help measure script execution time

$StopWatch = [System.Diagnostics.stopwatch]::StartNew()

 

#Variable to store list of locally hosted websites

$Websites  = Get-Website | Where-Object serverAutoStart -eq $true

 

#-------

# Main #

#-------

 

#Try and write all the below to a results file

 

#Create the log file

"This is a status report for server: " + $ServerName | Out-File -FilePath $PathToLogFileName -encoding 'Default'

"Report date: " + $CurrentDate | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

"Report time: "+ $CurrentTime | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

# Check server uptime

"Server uptime :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

Get-CimInstance Win32_operatingsystem -ComputerName $ServerName | Select-Object PSComputername,LastBootUpTime, @{Name="Uptime";Expression = {(Get-Date) - $_.LastBootUptime}} | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

# Check server diskspace

"Diskspace report :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

Get-PSDrive -PSProvider filesystem | where-object {$_.used -gt 0} |

select-Object -property Root,@{name="SizeGB";expression={($_.used+$_.free)/1GB -as [int]}},

@{name="UsedGB";expression={($_.used/1GB) -as [int]}},

@{name="FreeGB";expression={($_.free/1GB) -as [int]}},

@{name="PctFree";expression={[math]::round(($_.free/($_.used+$_.free))*100,2)}} | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

#Windows Application log entries

"Windows Application log errors :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

Get-EventLog -LogName Application -EntryType Error -Newest 5  | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

#Windows System log entries

"Windows System log errors :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

Get-EventLog -LogName System -EntryType Error -Newest 5  | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

 

#This next code block checks to see if the WebAdministration Powershell module is installed

#This helps with the web service monitoring portion of the script

if (Get-Module -ListAvailable -Name WebAdministration ) {

#    Write-Host "WebAdministration Module exists"

#Status of websites

"Website status :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

$Websites | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

}

 else {

#    Write-Host "WebAdministration Module does not exist"

"WebAdministration Module does not exist!" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 }

 

 

#Check service status

"Windows Services that are running :" | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

Get-Service | Where-Object {$_.Status -eq "Running"} | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append

 

#Script execution time

"Script execution time in milliseconds to create report: " + $StopWatch.Elapsed.TotalMilliseconds | Out-File -FilePath $PathToLogFileName -encoding 'Default' -Append