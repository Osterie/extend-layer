#Requires Autohotkey v2.0
#Include "%A_ScriptDir%\library\ClockDisplay.ahk"
; #Include ".\library\CountdownGUI.ahk"


Class CountdownGUI{

    countdownStopped := false
    screenSleepCountdown := ""
    GUICountdown := ""
    minutes := 0
    seconds := 0

    __New(minutes, seconds){
        this.screenSleepCountdown := ClockDisplay(minutes, seconds)
        this.minutes := minutes
        this.seconds := seconds
    }
    
    CreateGui(){
        this.GUICountdown := Gui()
        this.GUICountdown.Opt("+AlwaysOnTop -Caption +ToolWindow")
        this.GUICountdown.BackColor := "black"
        this.GUICountdown.SetFont("cDA4F49")
        this.GUICountdown.Add("Text", "w200 Center vCountdown", this.screenSleepCountdown.getTimeAsString())
    }
    
    DestroyGui(){
        this.GUICountdown.Destroy()
    }

    ShowGui(){
        this.GUICountdown.Show()
    }

    HideGui(){
        this.GUICountdown.Hide()
    }

    StartCountdown(){
        this.idle := false
        this.countdownStopped := false
        this.screenSleepCountdown.SetTime(this.minutes,this.seconds)

        Loop{

            this.GUICountdown['Countdown'].Text := this.screenSleepCountdown.GetTimeAsString()
            Sleep(920)

            if (A_TimeIdle < 920 && this.idle){
                this.idle := false
                this.screenSleepCountdown.SetTime(this.minutes,this.seconds)
            }
            else{
                this.screenSleepCountdown.DecrementTime()
            }
           
            this.idle := true

        } until this.screenSleepCountdown.IsMidnight() || this.countdownStopped
        return
    }
    stopCountdown(){
        this.countdownStopped := true
    }
    setCountdown(minutes, seconds){
        this.minutes := minutes
        this.seconds := seconds
        this.screenSleepCountdown.SetTime(minutes, seconds)
    }
}