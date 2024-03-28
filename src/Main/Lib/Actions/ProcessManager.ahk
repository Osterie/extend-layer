#Requires AutoHotkey v2.0

#Include <Actions\Action>

Class ProcessManager extends Action{

    CloseFocusedProcess(){
        Send("!{f4}")
    }

    CloseProcessByPID(pid){
        ; TODO: Implement
    }

    CloseProcessByName(name){
        ; TODO: Implement

    }

    GetProcessPathByPID(pid){
        ; TODO: Implement

        ; Run "license.rtf",,, &pid  ; This is likely to exist in C:\Windows\System32.
        ; try {
        ;     name := ProcessGetName(pid)
        ;     path := ProcessGetPath(pid)
        ; }
        ; MsgBox "Name: " (name ?? "could not be retrieved") "`n"
        ;     .  "Path: " (path ?? "could not be retrieved")
    }

    GetProcessNameByPID(pid){
        ; TODO: Implement
    }

    ChangeProcessPriorityByPID(pid, priority){
        
    }

    


    CloseActiveAutohotkeyScript(){
        Exitapp
    }
    
    SuspendActiveAutohotkeyScript(){
        Suspend    
    }
}