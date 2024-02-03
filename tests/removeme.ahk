#Requires AutoHotkey v2.0

#SingleInstance Force ; skips the dialog box and replaces the old instance automatically
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 100
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super)
SendMode "Event"

Class Test{

    __New(){

        objectText := {}
        objectText.key := "b"
        objectText.modifiers := "^"

        this.InitializeDefaultKeyToNewKey("<^Left", objectText)
    }



    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    InitializeDefaultKeyToNewKey(oldHotKey, newKeyInformation, enableHotkeys := true){
        newHotKey := newKeyInformation.key
        newHotKeyModifiers := newKeyInformation.modifiers
        
        newKeysDown := this.CreateExcecutableKeysDown(newHotKey)
        newKeysUp := this.CreateExcecutableKeysUp(newHotKey)

        if (enableHotkeys){
            try{
                HotKey(oldHotKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "On") 
                HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "On")
                ; msgbox("going to try")
            }
            catch{
                msgbox("error in InitializeDefaultKeyToNewKey, state is on")
            }
        }
        else if (enableHotkeys = false){
            HotKey(oldHotKey, (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "Off") 
            HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "Off")
        } 
        else {
            msgbox("error in InitializeDefaultKeyToNewKey, state is not on or off")
        }
    }

    ; Sends key(s) down, including possible modifiers
    SendKeysDown(keysDown, modifiers){
        ; msgbox("going to sedn")
        Send("{blind}" . modifiers . keysDown)
    }
    
    ; Sends key(s) up, including possible modifiers
    SendKeysUp(keysUp, modifiers){
        Send("{blind}" . modifiers . keysUp)
    }

    CreateExcecutableKeysDown(keys){
        keysList := StrSplit(keys, "||")
        excecutableKeysDown := ""
        for key in keysList{
            excecutableKeysDown .= "{" . key . " Down}"
        }
        return excecutableKeysDown
    }

    CreateExcecutableKeysUp(keys){
        keysList := StrSplit(keys, "||")
        excecutableKeysUp := ""
        for key in keysList{
            excecutableKeysUp .= "{" . key . " Up}"
        }
        return excecutableKeysUp
    }

}

; test1 := Test()