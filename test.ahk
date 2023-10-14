#Requires AutoHotkey v2.0

test := IniRead("Config.ini", "Hotkeys", "Altf4")
; msgbox(test)
Section := IniRead("Config.ini", "SecondLayer")
MsgBox(Section)

; This splits Section, using "`n" as a delimiter, which is new line in ahk.
; A_LoopField is the current item in the loop.
; Loop Parse, Section, "`n"{
;     splitIniLine := StrSplit(A_LoopField, "=")
;     keyValue := splitIniLine[1]
;     value := splitIniLine[2]
;     ; MsgBox(keyValue "`n" value)
; }

; MyFunc(ThisHotkey){
;     MsgBox(test "`n" "rNo")
;     Return
; }

; ReadSectionBySubstring()

esc::ExitApp