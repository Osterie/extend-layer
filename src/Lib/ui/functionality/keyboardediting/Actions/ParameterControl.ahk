#Requires AutoHotkey v2.0

class ParameterControl {

    parameterNameControl := ""
    parameterInputFieldControl := ""
    parameterDescriptionControl := ""
    parameterType := ""
    valuesSet := ""
    guiToAddTo := ""

    __New(guiToAddTo, parameterInfo?, position?) {
        this.guiToAddTo := guiToAddTo
        this.valuesSet := false
        this.CreateControls(parameterInfo?, position?)
    }

    CreateControls(parameterInfo?, position?) {
        if (IsSet(parameterInfo) && Type(parameterInfo) = "ActionParameter") {
            this.valuesSet := true
            this.parameterNameControl := this.CreateParameterNameControl(parameterInfo.getName(), position?)
            this.parameterInputFieldControl := this.CreateParameterInputFieldControl(parameterInfo.getType(),)
            this.parameterDescriptionControl := this.CreateParameterDescriptionControl(parameterInfo.getDescription(),
            )
        }
        else {
            this.parameterNameControl := this.CreateParameterNameControl(position?)
            this.parameterInputFieldControl := this.CreateParameterInputFieldControl()
            this.parameterDescriptionControl := this.CreateParameterDescriptionControl()
        }
    }

    CreateParameterNameControl(position?, parameterName := "") {
        if (IsSet(position)) {
            parameterNameControl := this.guiToAddTo.Add("Text", position, parameterName)
        }
        else {
            parameterNameControl := this.guiToAddTo.Add("Text", "xp yp+30 w335", parameterName)
        }

        parameterNameControl.SetFont("Bold")
        return parameterNameControl
    }

    CreateParameterInputFieldControl(parameterType := "") {
        parameterInputFieldControl := this.guiToAddTo.Add("Edit", "xp yp+30 w335", "")

        if (StrLower(parameterType) = "int" or StrLower(parameterType) = "integer") {
            parameterInputFieldControl.Opt("+Number")
        }
        else if (StrLower(parameterType) = "str" or StrLower(parameterType) = "string") {
            parameterInputFieldControl.Opt("-Number")
        }
        return parameterInputFieldControl
    }

    CreateParameterDescriptionControl(parameterDescription := "") {
        parameterDescriptionControl := this.guiToAddTo.Add("Text", "xp yp+30 w335", parameterDescription)
        return parameterDescriptionControl
    }

    SetInfo(parameterInfo) {
        if (Type(parameterInfo) != "ActionParameter") {
            throw Error("Invalid parameterInfo")
        }
        this.valuesSet := true
        this.SetParameterName(parameterInfo.getName())
        this.SetParameterType(parameterInfo.getType())
        this.SetParameterDescription(parameterInfo.getDescription())
    }

    SetParameterName(parameterName) {
        this.parameterNameControl.Value := parameterName
    }

    SetParameterType(parameterType) {
        this.parameterType := parameterType
        if (StrLower(parameterType) = "int" or StrLower(parameterType) = "integer") {
            this.parameterInputFieldControl.Opt("+Number")
        }
        else if (StrLower(parameterType) = "str" or StrLower(parameterType) = "string") {
            this.parameterInputFieldControl.Opt("-Number")
        }
    }

    SetParameterDescription(parameterDescription) {
        this.parameterDescriptionControl.Value := parameterDescription
    }

    GetValue() {
        return this.parameterInputFieldControl.Value
    }

    GetPos() {
        this.parameterNameControl.GetPos(&X1, &Y1, &w, &h)
        xPosition := X1
        yPosition := Y1

        this.parameterDescriptionControl.GetPos(&X2, &Y2, &Width, &Height)
        ySecondPosition := Y2
        Height := ySecondPosition - yPosition

        objectToReturn := {}
        objectToReturn.x := xPosition
        objectToReturn.y := yPosition
        objectToReturn.width := w
        objectToReturn.height := Height

        return objectToReturn
    }

    IsSet() {
        return this.valuesSet
    }

    Clear() {
        this.valuesSet := false
        this.parameterNameControl.Value := ""
        this.parameterInputFieldControl.Value := ""
        this.parameterDescriptionControl.Value := ""
    }

    Hide() {
        this.parameterNameControl.Opt("Hidden1")
        this.parameterInputFieldControl.Opt("Hidden1")
        this.parameterDescriptionControl.Opt("Hidden1")
    }

    Show() {
        this.parameterNameControl.Opt("Hidden0")
        this.parameterInputFieldControl.Opt("Hidden0")
        this.parameterDescriptionControl.Opt("Hidden0")
    }
}
