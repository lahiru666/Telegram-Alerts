#importing poshgram module for telegram messenging
Import-Module -Name PoshGram

#telegram bottoken and chat id
$bottoken = "0000000000000000000000000000"
$chat_id = "-000000"

#get date 
$date = get-date

#write a started status to a text file 

"script started at $date" | Out-File C:\Users\lahiru.priyankara\Documents\status.txt -Append

#checking server up status before checking the service
$activeDirectory = Test-NetConnection -ComputerName ad -ErrorAction SilentlyContinue 
$exchangeServer = Test-NetConnection -computername exchange -ErrorAction SilentlyContinue 


#active directory server
if ($activeDirectory.PingSucceeded) {
    $servicesToCheck = @(
        "ismserv",
        "W32Time",
        "Netlogon",
        "kdc",
        "ntfs"
    )

    foreach ($service in $servicesToCheck) {
        $serviceStatus = Invoke-Command -ComputerName $activeDirectory.ComputerName -ScriptBlock { Get-Service -Name $using:service -ErrorAction SilentlyContinue }
        
        if ($serviceStatus.Status -eq "Stopped") {
            $serviceName = $serviceStatus.DisplayName
            $serverName = $activeDirectory.ComputerName
            $message = "$serviceName Service On Server $serverName Has Stopped"
            Send-TelegramTextMessage -BotToken $bottoken -ChatID $chat_id -Message $message -ErrorAction SilentlyContinue | Out-Null
        }
    }
}
else {
    $message = "No Response From Server activedirectory [$date]"
    Send-TelegramTextMessage -BotToken $bottoken -ChatID $chat_id -Message $message -ErrorAction SilentlyContinue | Out-Null
}


#exchange server
if ($exchangeServer.PingSucceeded) {
    $servicesToCheck = @(
        "MSExchangeADTopology",
        "MSExchangeAntispamUpdate",
        "MSExchangeDagMgmt",
        "MSExchangeDelivery",
        "MSExchangeDiagnostics",
        "MSExchangeEdgeSync",
        "MSExchangeFastSearch",
        "MSExchangeFrontEndTransport",
        "MSExchangeHM",
        "MSExchangeImap4",
        "MSExchangeIMAP4BE",
        "MSExchangeIS",
        "MSExchangeMailboxAssistants",
        "MSExchangeMailboxReplication",
        "MSExchangePop3",
        "MSExchangePOP3BE",
        "MSExchangeRepl",
        "MSExchangeRPC",
        "MSExchangeServiceHost",
        "MSExchangeSubmission",
        "MSExchangeThrottling",
        "MSExchangeTransport",
        "MSExchangeTransportLogSearch",
        "MSExchangeUM",
        "MSExchangeUMCR"
        
    )

    foreach ($service in $servicesToCheck) {
        $serviceStatus = Invoke-Command -ComputerName $exchangeServer.ComputerName -ScriptBlock { Get-Service -Name $using:service -ErrorAction SilentlyContinue }
        
        if ($serviceStatus.Status -eq "Stopped") {
            $serviceName = $serviceStatus.DisplayName
            $serverName = $exchangeServer.ComputerName
            $message = "$serviceName Service On Server $serverName Has Stopped"
            Send-TelegramTextMessage -BotToken $bottoken -ChatID $chat_id -Message $message -ErrorAction SilentlyContinue | Out-Null
        }
    }
}
else {
    $message = "No Response From Server exchangeserver [$date]"
    Send-TelegramTextMessage -BotToken $bottoken -ChatID $chat_id -Message $message -ErrorAction SilentlyContinue | Out-Null
}


#write a ended status to a text file

"script finished running at $date" | Out-File C:\Users\lahiru.priyankara\Documents\status.txt -Append
