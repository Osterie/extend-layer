#Requires AutoHotkey v2.0

class ActionGroupSettingsRegistry {

    actionGroupSettingsRegistry := Map()

    __New() {

    }

    addActionGroupSettings(actionGroupSettings) {
        if (Type(actionGroupSettings) != "ActionGroupSettings") {
            throw Error("Invalid argument type. Expected ActionSetting")
        }
        else {
            this.actionGroupSettingsRegistry.set(actionGroupSettings.getActionGroupName(), actionGroupSettings)
        }
    }

    ChangeActionSetting(actionName, filePathToSettings, ActionSetting) {
        if (Type(ActionSetting) != "ActionSetting") {
            throw Error("Invalid argument type. Expected ActionSetting")
        }
        if (!FileExist(filePathToSettings)) {
            throw ValueError("File does not exist: " . filePathToSettings)
        }

        settingName := ActionSetting.getActionSettingName()
        settingValue := ActionSetting.getActionSettingValue()

        try {
            IniWrite(settingValue, filePathToSettings, actionName, settingName)
            actionGroupSettings := this.actionGroupSettingsRegistry.Get(actionName)
            actionGroupSettings.setActionSetting(ActionSetting)
            this.actionGroupSettingsRegistry.set(actionName, actionGroupSettings)

        }
        catch {
            MsgBox("Failed to save settings")
        }

        ; this.actionGroupSettingsRegistry.set(actionGroupSettings.getActionGroupName(), actionGroupSettings)

    }

    getActionGroupNames() {
        return this.actionGroupSettingsRegistry.Keys()
    }

    getActionSettingsForAction(actionName) {
        settingsToReturn := ""
        if (this.actionGroupSettingsRegistry.Has(actionName)) {
            settingsToReturn := this.actionGroupSettingsRegistry.get(actionName)
        }
        else {
            throw Error("No settings found for action: " . actionName)
        }

        return settingsToReturn
    }

    getActionSettingsForActionAsArray(actionName) {
        return this.getActionSettingsForAction(actionName).getAsArray()
    }

}
