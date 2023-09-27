#Requires Autohotkey v2.0
#Include "%A_ScriptDir%\library\ClockDisplay_newV2.ahk"
; #Include ".\library\CountdownGUI_newV2.ahk"


Class CountdownGUI{

    countdownStopped := false
    screenSleepCountdown := ""
    GUICountdown := 0

    __New(minutes, seconds){
        this.screenSleepCountdown := ClockDisplay(minutes, seconds)
    }
    
    createGui(){
        
        this.GUICountdown := Gui()
        this.GUICountdown.Opt("+AlwaysOnTop -Caption +ToolWindow")
        this.GUICountdown.BackColor := "black"
        this.GUICountdown.SetFont("cDA4F49")
        this.GUICountdown.Add("Text", "w200 Center vCountdown", this.screenSleepCountdown.getTimeAsString())
    }
    
    destroyGui(){
        this.GUICountdown.Destroy()
    }

    showGui(){
        this.GUICountdown.Show()
    }

    hideGui(){
        this.GUICountdown.hide()
    }

    startCountdown(){
        Loop{
            if (A_TimeIdle + 1000 < 2000){
                this.screenSleepCountdown.setTime(1,0)
            }
            this.screenSleepCountdown.decrementTime()
            ; ogcTextCountdown.Value := this.screenSleepCountdown.getTimeAsString()
            this.GUICountdown['Countdown'].Text := this.screenSleepCountdown.getTimeAsString()

            Sleep(920)

        } until this.screenSleepCountdown.isMidnight() || this.countdownStopped
        return
    }
    stopCountdown(){
        this.countdownStopped := true
    }
    setCountdown(minutes, seconds){
        this.screenSleepCountdown.setTime(minutes, seconds)
    }
}