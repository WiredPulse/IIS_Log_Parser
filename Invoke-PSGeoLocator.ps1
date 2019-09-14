$filepath = "< Path to a log file >"
$api = "< API key from https://ipapi.com/ >
$headers = (Get-Content -Path $filePath -TotalCount 4 | Select -Skip 3) -replace '#Fields: ' -split ' '
$headers += "city", "region", "country", "continent"

$log = Get-Content $filePath | Select-String -Pattern '^#' -NotMatch
$log | Add-Member -MemberType ScriptProperty -Name 'City' -Value {$null}
$log | Add-Member -MemberType ScriptProperty -Name 'Region' -Value {$null}
$log | Add-Member -MemberType ScriptProperty -Name 'Country' -Value {$null}
$log | Add-Member -MemberType ScriptProperty -Name 'Continent' -Value {$null}
Remove-Variable address -ErrorAction SilentlyContinue

$records = Get-Content $filePath | Select-String -Pattern '^#' -NotMatch | ConvertFrom-Csv -Delimiter ' ' -Header $headers
$address = ($records |Sort-Object c-ip -Unique)."c-ip"

foreach($item in $address){
    $uriIp = "http://api.ipapi.com/$item" + $api
    $request = Invoke-RestMethod -Method Get -Uri $uriIp
    foreach($record in $records){
        if($record."c-ip" -eq $item){
            try{$record.city = $request.city} catch{}
            try{$record.region = $request.region_name} catch{}
            try{$record.country = $request.country_code} catch{}
            try{$record.continent = $request.continent_name} catch{}  
        }
    }
}
$records
