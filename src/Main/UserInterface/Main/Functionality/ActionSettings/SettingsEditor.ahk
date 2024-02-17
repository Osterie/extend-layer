#Requires AutoHotkey v2.0

class SettingsEditor{
    
    CreateControls(settingName, settingValue){

        ; TODO should be set to on top, can not be not top ever...
        
        SettingsGui := Gui("+Resize +MinSize300x560 +AlwaysOnTop")
        
        SettingsGui.Add("Text", "w300 h20", "Value From Key:")
        inputKey := SettingsGui.Add("Edit", "xm w300 h20", settingName)
        
        SettingsGui.Add("Text", "xm w300 h20", "Value New Key Action:")
        inputValue := SettingsGui.Add("Edit", "xm w300 h20", settingValue)
        
        SaveButton := SettingsGui.Add("Button", "w100 h20", "Save")
        CancelButton := SettingsGui.Add("Button", "w100 h20", "Cancel")
        DeleteButton := SettingsGui.Add("Button", "w100 h20", "Delete")

        SettingsGui.Show()

        ; SaveButton.onEvent("Click", (*) => this.SaveButtonClickEvent(SettingsGui, rowNumber, inputKey, iniFileSection, inputValue))

        ; CancelButton.onEvent("Click", (*) =>SettingsGui.Destroy())
        
        ; DeleteButton.onEvent("Click", (*) => 

        ;     this.listView.Delete(rowNumber)
        ;     IniDelete(this.iniFile, iniFileSection, settingName)
        ;     SettingsGui.Destroy()
        ; )
    }

    
    SaveButtonClickEvent(SettingsGui, rowNumber, inputKey, iniFileSection, inputValue){
        ; TODO validate values, can not be empty!, can not be the same as another key, etc...
        if(rowNumber != 0){
            oldIniFileKey := this.listView.GetText(rowNumber)
            IniDelete this.iniFile, iniFileSection, oldIniFileKey
            this.listView.Modify(rowNumber, , inputKey.Value, inputValue.Value)
        }
        else{
            this.listView.Add(, inputKey.Value, inputValue.Value)

        }
        IniWrite(inputValue.Value, this.iniFile, iniFileSection, inputKey.Value)
        SettingsGui.Destroy()
        ; TODO change this
        Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
    }
}