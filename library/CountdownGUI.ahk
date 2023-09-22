#Requires AutoHotkey v1.1.36.02
#Include %A_ScriptDir%\library\ClockDisplay.ahk

Class CountdownGUI{

    countdownStopped := false
    screenSleepCountdown := ""
    storedSecond := A_Sec

    __New(minutes, seconds){
        this.screenSleepCountdown := new ClockDisplay(minutes, seconds)
        this.storedSecond := A_Sec
    }
    
    createGui(){
        global
        Gui, GUICountdown: new
        Gui, GUICountdown: +AlwaysOnTop -Caption +ToolWindow
        Gui, GUICountdown: Color, black
        Gui, GUICountdown: Font, cDA4F49
        Gui, GUICountdown: Add, Text, w200 Center vCountdown, % this.screenSleepCountdown.getTimeAsString()
    }
    
    destroyGui(){
        Gui, GUICountdown: Destroy
    }

    showGui(){
        Gui, GUICountdown: Show
    }

    hideGui(){
        Gui, GUICountdown: hide
    }

    startCountdown(){
        loop {
            this.screenSleepCountdown.decrementTime()
            GuiControl, GUICountdown:, Countdown, % this.screenSleepCountdown.getTimeAsString()
            if (A_TimeIdle + 1000 < 2000){
                this.screenSleepCountdown.setTime(1,0)
            }
            Sleep, 920

        } until this.screenSleepCountdown.isMidnight() || this.countdownStopped
        return
    }
    stopCountdown(){
        this.countdownStopped := true
    }
    resetCountdown(){
        
    }
}