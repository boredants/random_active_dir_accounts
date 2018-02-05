#This is used to get user lists for phishing education campaigns

Import-Module ActiveDirectory

Write-Host "`n******************************************************************"
Write-Host "*RETRIEVE A NUMBER OF RANDOM ACCOUNTS FROM AN ORGANIZATIONAL UNIT*"
Write-Host "******************************************************************"

$numAccounts = Read-Host -Prompt "`nEnter number of accounts to reteive: "
$resultsFile = Read-Host -Prompt "`nEnter a name for the CSV results file: "
$OU = Read-Host -Prompt "`nEnter the name of the OU to search: "

$OU = "OU="+$OU+",DC=<YOUR>,DC=<DOMAIN>,DC=<HERE>"

$randomAccounts = Get-ADUser -Filter * -SearchBase $OU -Properties * |`
 where {$_.extensionAttribute15 -ne "1" -and $_.name -notmatch "^[Tt]est"} |`
 Sort-Object{Get-Random} | Select -First $numAccounts

Foreach ($acct in $randomAccounts)
{
write-host $acct #sanity check - remove if not needed
Set-ADUser -Identity $acct -Add @{extensionAttribute15 = "1"}
$acct=$acct.ToString()
$acct=$acct.Split(",")
$acct=$acct[0].TrimStart("CN=")
Get-ADUser -Identity $acct -Properties * | select GivenName, Surname, EmailAddress |`
 Export-Csv -NoTypeInformation -Delimiter "," -Append -Path $resultsFile
 }


 #Notes
 #I am setting extensionAttribute15 equal to 1 when a user is randomly selected for a phishing test
 #as a way to keep track of who has and hasn't been picked.
 #Once everyone in an OU has been selected, we will remove the attribute from all users and start over
 #I also use a simple regular expression to skip over test accounts

 #List users with the extra attribute set
 #Get-ADUser -Filter * -Properties * -SearchBase "OU=<YOUR OU>,DC=<YOUR>,DC=<DOMAIN>,DC=<HERE>"
 #| where {$_.extensionAttribute15 -eq "1"} | Select-Object -Property Name

 #Remove the extra attribute
 #Get-ADUser -Filter * -Properties * -SearchBase "OU=<YOUR OU>,DC=<YOUR>,DC=<DOMAIN>,DC=<HERE>"
 #| where {$_.extensionAttribute15 -eq "1"} | % {Set-aduser $_.Name -Remove @{extensionAttribute15 = "1"}}
