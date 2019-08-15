# Parse-IIS-Logs
IIS Logs

https://github.com/WiredPulse/PowerShell/blob/master/Web/Invoke-IISLogParser



$cycle = 120

while($true){
$date = get-date
$net =  Get-NetTCPConnection -State Established 

$datePast = (get-date).AddSeconds(-($cycle))
$enhanced = foreach($item in $net){
    if($datePast -lt $item.creationtime){   
        $properties=@{
        LocalAddressIP = $item.localaddress
        LocalAddressPort = $item.localport
        ForeignAddressIP = $item.remoteaddress
        ForeignAddressPort = $item.remoteport
        ProcessId = $item.owningProcess
        }

		$currentLineObj = New-Object -TypeName PSObject -Property $properties
		$proc = Get-CimInstance win32_process -filter "ProcessId='$($item.owningprocess)'"
		$currentLineObj | Add-Member -MemberType NoteProperty ParentProcessId $proc.ParentProcessId
		$parentProc = Get-CimInstance win32_process -filter "ProcessId='$($proc.ParentProcessId)'"
		$currentLineObj | Add-Member -MemberType NoteProperty ParentProcessName $parentProc.name
		$currentLineObj | Add-Member -MemberType NoteProperty Name $proc.Caption
		$currentLineObj | Add-Member -MemberType NoteProperty ProcessExePath $proc.ExecutablePath
		    try{$hash = Get-FileHash -Algorithm SHA1 ($proc.ExecutablePath) -ErrorAction stop
                $currentLineObj | Add-Member -MemberType NoteProperty ProcessSHA1 $hash.hash
            }
            catch{
                $currentLineObj | Add-Member -MemberType NoteProperty ProcessSHA1 $null
            }
            try{$hash = Get-FileHash -Algorithm SHA1 ($parentProc.ExecutablePath) -ErrorAction stop
                $currentLineObj | Add-Member -MemberType NoteProperty ParentProcessSHA1 $hash.hash
            }
            catch{
                $currentLineObj | Add-Member -MemberType NoteProperty ParentProcessSHA1 $null
            }
		$currentLineObj | Add-Member -MemberType NoteProperty ParentProcessExePath $parentProc.ExecutablePath
		$currentLineObj | Add-Member -MemberType NoteProperty CommandLine $proc.CommandLine
		$currentLineObj | Add-Member -MemberType NoteProperty TimeGenerated $date -Force
		$currentLineObj
	}
	#$enhanced | select TimeGenerated,LocalAddressIP,LocalAddressPort,ForeignAddressIP,ForeignAddressPort,Name,ProcessId,ProcessExePath,ProcessSHA1,CommandLine,ParentProcessName,ParentProcessId,ParentProcessExePath, ParentProcessSHA1
}

foreach($item in $enhanced){
Add-Type -AssemblyName PresentationFramework
$UserResponse= [System.Windows.Forms.MessageBox]::Show("Local IP:    $($item.LocalAddressIP)`n`nLocal Port:    $($item.LocalAddressPort)`n`nRemote IP:    $($item.ForeignAddressIP)`n`nRemote Port:    $($item.ForeignAddressPort)`n`nProcess Name:    $($item.Name)`n`nProcess ID:    $($item.ProcessId)`n`nProcess Exe Path:    $($item.ProcessExePath)`n`nProcess SHA1:    $($item.ProcessSHA1)`n`nCmdline:    $($item.commandline)`n`nParent Process Name:    $($item.ParentProcessName)`n`nParent Process ID:    $($item.ParentProcessId)`n`nParent Process Exe Path:    $($item.ParentProcessExePath)`n`nParent Process SHA1:    $($item.ParentProcessSHA1)`n`n                                                                               'Yes' - Terminate Process`n                                                                               'No' - Acknowledge" , "Connection Watcher" , 4)
    if ($UserResponse -eq "Yes" ){
        stop-process -Id ($item.ProcessId)
    } 

    else{ 
        #
    }
}
Remove-Variable enhanced -ErrorAction SilentlyContinue; Remove-Variable currentLineObj -ErrorAction SilentlyContinue
Start-Sleep $cycle

}
