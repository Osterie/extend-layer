#Requires AutoHotkey v2.0

class ParameterControlsGroup2{

    parameterControls := ""


    __New(){
        this.parameterControls := Array()
    }

    AddParameterControl(parameterControl){
        if (Type(parameterControl) != "ParameterControl"){
            throw Error("Invalid parameterControl")
        }

        this.parameterControls.Push(parameterControl)
    }

    SetInfo(parameters){
        if (Type(parameters) = "Map"){
            parametersArray := Array()
            for parameterName, parameterInfo in parameters{
                parametersArray.Push(parameterInfo)
            }
            this.SetInfoWithArray(parametersArray)
        }
        else if (Type(parameters = "Array")){
            this.SetInfoWithArray(parameters)
        }
        else{
            throw Error("Invalid parameters, must be given as array or map")
        }
    }

    ; private method
    SetInfoWithArray(parameters){
        Loop parameters.Length{
            this.parameterControls[A_index].SetInfo(parameters[A_index])
        }
    }

    GetParameterControls(){
        return this.parameterControls
    }

    Clear(){
        Loop this.parameterControls.Length{
            this.parameterControls[A_index].clear()
        }
    }

    Hide(){
        Loop this.parameterControls.Length{
            this.parameterControls[A_index].hide()
        }
    }

    Show(){
        Loop this.parameterControls.Length{
            if (this.parameterControls[A_index].isSet()){
                this.parameterControls[A_index].Show()
            }
        }
    }

    GetParameterValues(){
        parameterValues := Array()
        Loop this.parameterControls.Length{
            parameterControl := this.parameterControls[A_index]
            if (parameterControl.IsSet()){
                parameterValues.Push(parameterControl.GetValue())
            }
        }
        return parameterValues
    }
}