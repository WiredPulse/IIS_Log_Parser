# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser


Get-WinEvent -FilterHashtable @{Logname ='Microsoft-Windows-TerminalServices-LocalSessionManager/Operational';id='25'} |
select-object -ExpandProperty properties -first 1

Get-WinEvent -FilterHashtable @{Logname ='Microsoft-Windows-TerminalServices-LocalSessionManager/Operational';ID = '21'} | select * -first 1
