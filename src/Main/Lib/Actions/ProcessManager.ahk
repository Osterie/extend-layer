#Requires AutoHotkey v2.0

#Include <Actions\Action>

Class ProcessManager extends Action{

    CloseFocusedProcess(){
        Send("!{f4}")
    }

    ; Closes a process by its name, or PID
    CloseProcess(process){
        DetectHiddenWindows(true)
        tries := 0
        while (ProcessExist(process) && tries < 10) {
            pid := ProcessExist(process)
            if pid {
                ProcessClose(pid)
                Sleep 500 ; Wait for 0.5 seconds
                tries++
                if !ProcessExist(process) {
                    return true
                }
            }
        }
        if !ProcessExist(process) {
            return true
        }
        return false
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