#Requires AutoHotkey v2.0


A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 0
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super   ø)
SendMode "Event"

Class Tester{
    name := "Tester"
    age := 20

    printName(){
        MsgBox(this.name)
    }
    setName(name){
        this.name := name
    }
    getName(){
        return this.name
    }
    CloseTabsToTheRight(){
        MsgBox("CloseTabsToTheRight")
    }
}

; a::{
;     msgbox("hei")
; }

; Method 1

; having the any(*) modifier allows the hotkey to be triggered even if modifier keys are pressed down.
; This also allwos for example Send({Left down}) to highlight text


; TODO: if a modifier key is the key which is pressed down, it is also required to be released.
; Normal keys dont have this requirement

; TODO: if a key is not simply remapped to another key, actions must be taken.
; these actions are: 
;   1. if the key is a modifier key, it must be released (can be done by creating a key down function and key up function perhaps)
;   2. if the key is a normal key, but with a modifier, it has to look like this *z:: Send("^{z}") here you can see the modifer key is outside the curly brackets

; If a key is simply remapped to another, it would look like this: *a:: Send("{Left down}"), the right side can easibly be made into a function/method call





; *a::left

; !do this for keys which turn into other keys
; *a:: Send("{blind}{Left down}")
; !note! this key (*z) turns into ^z, all modifiers have to be accounted for and put outside the curly brackets
; *z:: Send("{blind}^{z down}")
; !note! 
; *m:: Send("{blind}{Click down}")

;! do this for keys that turn into modifier keys
; LControl & RAlt:: {
;     Send("{LWin Down}")
;     keywait("RAlt")
;     keywait("LControl")
;     Send("{LWin Up}")
; }

SendKeyDown(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . " Down}")
}

SendKeyUp(key, modifiers){
    Send("{blind}{" . key . " Up}")                                                           
}

SendModifierKey(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . "}")
}

; *z:: Send("{blind}^{z down}")
; *m:: Send("{blind}{Click down}")

          

; possibleModifiers := ["^", "+", "#", "!"] ; ^ = ctrl, + = shift, # = win, ! = alt

possibleModifiers := "^+#!"

test := "^!Left"
modifiers := ""
key := ""
Loop Parse, test, ""{
    if (InStr(possibleModifiers, A_LoopField)){
        modifiers .= A_LoopField
    }
    else
        key .= A_LoopField
}


MsgBox("Key: " . key . "`nModifiers: " . modifiers)




; z = ^z

; HotKey("*a", (ThisHotkey) => SendKeyDown("Left", "")) 
; HotKey("*a Up", (ThisHotkey) => SendKeyUp("Left", ""))

; HotKey("*z", (ThisHotkey) => SendKeyDown("z", "^")) 
; HotKey("*z Up", (ThisHotkey) => SendKeyUp("z", "^"))

; HotKey("*m", (ThisHotkey) => SendKeyDown("Click", "")) 
; HotKey("*m Up", (ThisHotkey) => SendKeyUp("Click", "")) 

; HotKey("LControl & RAlt", (ThisHotkey) => SendKeyDown("LWin", "")) 
; HotKey("LControl & RAlt Up", (ThisHotkey) => SendKeyUp("LWin", "")) 
; hotkey("a", "off")
; hotkey("c", "a")



; hotkey("a Up", "off")
; hotkey("c Up", "a Up")

; SendKeyDown(key){
;     Send("{Down " key "}")
; }

; SendKeyUp(key){
;     Send("{Up " key "}")
; }





*esc::ExitApp