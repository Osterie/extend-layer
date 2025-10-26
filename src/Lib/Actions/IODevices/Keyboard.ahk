#Requires AutoHotkey v2.0

#Include <Actions\HotkeyAction>

class Keyboard extends HotkeyAction {

    sendInputRepeatedly := false
    sendKeyObj := ObjBindMethod(this, "SendKey")

    destroy() {
        this.UnBlockKeyInput()
        this.StopRepeatSendInput()
        ; This method is called when the object is destroyed.
        ; This method is required to be implemented in the subclass of HotkeyAction.
    }

    BlockKeyInput() {
        loop 512 {
            Key := Format("SC{:X}", A_Index)
            this.DisableKey(Key)
        }
    }

    UnBlockKeyInput() {
        loop 512 {
            Key := Format("SC{:X}", A_Index)
            this.EnableKey(Key)
        }
    }

    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    EnableKey(key) {
        MsgBox("enagls")
        Hotkey("*" . key, this.DoNothing, "Off")
    }

    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    DisableKey(key) {
        Hotkey("*" . key, this.DoNothing, "On")
    }

    DoNothing() {
        return
    }

    SendKeyBoardInput(key) {
        SendInput(key)
    }

    SendRepeatInput(key, sendsPerSecond) {
        this.sendInputRepeatedly := !this.sendInputRepeatedly

        if (this.sendInputRepeatedly) {
            this.StartRepeatSendInput(key, sendsPerSecond)
        } else {
            this.StopRepeatSendInput()
        }
    }

    StartRepeatSendInput(key, sendsPerSecond) {
        this.sendKeyObj := ObjBindMethod(this, "SendKey", key)

        sendDelay := 1000 / sendsPerSecond
        if (sendDelay < 10) {
            sendDelay := 0
        }

        SetTimer this.sendKeyObj, sendDelay
    }

    StopRepeatSendInput() {
        SetTimer(this.sendKeyObj, 0)
    }

    SendKey(key) {
        SendInput(key)
    }

    Paste() {
        SendInput("^v")
    }

    ReversePaste() {
        originalClipboardValue := A_Clipboard
        
        A_Clipboard := this.reverseString(originalClipboardValue)
        this.Paste()
        Sleep(100) ; Some applications have custom paste handlers, not using sleep(100) would result in the pasted string not being reversed.

        A_Clipboard := originalClipboardValue
    }

    ReverseWordOrderPaste() {
        originalClipboardValue := A_Clipboard
        
        A_Clipboard := this.reverseOrder(originalClipboardValue)
        this.Paste()
        Sleep(100) ; Some applications have custom paste handlers, not using sleep(100) would result in the pasted string not being reversed.

        A_Clipboard := originalClipboardValue
    }

    reverseString(text) {
        reversed := ""
        Loop Parse text
            reversed := A_LoopField . reversed
        return reversed
    } 

    reverseOrder(text){
        reversed := ""
        Loop Parse text, " "
            reversed := A_LoopField . " " . reversed
        reversed := SubStr(reversed, 1, -1) ; Remove trailing space
        return reversed
    }
    
 }
