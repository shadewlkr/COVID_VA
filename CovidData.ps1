#vars
$vaZipList = import-csv .\zips\VaZipList.csv
$url = "https://data.virginia.gov/resource/8bkr-zfqv"
$apptoken = "MafEnKnT2umo6SehMWTC2maDt"
$todaysDate = (get-date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).ToString("yyyy-MM-ddTHH:mm:ss.fff")
$yesterdaysDate = (get-date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss.fff")
$dayBeforeYesterdaysDate = (get-date -Hour 0 -Minute 0 -Second 0 -Millisecond 0).AddDays(-2).ToString("yyyy-MM-ddTHH:mm:ss.fff")
$queryZip = Read-Host "Enter Virginia City Name you want to search..."`n

#query va zip list
$vaCityZips = ($vaZipList | ?{$_.City -eq $queryZip})."Zip Code"

# Set header to accept JSON
$headers = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
$headers.Add("Accept","application/json")
$headers.Add("X-App-Token",$apptoken)


#get and filter results by zip for past 3 days
foreach ($vaZip in $vaCityZips){

$results = Invoke-RestMethod -Uri $url"?zip_code=$vaZip" -Method get -Headers $headers

$todaysResults = $results | ?{$_.report_date -eq $todaysDate}
$yesterdaysResults = $results | ?{$_.report_date -eq $yesterdaysDate}
$dayBeforeYesterdaysResults = $results | ?{$_.report_date -eq $dayBeforeYesterdaysDate}

$allResults = $todaysResults, $yesterdaysResults, $dayBeforeYesterdaysResults

$allResults
 }

