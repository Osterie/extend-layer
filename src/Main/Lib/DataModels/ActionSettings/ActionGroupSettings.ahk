#Requires AutoHotkey v2.0

class ActionGroupSettings {

    actionGroupSettings := Map()

    actionGroup := ""

    __New(actionGroup) {
        this.actionGroup := actionGroup
        this.actionGroupSettings.Default := ""
    }

    setActionSetting(actionSetting) {
        if (Type(actionSetting) != "ActionSetting") {
            throw Error("The actionSetting must be of type ActionSetting")
        }
        this.actionGroupSettings.Set(actionSetting.getActionSettingName(), actionSetting)
    }

    getActionSetting(settingName) {
        return this.actionGroupSettings.Get(settingName)
    }

    getActionSettingValue(settingName) {
        return this.actionGroupSettings.Get(settingName)
    }

    getActionSettings() {
        return this.actionGroupSettings.Values()
    }

    getActionGroupName() {
        return this.actionGroup
    }

    getAsArray() {
        arrayToReturn := Array()
        settings := this.getActionSettings()
        for actionSetting in settings {
            arrayToReturn.Push(actionSetting.getAsArray())
        }

        return arrayToReturn
    }
}
