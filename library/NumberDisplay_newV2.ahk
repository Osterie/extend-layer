#Requires Autohotkey v2.0


Class NumberDisplay{
    value := 0
    upperLimit := 0

    __New(upperLimit){
        if (upperLimit >= 0)
        {
            this.upperLimit := upperLimit
        }
    }    

    incrementValue(){
        this.value := mod( (this.value + 1) , this.upperLimit)
    }
    DecrementValue(){
        this.value := this.value - 1
        if (this.value < 0){
            this.value := this.upperLimit-1
        }
    }

    SetValue(value){
        if ( (value < 0) || (value >= this.upperLimit) )
        {
            return
        }
        this.value := value
    }
    GetValue()
    {
        return this.value
    }

    GetDisplayValue()
    {
        valueToDisplay := ""
        if (this.value < 10)
        {
            valueToDisplay := "0" . this.value
        }
        else 
        {
            valueToDisplay := "" . this.value
        }
        return valueToDisplay
    }
}