# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser

$logs = Get-WinEvent -FilterHashtable @{Logname ='Microsoft-Windows-TerminalServices-LocalSessionManager/Operational';ID = '21', '23','24','25'} | 
select-object -Property TimeCreated, ID, @{label='Account';Expression={$_.properties.value[0]}}, @{label='Session ID';Expression={$_.properties.value[1]}}, @{label='IP';Expression={$_.properties.value[2]}}

$logs | Add-Member -MemberType ScriptProperty -Name 'Message' -Value {$null}
$obj = @()

foreach($item in $logs){

    if($item.id -eq 21){
        $mes = "Session Logon Succeeded"
    }
    elseif($item.id -eq 23){
        $mes = "Session Logoff Succeeded"
    }
    elseif($item.id -eq 24){
        $mes = "Session Disconnected"
    }
    elseif($item.id -eq 25){
        $mes = "Session Reconnected Succeeded"
    }

    $obj += New-Object psobject -Property @{TimeCreated = $item.TimeCreated; Account = $item.Account; "Session ID" = $item.'Session ID'; IP = $item.IP; Message = $mes}
}
