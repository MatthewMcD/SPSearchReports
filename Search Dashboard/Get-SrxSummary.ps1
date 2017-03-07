#This script goes along with the Blog Post:
#https://searchexplained.com/create-a-search-service-status-dashboard

########## Variables ##########
$destination = "SQL"
$searchReport = @()
$username = "youruser"
$password = $null
########## End Variables #########
$batchTimeStamp = Get-Date
$batchTimeStamp = $batchTimeStamp.ToString("yyyy-MM-dd HH:mm:ss")

#Load Functions
. .\Live360-SharePoint2016-Tasks\Reporting\Reporting-Functions.ps1
. .\Live360-SharePoint2016-Tasks\FunctionFiles\Export-XLSX.ps1


.\SRxCore\initSRx.ps1

if($destination -eq "SQL"){
    $con = New-Object System.Data.SQLClient.SqlConnection
    #On Prem
    #$con.ConnectionString = "Data Source=SQLServerL;Initial Catalog=Databaseg;User ID=spReporting;Password=mypassword"
    #Azure
    #Get Credentials from a file, use https://github.com/benstegink/PowerShellScripts/blob/master/Misc/Create-CredentialFile.ps1 to create the file and make it of type SQL
    if($password -eq $null){
        $password = get-content User-PowershellCreds.txt | ConvertTo-SecureString
        $creds = New-Object System.Management.Automation.PSCredential -argumentlist $username,$password
        $username = $creds.UserName
        $password = $creds.GetNetworkCredential().Password
    }

    $con.ConnectionString = "Server=tcp:yoursqlserver.database.windows.net;Database=YourDB;`
                            User ID=$username;Password=$password;Trusted_Connection=False;Encrypt=True;"
    $con.Open()
    $cmd = New-Object System.Data.SqlClient.SqlCommand
    $cmd.Connection = $con
}


#New-SRxReport -RunAllTests

Test-SRx -RunAllTests | ForEach-Object{

    $reportObject = New-Object PSObject

    if($destination -eq "SQL"){
        [datetime]$timestamp = $_.Timestamp
        $timestamp = $timestamp.ToString("yyyy-MM-dd HH:mm:ss")

        $cmd.CommandText = "INSERT INTO SrxReportSummary (BatchTimeStamp,Data,Alert,Category,Headline,Timestamp,Result,Details,Name,FarmId,Level,RunId,ControlFile,Dashboard,Source) VALUES('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}')" -f $batchTimeStamp,$_.Data, $_.Alert, $_.Category, $_.Headline.Replace("'","''"), $timestamp, $_.Result, $_.Details, $_.Name, $_.FarmId, $_.Level, $_.RunId, $_.ControlFile, $_.Dashboard, $_.Source

        $foo = $cmd.ExecuteNonQuery()
    }
    elseif($destination -eq "XLS"){
        $reportObject | Add-Member -MemberType NoteProperty -Name "Data" -Value $_.Data
        $reportObject | Add-Member -MemberType NoteProperty -Name "Alert" -Value $_.Alert
        $reportObject | Add-Member -MemberType NoteProperty -Name "Category" -Value $_.Category
        $reportObject | Add-Member -MemberType NoteProperty -Name "Headline" -Value $_.Headline
        $reportObject | Add-Member -MemberType NoteProperty -Name "Timestamp" -Value $_.Timestamp
        $reportObject | Add-Member -MemberType NoteProperty -Name "Result" -Value $_.Result
        $reportObject | Add-Member -MemberType NoteProperty -Name "Details" -Value $_.Details
        $reportObject | Add-Member -MemberType NoteProperty -Name "Name" -Value $_.Name
        $reportObject | Add-Member -MemberType NoteProperty -Name "FarmId" -Value $_.FarmId
        $reportObject | Add-Member -MemberType NoteProperty -Name "Level" -Value $_.Level
        $reportObject | Add-Member -MemberType NoteProperty -Name "RunId" -Value $_.RunId
        $reportObject | Add-Member -MemberType NoteProperty -Name "ControlFile" -Value $_.ControlFile
        $reportObject | Add-Member -MemberType NoteProperty -Name "Dashboard" -Value $_.Dashboard
        $reportObject | Add-Member -MemberType NoteProperty -Name "Source" -Value $_.Source

        $searchReport += $reportObject
    }
}

if($destination -eq "SQL"){
$con.Close()
}
elseif($destination -eq "XLS"){
    #Output to an Excel File
    $searchReport | Export-XLSX -Path c:\users\ruby\desktop\SearchReport.xlsx -NoClobber -Append
}
