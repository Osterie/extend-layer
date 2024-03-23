#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\Settings\Setting>
#Include <Util\MetaInfo\MetaInfoStorage\Settings\ActionSettings>
#Include <Util\MetaInfo\MetaInfoStorage\Settings\ActionSettingsRegistry>



class ActionSettingsReader{

    __New(iniFile){
        this.iniFile := iniFile
    }

    ReadSettings(){
        iniFileRead := IniFileReader()
        sectionNames := iniFileRead.ReadSectionNamesToArray(this.iniFile)

        ActionSettingsRegistry_ := ActionSettingsRegistry()
    
        Loop sectionNames.Length{
            keyPairValuesArray := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile, sectionNames[A_Index])
            actionName := sectionNames[A_Index]
            actionSettings_ := this.ReadSettingsForAction(actionName)
            ActionSettingsRegistry_.AddSettings(actionSettings_)
        }

        return ActionSettingsRegistry_
    }

    ReadSettingsForAction(actionName){
        iniFileRead := IniFileReader()
        keyPairValuesArray := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(this.iniFile, actionName)

        actionSettings_ := ActionSettings(actionName)
        
        Loop keyPairValuesArray.Length{
            keyPairValues := keyPairValuesArray[A_Index]

            settingName := keyPairValues[1]
            settingValue := keyPairValues[2]
            setting_ := Setting(settingName, settingValue)
            actionSettings_.SetSetting(setting_)
        }

        return actionSettings_
    }
}