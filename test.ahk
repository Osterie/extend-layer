#Requires AutoHotkey v2.0

inputBoxWebSearch := InputBox("What would you like to search in the browser?", "Web search", "w150 h150")
if inputBoxWebSearch.Result = "Cancel"
    MsgBox "You entered '" inputBoxWebSearch.Value "' but then cancelled."
else
    MsgBox "You entered '" inputBoxWebSearch.Value "'."
esc::ExitApp
