# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser


function Sinkhole-Hosts{
param([string[]]$domains)
    #Requires -RunAsAdministrator
    $file = "C:\Windows\System32\drivers\etc\hosts"
    
    foreach($item in $domains){
        "0.0.0.0       $item" | out-file $file -append
    } 
}

function Restore-Hosts{
    $file = "C:\Windows\System32\drivers\etc\hosts"
    $hosts = get-content $file
    remove-item $file
    foreach($item in $hosts){
        if($item -like "`#*"){
            $item | out-file C:\Windows\System32\drivers\etc\hosts -Append      
        }
    }
}
