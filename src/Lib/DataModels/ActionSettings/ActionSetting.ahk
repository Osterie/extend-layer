#Requires AutoHotkey v2.0

class ActionSetting {

    actionSettingName := ""
    actionSettingValue := ""

    __New(actionSettingName, actionSettingValue) {
        this.setActionSettingName(actionSettingName)
        this.setActionSettingValue(actionSettingValue)
    }

    getActionSettingName() {
        return this.actionSettingName
    }

    getActionSettingValue() {
        return this.actionSettingValue
    }

    setActionSettingName(actionSettingName) {
        this.actionSettingName := actionSettingName
    }

    setActionSettingValue(actionSettingValue) {
        ; try{
        ;     this.validValue(actionSettingValue)
        this.actionSettingValue := actionSettingValue
        ; }
        ; catch Error as e{
        ;     throw Error("Invalid setting value: " . e.Message)
        ; }
    }

    getAsArray() {
        return [this.actionSettingName, this.actionSettingValue]
    }

    ; validValue(actionSettingValue){
    ;     if (this.settingType = "int" && !IsInteger(actionSettingValue)){
    ;         throw Error("ActionSetting value must be an integer")
    ;     }
    ;     else if (this.settingType = "integer" && !IsInteger(actionSettingValue)){
    ;         throw Error("ActionSetting value must be an integer")
    ;     }
    ;     else if (this.settingType = "float" && !IsFloat(actionSettingValue)){
    ;         throw Error("ActionSetting value must be a float")
    ;     }
    ;     else if (this.settingType = "bool" && !this.IsBoolean(actionSettingValue)){
    ;         throw Error("ActionSetting value must be a boolean")
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

    toString() {
        return this.actionSettingName . " = " . this.actionSettingValue
    }
}
