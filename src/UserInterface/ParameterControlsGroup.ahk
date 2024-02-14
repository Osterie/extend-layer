#Requires AutoHotkey v2.0

class ParameterControlsGroup{

    parameterTextControl := ""

    parameterEditControl := ""

    parameterDescriptionControl := ""

    __New(parameterTextControl, paramaterEditControl, parameterDescriptionControl){
        this.parameterTextControl := parameterTextControl
        this.parameterEditControl := paramaterEditControl
        this.parameterDescriptionControl := parameterDescriptionControl
    }

    getTextControl(){
        return this.parameterTextControl
    }

    getEditControl(){
        return this.parameterEditControl
    }

    getEditControlValue(){
        return this.parameterEditControl.Value
    }

    getDescriptionControl(){
        return this.parameterDescriptionControl
    }

    setTextControlValue(newParameterText){
        this.parameterTextControl.Value := newParameterText
    }

    setEditControlType(editType){
        if(editType = "int"){
            this.parameterEditControl.Opt("+Number")
        }
        else if(editType = "string"){
            this.parameterEditControl.Opt("-Number")
        }
    }

    setDescriptionControlValue(newParameterDescription){
        this.parameterDescriptionControl.Value := newParameterDescription
    }

    showControls(){
        this.parameterTextControl.Opt("Hidden0")
        this.parameterEditControl.Opt("Hidden0")
        this.parameterDescriptionControl.Opt("Hidden0")
    }

    hideControls(){
        this.parameterTextControl.Opt("Hidden1")
        this.parameterEditControl.Opt("Hidden1")
        this.parameterDescriptionControl.Opt("Hidden1")
    }
}