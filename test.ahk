#Requires AutoHotkey v2.0

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

test1 := Tester()
test2 := Tester()
test2.setName("Adrian")


test1.printName()


; a::
; <^>!::
; SC138::
; VKA5::
; Ralt::{
;     MsgBox("you pressed" . A_ThisHotKey)
;     return
; }


; ProfileInfo := {CloseTabsToTheRight: test1, CloseTabsToTheRight: test2}
; ProfileInfo.CloseTabsToTheRight.printName()

; Class Placeholder{

;     getClassMethods(){
;         return this.Map
;     }

;     getMethodClass(methodName){
;         return this.Map[methodName]
;     }
; }

; Decision := map(test1, ["CloseTabsToTheRight"], test2, ["CloseTabsToTheRight"] )
; ; msgbox(Decision[test1])

; ; MyMap := Map("ten", 10, "twenty", 20, "thirty", 30)
; For key, value in Decision
;     MsgBox key.getName() . ' = ' value[1]

; Decision.test1.printName()
; MyMap := Map("KeyA", ValueA, "KeyB", ValueB, "KeyZ", ValueZ)
; Value := MyMap[Key]
; MyMap[Key] := Value


; test := IniRead("Config.ini", "Hotkeys", "Altf4")
; msgbox(test)
; Section := IniRead("Config.ini", "SecondLayer")
; MsgBox(Section)

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