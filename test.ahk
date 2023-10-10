#Requires AutoHotkey v2.0

test := IniRead("Config.ini", "testing", "Up")
HotKey test, MyFunc

MyFunc(ThisHotkey){
    MsgBox(test "`n" "rNo")
    Return
}

esc::ExitApp