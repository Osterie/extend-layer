#Requires Autohotkey v2.0
#Include "%A_ScriptDir%\library\NumberDisplay_newV2.ahk"

Class ClockDisplay{

    minutes := ""
    seconds := ""

    __New(initialMinutes, initialSeconds)
    {
        this.minutes := NumberDisplay(60)
        this.seconds := NumberDisplay(60)

        this.minutes.setValue(initialMinutes)
        this.seconds.setValue(initialSeconds)
    }   

    getTimeAsString(){
        timeAsString := this.minutes.getDisplayValue() . ":" . this.seconds.getDisplayValue()
        return timeAsString
    }

    incrementTime(){
        this.seconds.incrementValue()
        if (this.seconds.getValue() == 0)
        {
            this.minutes.incrementValue()
        }
    }

    decrementTime(){
        this.seconds.decrementValue()
        if (this.seconds.getValue() == 0){
            this.minutes.decrementValue()
        }
    }

    setTime(minutes, seconds){
        this.minutes.setValue(minutes)
        this.seconds.setValue(seconds)
    }

    isMidnight(){
        midnight := false
        if (this.seconds.getValue() == 0 && this.minutes.getValue() == 0){
            midnight := true
        }
        return midnight
    }
}
