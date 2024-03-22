#Requires AutoHotkey v2.0

class ActionSettingsRegistry{

    actionSettingsRegistry := ""

    __New(){
        this.actionSettingsRegistry := Map()
    }
    
    AddSettings(actionSettings){
        if (Type(actionSettings) != "ActionSettings"){
            throw Error("Invalid argument type. Expected ActionSetting")
        }
        else{
            this.actionSettingsRegistry.set(actionSettings.GetActionName(), actionSettings)
        }
    }

    GetActionNames(){
        return this.actionSettingsRegistry.toKeys()
    }

    GetSettingsForAction(actionName){
        settingsToReturn := ""
        if (this.actionSettingsRegistry.Has(actionName)){
            settingsToReturn := this.actionSettingsRegistry.get(actionName)
        }
        else{
            throw Error("No settings found for action: " . actionName)
        }

        return settingsToReturn
    }

    GetSettingsForActionAsArray(actionName){
        return this.GetSettingsForAction(actionName).GetAsArray()
    }

    
}