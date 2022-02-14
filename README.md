# Good morning Berlin!

If you're working like me, then you like to work smarter not harder and squeeze efficiency to the last drop! You also like to do multiple things at once.
I use an average of 16 differen Tools, Web and or lokal, I have an account for each and I have to log into most of them in the morning. Most company networks are very restricitve of scripting languages, so usually you only have PowerShell or vbscript. If you have no restrictions then...hit me up, because you should probaby have SOME restrictions... :,)

Anyways, let's assume you can use PowerShell and would like to grab a coffee while your computer is doing some loggin in and starting up

### Dependencies 
I use KeePass so I do not have to harcode credentials inside of my code. You could use any other password manager as long as they have some sort of auto-type function.
In KeePass you can configure something like "If window with title 'Blah Manager' is open and i press 'ctrl + alt + i' then enter username press tab enter password and press enter. 
- PowerShell
- KeePass 2 (You can use any pw manager with auto-type functionality)

## Starting KeePass
Waits till you logged in to KeePass. KeePass has to be open, otherwise auto-type won't work.
```powershell
function start_keepass() {
    $keepass_running = Get-Process keepass -ErrorAction SilentlyContinue
    if (-Not $keepass_running) {
        Start-Process "C:\Program Files (x86)\KeePass Password Safe 2\KeePass.exe"
        Sleep 5
        while(-Not $wshell.AppActivate($keepass_db_name + ' - KeePass')) {
            Sleep 1
        }
    }
}
```


## Example 1:
Starting a Mailclient and logging in.
check the source for `wait_till_keepass_open` function
```powershell
function start_mail_client() {
    wait_till_keepass_open

    $notes_running = Get-Process MAIL_CLIENT -ErrorAction SilentlyContinue
    if (-Not $notes_running) {
        Start-Process "C:\Program Files (x86)\MAIL_CLIENT\MAIL_CLIENT.exe"
    
        while(-Not $wshell.AppActivate('MAIL_CLIENT Login Window Title')) {
            $wait_counter = $wait_counter + 2
            if ($wait_counter -ge 12) {
                $wait_counter = 0
                return
            }
            Sleep 2
        }
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('(^%(i))') #-> KeePass autotype keyboard shortcut, standard is $wshell.SendKeys('(^%(l))')
        Sleep 5
    }
}
```

## Example 2:
Open a website and login (opens all websites in a new tab)
```powershell
function login_website() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://some-website.com
    Sleep 5
    $wshell.SendKeys('(^%(i))') #-> KeePass autotype keyboard shortcut, standard is $wshell.SendKeys('(^%(l))')
    Sleep 9
```

## Example 3:
Open messenger like Slack and say hi
```powershell
function open_chat() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://this-is-messenger.com
    if (is_first_start) {
        $wshell.SendKeys('(^+(l))') # -> slack keyboard to focus chat window 
        Sleep 2
        $wshell.SendKeys('Good Morning everyone! :wave: ')
        Sleep 8
        $wshell.SendKeys('{ENTER}')
        Sleep 1
    } 
    Sleep 5
}
```

# Deployment
## Option 1
You can run the script from anywhere, just mind the KeePass database path and the paths to the applications you are trying to open.
You'll have to change this line in the code:
```
# Name of KeePass DB
$keepass_db_name = "SomeKeePassDatabaseName.kdbx"
```

## Option 2
I assume this is what most people came here for, running this script on startup:
I have a "Scripts" directory on my Desktop where i have all my script. I then run the goodmorningberlin.ps1 through a vbscript in startup.

1. Create Scripts directory and move GoodMorningBerlin.ps1 in there
2. Create a script named `starter.vbs` in the Windows startup directory (probably here `C:\Users\meeeeeeee\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`)
```vbs
Dim objShell
Set objShell = Wscript.CreateObject("WScript.Shell")

objShell.Run("Path\to\Desktop\Scripts\keypresser.vbs")
WScript.Sleep 1000
objShell.Run("powershell -noexit -file Path\to\Desktop\Scripts\GoodMorningBerlin.ps1")

Set objShell = Nothing
```
This will run every time you start or restart your computer.

# Bonus
VBS-Caffeine Script (the keypresser.vbs above)
```vbs
Dim objResult

Set objShell = WScript.CreateObject("WScript.Shell")
i = 0

do while i = 0
	objResult = objShell.sendkeys("{NUMLOCK}{NUMLOCK}")
	WScript.Sleep (120000)

Loop 
```



