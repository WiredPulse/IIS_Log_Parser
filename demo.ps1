# Connection Watcher
function Connection-Watcher{
	$date = get-date
    $NoHash = $false
    $data =  Get-NetTCPConnection -State Established 

    $enhanced = foreach($item in $data){
    
    $properties=@{
    LocalAddressIP = $item.localaddress
    LocalAddressPort = $item.localport
    ForeignAddressIP = $item.remoteaddress
    ForeignAddressPort = $item.remoteport
    ProcessId = $item.owningProcess
    }

        
		$currentLineObj = New-Object -TypeName PSObject -Property $properties
		$proc = get-wmiobject -query ('select * from win32_process where ProcessId="{0}"' -f ($data.owningprocess))
		$currentLineObj | Add-Member -MemberType NoteProperty ParentProcessId $proc.ParentProcessId
		$currentLineObj | Add-Member -MemberType NoteProperty Name $proc.Caption
		$currentLineObj | Add-Member -MemberType NoteProperty ExecutablePath $proc.ExecutablePath
		if ($currentLineObj.ExecutablePath -ne $null -AND -NOT $NoHash) {
			$sha1 = New-Object -TypeName System.Security.Cryptography.SHA1CryptoServiceProvider
			$hash = [System.BitConverter]::ToString($sha1.ComputeHash([System.IO.File]::ReadAllBytes($proc.ExecutablePath)))
			$currentLineObj | Add-Member -MemberType NoteProperty SHA_1 $($hash -replace "-","")
		}
		else {
			$currentLineObj | Add-Member -MemberType NoteProperty SHA_1 $null
		}
		$currentLineObj | Add-Member -MemberType NoteProperty CommandLine $proc.CommandLine
		$currentLineObj | Add-Member -MemberType NoteProperty TimeGenerated $date 
		$currentLineObj
	}
	$enhanced | select Date,LocalAddressIP,LocalAddressPort,ForeignAddressIP,ForeignAddressPort,Name,ProcessId,ParentProcessId,ExecutablePath,SHA_1,CommandLine
}


function Verbose-Netstat{

$date = get-date
$net =  Get-NetTCPConnection

$script:enhanced = foreach($item in $net){        
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
	$enhanced | select TimeGenerated,LocalAddressIP,LocalAddressPort,ForeignAddressIP,ForeignAddressPort,Name,ProcessId,ProcessExePath,ProcessSHA1,CommandLine,ParentProcessName,ParentProcessId,ParentProcessExePath, ParentProcessSHA1
}


function Connection-Watcher{

$date = get-date
$net =  Get-NetTCPConnection -State Established 

$datePast = (get-date).AddSeconds(-360)
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
	$enhanced | select TimeGenerated,LocalAddressIP,LocalAddressPort,ForeignAddressIP,ForeignAddressPort,Name,ProcessId,ProcessExePath,ProcessSHA1,CommandLine,ParentProcessName,ParentProcessId,ParentProcessExePath, ParentProcessSHA1
}

}

