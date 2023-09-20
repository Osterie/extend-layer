#Requires AutoHotkey v1.1.36.02
#Include library.ahk

#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
DllCall("ntdll\ZwSetTimerResolution","Int",5000,"Int",1,"Int*",MyCurrentTimerResolution) ;setting the Windows Timer Resolution to 0.5ms, THIS IS A GLOBAL CHANGE


Class CountdownGUI{


    __new(){
        screenSleepCountdown := new ClockDisplay(1,0)
        storedSecond := A_Sec
    }
    
}


Gui, GUICountdown: new
Gui, GUICountdown: +AlwaysOnTop -Caption +ToolWindow
Gui, GUICountdown: Color, white
Gui, GUICountdown: Font, cDA4F49
Gui, GUICountdown: Add, Text, w200 Center vCountdown, % screenSleepCountdown.getTimeAsString()
GuiControl, GUICountdown:, Countdown, % screenSleepCountdown.getTimeAsString()
Gui, GUICountdown: show
countdownCanceled := false

loop {
    if (storedSecond != A_Sec){
        screenSleepCountdown.decrementTime()
        GuiControl, GUICountdown:, Countdown, % screenSleepCountdown.getTimeAsString()
        if (A_TimeIdle + 1000 < 2000){
            screenSleepCountdown.setTime(1,0)
        }
        storedSecond := A_Sec
    }
} until screenSleepCountdown.isMidnight() || countdownCanceled
return

esc:: exitapp
