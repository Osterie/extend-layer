#Requires AutoHotkey v2.0

Hotkey("^j", "MyHotkeyFunction")

; Function to handle the hotkey
MyHotkeyFunction() {
    MsgBox("Ctrl+J was pressed!")
}

; test := IniRead("Config.ini", "FirstKeyboardOverlayWebsites", "Up")
; Section := IniRead("Config.ini", "Hotkeys")
; MsgBox(section)
; HotKey test, MyFunc

; MyFunc(ThisHotkey){
;     MsgBox(test "`n" "rNo")
;     Return
; }

esc::ExitApp