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


Class Test {
    __New() {
        this.x := 0
    }

    toString(){
        return "Hello"
    }
}

Class TestSecond{
    __New() {
        this.x := 1
    }

    toString(){
        return "Hello2"
    }
}

Class NotATest{
    __New() {
        this.x := 2
    }

    toString(){
        return "Goodbye"
    }

}

Values := [Test(), TestSecond(), NotATest()]
Loop Values.Length
    msgbox(Values[A_index].toString())