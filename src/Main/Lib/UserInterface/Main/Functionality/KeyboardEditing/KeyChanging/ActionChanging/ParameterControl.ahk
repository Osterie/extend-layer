#Requires AutoHotkey v2.0

class ParameterControl{

    parameterNameControl := ""
    parameterInputFieldControl := ""
    parameterDescriptionControl := ""
    parameterType := ""
    valuesSet := ""
    guiToAddTo := ""

    __New(guiToAddTo, parameterInfo?){
        this.guiToAddTo := guiToAddTo
        this.valuesSet := false
        this.CreateControls(parameterInfo?)
    }

    CreateControls(parameterInfo?){
        if (IsSet(parameterInfo)){
            this.valuesSet := true
            this.parameterNameControl := this.CreateParameterNameControl(parameterInfo.getName())
            this.parameterInputFieldControl := this.CreateParameterInputFieldControl(parameterInfo.getType())
            this.parameterDescriptionControl := this.CreateParameterDescriptionControl(parameterInfo.getDescription())
        }
        else{
            this.parameterNameControl := this.CreateParameterNameControl()
            this.parameterInputFieldControl := this.CreateParameterInputFieldControl()
            this.parameterDescriptionControl := this.CreateParameterDescriptionControl()
        }
    }

    CreateParameterNameControl(parameterName := ""){
        parameterNameControl := this.guiToAddTo.Add("Text", "xs+10 yp+30 w335", parameterName)
        parameterNameControl.SetFont("Bold")
        return parameterNameControl
    }

    CreateParameterInputFieldControl(parameterType := ""){
        parameterInputFieldControl := this.guiToAddTo.Add("Edit", "xs+10 yp+30 w335", "")
        if(StrLower(parameterType) = "int" or StrLower(parameterType) = "integer"){
            parameterInputFieldControl.Opt("+Number")
        }
        else if(StrLower(parameterType) = "str" or StrLower(parameterType) = "string"){
            parameterInputFieldControl.Opt("-Number")
        }
        return parameterInputFieldControl
    }

    CreateParameterDescriptionControl(parameterDescription := ""){
        parameterDescriptionControl := this.guiToAddTo.Add("Text", "xs+10 yp+30 w335", parameterDescription)
        return parameterDescriptionControl
    }

    SetInfo(parameterInfo){
        if (Type(parameterInfo) = "ParameterInfo"){
            this.valuesSet := true
            this.SetParameterName(parameterInfo.getName())
            this.SetParameterType(parameterInfo.getType())
            this.SetParameterDescription(parameterInfo.getDescription())
        }
        else{
            throw Error("Invalid parameterInfo")
        }
    }

    SetParameterName(parameterName){
        this.parameterNameControl.Value := parameterName
    }

    SetParameterType(parameterType){
        this.parameterType := parameterType
        if(StrLower(parameterType) = "int" or StrLower(parameterType) = "integer"){
            this.parameterInputFieldControl.Opt("+Number")
        }
        else if(StrLower(parameterType) = "str" or StrLower(parameterType) = "string"){
            this.parameterInputFieldControl.Opt("-Number")
        }
    }


    SetParameterDescription(parameterDescription){
        this.parameterDescriptionControl.Value := parameterDescription
    }

    GetValue(){
        return this.parameterInputFieldControl.Value
    }

    IsSet(){
        return this.valuesSet
    }

    Clear(){
        this.valuesSet := false
        this.parameterNameControl.Value := ""
        this.parameterInputFieldControl.Value := ""
        this.parameterDescriptionControl.Value := ""
    }

    Hide(){
        this.parameterNameControl.Opt("Hidden1")
        this.parameterInputFieldControl.Opt("Hidden1")
        this.parameterDescriptionControl.Opt("Hidden1")
    }

    Show(){
        this.parameterNameControl.Opt("Hidden0")
        this.parameterInputFieldControl.Opt("Hidden0")
        this.parameterDescriptionControl.Opt("Hidden0")
    }
}