# Start your day, automatically!
# This script helps you get some extra minutes of peace and quit in, while working for you.
#
# $keepass_db_name -> The KeePass DB to open 
#

####################### Check if these globals are correct and change them if not #######################

# Name of KeePass DB
$keepass_db_name = "SomeKeePassDatabaseName.kdbx"

##########################################################################################################




# ------------------------------------------- leave this code alone ------------------------------------------
# global failcounter
$wait_counter = 0
# needed for sending keystrokes
$wshell = New-Object -ComObject wscript.shell;

# used to check if this is first start. you may not want to run some things on restart.
function is_first_start()
{
    $LogonEvents = Get-WinEvent -FilterHashTable @{ LogName = "System"; StartTime = (Get-Date -Hour 0 -Minute 0); ID = 7001 }
    if($LogonEvents.length -eq 1)
    {
        return $true
    } else
    {
        return $false
    }
}

# you may have to edit if your system isnt in german.
function wait_till_keepass_open() {
    if ($wshell.AppActivate($keepass_db_name + ' - KeePass')) {
        while(-Not $wshell.AppActivate($keepass_db_name + ' - KeePass')) {
            Sleep 1
        }
    } else {
        if (-Not $wshell.AppActivate('Datenbank öffnen - ' + $keepass_db_name)) {
            while(-Not $wshell.AppActivate('Datenbank öffnen - ' + $keepass_db_name)) {
                Sleep 1
            }
        }
        while($wshell.AppActivate('Datenbank öffnen - ' + $keepass_db_name)) {
            Sleep 1
        }
    }
}

function start_keepass() {
    $keepass_running = Get-Process keepass -ErrorAction SilentlyContinue
    if (-Not $keepass_running) {
        Start-Process "X:\Path\to\KeePass.exe"
        Sleep 5
        while(-Not $wshell.AppActivate($keepass_db_name + ' - KeePass')) {
            Sleep 1
        }
    }
}

# EXAMPLE -> Run another PowerShell script from within with powershell logon window (script in same path as this)
function connect_fileshares() {
    wait_till_keepass_open
    start powershell "$PSScriptRoot\do_some_thing.ps1"
    
    while (-Not $wshell.AppActivate('Anforderung für Windows PowerShell-Anmeldeinformationen.')) {
        $wait_counter = $wait_counter + 2
        if ($wait_counter -ge 12) {
            $wait_counter = 0
            return
        }
        Sleep 2
    }
    $wshell.SendKeys('(^%(i))') # -> KeePass auto-type login sequence
    Sleep 5
}

# EXAMPLE -> Start some Program with login 
function start_PROGRAMM() {
    wait_till_keepass_open

    $PROGRAM_NAME_running = Get-Process PROGRAM_NAME -ErrorAction SilentlyContinue
    if (-Not $PROGRAM_NAME_running) {
        Start-Process "X:\PATH\to\PROGRAM_NAME.exe"
    
        while(-Not $wshell.AppActivate('PROGRAM TITLE')) {
            $wait_counter = $wait_counter + 2
            if ($wait_counter -ge 12) {
                $wait_counter = 0
                return
            }
            Sleep 2
        }
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('(^%(i))')  # -> KeePass auto-type login sequence
        Sleep 5
    }
}


# EXAMPLE -> open websites with login with Edge
# --- Sites w/ Login
function login_website_1() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://blah.blah.de
    Sleep 5
    $wshell.SendKeys('(^%(i))')  # -> KeePass auto-type login sequence
    Sleep 9
}

# exmaple with single sign on option
function login_website_2(){
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://other-example.de
    Sleep 5
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('{TAB}')
    $wshell.SendKeys('{ENTER}')
    Sleep 3
}

# --- Sites no Login
function open_slack() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://your-slack-channel.com
    
    # only greet people on first start
    if (is_first_start) {
        Sleep 5
        #$wshell.SendKeys("+({UP})")
        #Sleep 3
        #$wshell.SendKeys("Ha-Ha, good joke! :joy:")
        #Sleep 5
        #$wshell.SendKeys('{ENTER}')
        #Sleep 3
        $wshell.SendKeys('(^+(l))') # set focus to main chat 
        Sleep 2
        $wshell.SendKeys('Hi, gang! :wave: ')
        Sleep 8
        $wshell.SendKeys('{ENTER}')
        Sleep 1
    } 
    Sleep 5
}

function open_internal_page() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:http://blah.internal.domain
    Sleep 1
}

function open_google() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://www.google.de/
    Sleep 1
}

# EXAMPLE -> go to website and do something
function open_time_management() {
    $wshell.AppActivate('Edge')
    start microsoft-edge:https://some-other-link.com
    $wshell.AppActivate('Edge')
    if (is_first_start) {
        Sleep 8
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        Sleep 2

        $wshell.SendKeys('{ENTER}')

        Sleep 2
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        $wshell.SendKeys('{TAB}')
        Sleep 2

        $wshell.SendKeys('{DOWN}')
        Sleep 2
        $wshell.SendKeys('{ENTER}')
        Sleep 1
    }
    Sleep 5
}
# ------------------------------------------- leave this code alone ende ------------------------------------------






# ------------------- if you dont want to start/login some apps here then just comment out -------------------------
function main() {
    
    # KeePass MUST be started first
    start_keepass

    # Running another ps1 script to connect some fileshares, that need authentication (or any PowerShell script)
    connect_fileshares
    
    # Start a lokal program, wait till loaded, login
    start_PROGRAMM
    Sleep 5
    
    # Open Edge, go to website, login 
    login_website_1
    Sleep 5
    
    # Opens website in new tab, login
    login_website_2
    Sleep 5
    
    # open slack in new tab and say hi to the team
    open_slack
    Sleep 5
    
    # open some internal page
    open_internal_page
    Sleep 5
    
    # open google, why not?
    open_google
    
    # open some webapp and navigate/push some buttons
    # ich chose time management as an example since a lot of ppl work remote
    open_time_management

}
main

