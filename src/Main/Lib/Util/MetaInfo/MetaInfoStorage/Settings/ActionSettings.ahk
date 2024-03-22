#Requires AutoHotkey v2.0

class ActionSettings {

    settingsForAction := ""

    actionName := ""

    __New(actionName){
        this.actionName := actionName
        this.settingsForAction := Map()
        this.settingsForAction.Default := ""
    }

    AddSetting(setting){
        if (Type(setting) != "Setting"){
            throw Error("The setting must be of type Setting")
        }
        this.settingsForAction.Set(setting.getSettingName(), setting)
    }

    GetSetting(settingName){
        return this.settingsForAction.Get(settingName)
    }

    GetSettingValue(settingName){
        return this.settingsForAction.Get(settingName)
    }

    GetSettings(){
        return this.settingsForAction.toValues()
    }

    GetActionName(){
        return this.actionName
    }

    GetAsArray(){
        arrayToReturn := Array()
        settings := this.GetSettings()
        For setting in settings {
            arrayToReturn.Push(setting.GetAsArray())
        }

        return arrayToReturn
    }
}