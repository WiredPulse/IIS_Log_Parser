$filepath = "< Path to a log file>"
$headers = (Get-Content -Path $filePath -TotalCount 4 | Select -First 1 -Skip 3) -replace '#Fields: ' -split ' '
(Get-Content $filePath | Select-String -Pattern '^#' -NotMatch | ConvertFrom-Csv -Delimiter ' ' -Header $headers).length
