#Requires Autohotkey v2.0
#Include "%A_ScriptDir%\library\NumberDisplay_newV2.ahk"

Class ClockDisplay{

    minutes := ""
    seconds := ""

    __New(initialMinutes, initialSeconds)
    {
        this.minutes := NumberDisplay(60)
        this.seconds := NumberDisplay(60)

        this.minutes.SetValue(initialMinutes)
        this.seconds.SetValue(initialSeconds)
    }   

    GetTimeAsString(){
        timeAsString := this.minutes.GetDisplayValue() . ":" . this.seconds.GetDisplayValue()
        return timeAsString
    }

    IncrementTime(){
        this.seconds.IncrementValue()
        if (this.seconds.GetValue() == 0)
        {
            this.minutes.IncrementValue()
        }
    }

    DecrementTime(){
        this.seconds.DecrementValue()
        if (this.seconds.GetValue() == 59){
            this.minutes.DecrementValue()
        }
    }

    SetTime(minutes, seconds){
        this.minutes.SetValue(minutes)
        this.seconds.SetValue(seconds)
    }

    IsMidnight(){
        midnight := false
        if (this.seconds.GetValue() == 0 && this.minutes.GetValue() == 0){
            midnight := true
        }
        return midnight
    }
}
