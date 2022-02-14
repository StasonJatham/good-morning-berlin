Dim objResult
Set objShell = WScript.CreateObject("WScript.Shell")
i = 0
do while i = 0
	objResult = objShell.sendkeys("{NUMLOCK}{NUMLOCK}")
	WScript.Sleep (120000)
Loop
