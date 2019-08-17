# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser




function PS-Slack{
# https://bluescreenofjeff.com/2017-04-11-slack-bots-for-trolls-and-work/
# https://api.slack.com/custom-integrations/legacy-tokens

$uri = 'https://slack.com/api/chat.postMessage'
$token = "xoxp-728853800656-728862922645-728927308117-4fd0616c3b9f01c61bbdb01642544656"
$channel = "#general"
$message = "howdy"
$botname = "WiredPulse"     # doesn't seem to matter
$emoji = ":incoming_envelope"

$body = @{
    token    = $token
    channel  = $Channel
    text     = $Message
    username = $BotName
    icon_emoji = $emoji
    parse    = 'full'
}

Invoke-RestMethod -Uri $uri -Body $body
} # PS-Slack

function ps_log_slack{
$date = (get-date).AddMinutes(-30)

$uri = 'https://slack.com/api/chat.postMessage'
$token = "xoxp-728853800656-728862922645-728927308117-4fd0616c3b9f01c61bbdb01642544656"
$channel = "#general"
$botname = "WiredPulse"     # doesn't seem to matter
$emoji = ":incoming_envelope"

$logs = Get-WinEvent -FilterHashtable @{Logname ='Microsoft-Windows-TerminalServices-LocalSessionManager/Operational';ID = '21', '23','24','25';StartTime = $date} | 
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

foreach($message in $obj){
    $mes = "Time Created: $($message.timecreated)`nMessage: $($message.message)`nAccount: $($message.Account)`nIP: $($message.ip)`nSession ID: $($message.'Session ID')"
    $body = @{
        token    = $token
        channel  = $Channel
        text     = $Mes
        username = $BotName
        icon_emoji = $emoji
        parse    = 'full'
    }
Invoke-RestMethod -Uri $uri -Body $body
Remove-Variable obj -ErrorAction SilentlyContinue
}
} # ps_log_slack
