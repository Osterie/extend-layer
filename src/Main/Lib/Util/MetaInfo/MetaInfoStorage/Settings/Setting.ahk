#Requires AutoHotkey v2.0

class Setting{
    
    settingName := ""
    settingValue := ""

    __New(settingName, settingValue){
        this.SetSettingName(settingName)
        this.SetSettingValue(settingValue)
    }

    getSettingName(){
        return this.settingName
    }

    getSettingValue(){
        return this.settingValue
    }

    setSettingName(settingName){
        this.settingName := settingName
    }

    setSettingValue(settingValue){
        ; try{
        ;     this.validValue(settingValue)
            this.settingValue := settingValue
        ; }
        ; catch Error as e{
        ;     throw Error("Invalid setting value: " . e.Message)
        ; }
    }

    GetAsArray(){
        return [this.settingName, this.settingValue]
    }

    ; validValue(settingValue){
    ;     if (this.settingType = "int" && !IsInteger(settingValue)){
    ;         throw Error("Setting value must be an integer")
    ;     }
    ;     else if (this.settingType = "integer" && !IsInteger(settingValue)){
    ;         throw Error("Setting value must be an integer")
    ;     }
    ;     else if (this.settingType = "float" && !IsFloat(settingValue)){
    ;         throw Error("Setting value must be a float")
    ;     }
    ;     else if (this.settingType = "bool" && !this.IsBoolean(settingValue)){
    ;         throw Error("Setting value must be a boolean")
    ;     }
    ;     return true
    ; }

    ; IsBoolean(valueToCheck){
    ;     isBoolean_ := false
    ;     if (valueToCheck = "true" || valueToCheck = "false"){
    ;         isBoolean_ := true
    ;     }
    ;     else if (valueToCheck = 0 || valueToCheck = 1){
    ;         isBoolean_ := true
    ;     }

    ;     return isBoolean_
    ; }

    toString(){
        return this.settingName . " = " . this.settingValue
    }
}