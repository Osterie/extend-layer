#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>

#Include <DataModels\ActionSettings\ActionSetting>
#Include <DataModels\ActionSettings\ActionGroupSettings>
#Include <DataModels\ActionSettings\ActionGroupSettingsRegistry>

#Include <Infrastructure\IO\IniFileReader>
#Include <Infrastructure\CurrentExtendLayerProfileManager>

class ActionSettingsRepository {

    IniFileReader := IniFileReader()
    ActionGroupSettingsRegistry := ActionGroupSettingsRegistry()

    __New(iniFile := FilePaths.GetPathToCurrentSettings()) {
        this.iniFile := iniFile
        this.readSettings()
    }

    getActionGroupSettingsRegistry() {
        return this.ActionGroupSettingsRegistry
    }

    getActionGroupNames() {
        return this.ActionGroupSettingsRegistry.getActionGroupNames()
    }

    
    ChangeActionSetting(actionName, ActionSetting) {
        filePathToSettings := FilePaths.GetPathToCurrentSettings()
        ; Changes the action setting in the ini file and updates the ActionGroupSettingsRegistry.
        this.getActionGroupSettingsRegistry().ChangeActionSetting(actionName, filePathToSettings, ActionSetting)
        ; Updates the ActionGroupsRepository to reflect the changes made in the ini file. Many ActionGroups use the Action settings from the ini file, therefore they must be updated after changign a setting.
        ActionGroupsRepository.getInstance().reset()
        ; The Extend Layer Profiles have layers, which have actions. Since each action can have settings, we need to use the update value which ActionGroupsRepository now has.
        CurrentExtendLayerProfileManager.getInstance().load()
        ; TODO call Main.setHotkeysForAllLayers(true)
    }

    ; TODO rename...
    getActionSettingsForActionAsArray(actionName) {
        return this.ActionGroupSettingsRegistry.getActionSettingsForActionAsArray(actionName)
    }

    getActionSettingsForAction(actionName) {
        return this.ActionGroupSettingsRegistry.getActionSettingsForAction(actionName)
    }

    readSettings() {

        sectionNames := this.IniFileReader.readSectionNamesToArray(this.iniFile)

        loop sectionNames.Length {
            keyPairValuesArray := this.IniFileReader.readSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile,
                sectionNames[A_Index])
            actionName := sectionNames[A_Index]
            ActionGroupSettings_ := this.readSettingsForAction(actionName)
            this.ActionGroupSettingsRegistry.addActionGroupSettings(ActionGroupSettings_)
        }
    }

    readSettingsForAction(actionName) {

        keyPairValuesArray := this.IniFileReader.readSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile,
            actionName)

        ActionGroupSettings_ := ActionGroupSettings(actionName)

        loop keyPairValuesArray.Length {
            keyPairValues := keyPairValuesArray[A_Index]

            settingName := keyPairValues[1]
            settingValue := keyPairValues[2]
            setting_ := ActionSetting(settingName, settingValue)
            ActionGroupSettings_.setActionSetting(setting_)
        }

        return ActionGroupSettings_
    }
}
