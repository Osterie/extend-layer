#Requires AutoHotkey v2.0

#Include <Actions\HotkeyAction>

class Keyboard extends HotkeyAction{


    sendInputRepeatedly := false
    sendKeyObj := ObjBindMethod(this, "SendKey")
    
    BlockKeyInput(){
        Loop 512{
            Key := Format("SC{:X}",A_Index)
            this.DisableKey(Key)
        }
    }

    UnBlockKeyInput(){
        Loop 512{
            Key := Format("SC{:X}",A_Index)
            this.EnableKey(Key)
        }
    }

    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    EnableKey(key){
        Hotkey("*" . key, this.DoNothing, "Off UseErrorLevel")
    }
    
    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    DisableKey(key){
        Hotkey("*" . key, this.DoNothing, "On UseErrorLevel")
    }

    DoNothing(){
        return
    }

    SendKeyBoardInput(key){
        SendInput(key)
    }

    SendRepeatInput(key, sendsPerSecond){
        this.sendInputRepeatedly := !this.sendInputRepeatedly

        if (this.sendInputRepeatedly){
            this.StartRepeatSendInput(key, sendsPerSecond)
        } else {
            this.StopRepeatSendInput()
        }
    }

    StartRepeatSendInput(key, sendsPerSecond){
        this.sendKeyObj := ObjBindMethod(this, "SendKey", key)
        
        sendDelay := 1000/sendsPerSecond
        if (sendDelay < 10){
            sendDelay := 0
        }
        

        SetTimer this.sendKeyObj, sendDelay
    }

    StopRepeatSendInput(){
        SetTimer(this.sendKeyObj, 0)
    }

    SendKey(key){
        SendInput(key)
    }
}