#Requires AutoHotkey v2.0

Class ApplicationManipulator{

    CloseActiveApplication(){
        Send("!{f4}")
    }

    CloseActiveAutohotkeyScript(){
        Exitapp
    }
    
    SuspendActiveAutohotkeyScript(){
        Suspend
    }
}