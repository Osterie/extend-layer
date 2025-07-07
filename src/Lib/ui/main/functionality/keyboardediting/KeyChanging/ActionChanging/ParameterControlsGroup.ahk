#Requires AutoHotkey v2.0

#Include ".\ParameterControl.ahk"


class ParameterControlsGroup{

    parameterControls := ""

    guiToAddTo := ""
    startingPosition := ""

    __New(guiToAddTo, startingPosition := ""){
        this.guiToAddTo := guiToAddTo
        this.parameterControls := Array()
        this.startingPosition := startingPosition
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
        
        this.Clear()
        
        Loop parameters.Length{
            if (A_index > this.parameterControls.Length){
                if (A_index > 1){
                    positions := this.parameterControls[A_index-1].GetPos()

                    X := positions.x
                    Y := positions.y
                    Width := positions.width
                    Height := positions.height
                    
                    xPosition := " X" . X . " "
                    yPosition := " Y" . Y+Height+30 . " "
                    width := " W" . Width . " "

                    position := xPosition . yPosition . width
                    control := ParameterControl(this.guiToAddTo, "", position)
                }
                else{
                    control := ParameterControl(this.guiToAddTo, "", this.startingPosition)
                }
                this.AddParameterControl(control)
            }
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