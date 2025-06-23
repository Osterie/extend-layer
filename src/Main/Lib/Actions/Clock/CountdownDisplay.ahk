#Requires Autohotkey v2.0
#Include ".\ClockDisplay.ahk"

; TODO: could create a clock gui class, which can create a gui for countdown or clock

#Include <Actions\HotkeyAction>


Class CountdownDisplay extends HotkeyAction{

    countdownStopped := false
    CountDown := ""
    GUICountdown := ""
    minutes := 0
    seconds := 0

    __New(minutes, seconds){
        this.CountDown := ClockDisplay(minutes, seconds)
        this.minutes := minutes
        this.seconds := seconds
    }
    
    CreateGui(){
        this.GUICountdown := Gui()
        this.GUICountdown.Opt("+AlwaysOnTop -Caption +ToolWindow")
        this.GUICountdown.BackColor := "black"
        this.GUICountdown.SetFont("cDA4F49")
        this.GUICountdown.Add("Text", "w200 Center vCountdown", this.CountDown.getTimeAsString())
    }
    
    destroy(){
        try{
            this.GUICountdown.destroy()
        }
    }

    Show(){
        this.GUICountdown.Show()
    }

    Hide(){
        this.GUICountdown.Hide()
    }

    StartCountdown(){
        this.idle := false
        this.countdownStopped := false
        this.CountDown.SetTime(this.minutes, this.seconds)

        Loop{

            this.GUICountdown['Countdown'].Text := this.CountDown.GetTimeAsString()
            Sleep(920)

            if (A_TimeIdle < 920 && this.idle){
                this.idle := false
                this.CountDown.SetTime(this.minutes,this.seconds)
            }
            else{
                this.CountDown.DecrementTime()
            }
           
            this.idle := true

        } until this.CountDown.IsMidnight() || this.countdownStopped
        return
    }

    stopCountdown(){
        this.countdownStopped := true
    }

    setCountdown(minutes, seconds){
        this.minutes := minutes
        this.seconds := seconds
        this.CountDown.SetTime(minutes, seconds)
    }
}