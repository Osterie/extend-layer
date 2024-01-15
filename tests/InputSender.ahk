#Requires AutoHotkey v2.0

class InputSender{


    inputs := []
    times := []

    __New(){

    }

    SetInputsAndTimes(inputs, times){
        this.inputs := inputs
        this.times := times
    }

    SendAllInputsForGivenTimes(){
        Loop this.inputs.Length{
            this.SendInputForGivenTime(this.inputs[A_Index], this.times[A_Index])
        }
    }

    SendInputForGivenTime(input, time){
        for action in input{
            Send("{" . action . " Down}")
        }
        
        Sleep(time)

        for action in input{
            Send("{" . action . " Up}")
        }
    }

}