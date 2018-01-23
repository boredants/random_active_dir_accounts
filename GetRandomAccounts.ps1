Import-Module ActiveDirectory

Write-Host "`n******************************************************************"
Write-Host "*RETRIEVE A NUMBER OF RANDOM ACCOUNTS FROM AN ORGANIZATIONAL UNIT*"
Write-Host "******************************************************************"

$numAccounts = Read-Host -Prompt "`nEnter number of accounts to retrieve: "
$resultsFile = Read-Host -Prompt "`nEnter a name for the CSV results file: "
$OU = Read-Host -Prompt "`nEnter the name of the OU to search: "

#Edit this for your domain
$OU = "OU="+$OU+",DC=<your>,DC=<domain>,DC=<here>"

Get-ADUser -Filter * -SearchBase $OU -Properties * | select GivenName, Surname, EmailAddress | Sort-Object{Get-Random} |`
Select -First $numAccounts | ConvertTo-Csv -NoTypeInformation -Delimiter "," | % {$_ -replace '"',''} | Select-Object -Skip 1 |`
 Set-Content -Path $resultsFile
