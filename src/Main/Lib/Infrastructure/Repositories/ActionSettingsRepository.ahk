#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>

#Include <DataModels\ActionSettings\ActionSetting>
#Include <DataModels\ActionSettings\ActionGroupSettings>
#Include <DataModels\ActionSettings\ActionGroupSettingsRegistry>

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\IniFileReader>

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

    readSettings() {

        sectionNames := this.IniFileReader.ReadSectionNamesToArray(this.iniFile)

        loop sectionNames.Length {
            keyPairValuesArray := this.IniFileReader.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile,
                sectionNames[A_Index])
            actionName := sectionNames[A_Index]
            ActionGroupSettings_ := this.readSettingsForAction(actionName)
            this.ActionGroupSettingsRegistry.addActionGroupSettings(ActionGroupSettings_)
        }
    }

    readSettingsForAction(actionName) {

        keyPairValuesArray := this.IniFileReader.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile,
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
