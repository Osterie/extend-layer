#Requires AutoHotkey v2.0

Class ProcessManager{

    CloseFocusedProcess(){
        Send("!{f4}")
    }

    CloseProcessByPID(pid){
        ; TODO: Implement
    }


    CloseActiveAutohotkeyScript(){
        Exitapp
    }
    
    SuspendActiveAutohotkeyScript(){
        Suspend
    }
}