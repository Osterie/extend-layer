#Requires AutoHotkey v2.0

class InputSender{


    inputs := []
    times := []

    __New(){

    }

    SetInputsAndTimes(inputs, times){

    }

    SendAllInputsForGivenTimes(){
        Loop inputs.Length{
            SendInputForGivenTime(inputs[A_Index], times[A_Index])
        }
    }

    SendInputForGivenTime(input, time){
        Send("{Click 900 900 down}")
        Sleep(900)
        Send("{Click 900 900 up}")
    }

}