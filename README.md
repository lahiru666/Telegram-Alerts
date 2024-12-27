# Telegram-Alerts
## zero cost server monitoring powershell script

Inorder to script to work you need to install poshgram powershell module (which used to send telegram messages via powershell),telegram group and a telegram bot.
you can use windows task sheduler to run this script peridically.

you need to store your bottoken  as a environment variable 

[System.Environment]::SetEnvironmentVariable('TELEGRAM_BOT_TOKEN', '0000000000000000000000000000', [System.EnvironmentVariableTarget]::User)

then you can call this later in your powershell script
