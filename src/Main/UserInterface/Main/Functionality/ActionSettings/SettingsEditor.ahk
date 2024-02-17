#Requires AutoHotkey v2.0

class SettingsEditor{
    
    SaveButton := ""
    DeleteButton := ""

    settingNameEdit := ""
    settingValueEdit := ""


    CreateControls(settingName, settingValue){

        ; TODO should be set to on top, can not be not top ever...
        
        SettingsGui := Gui("+Resize +MinSize300x560", "Settings")
        
        SettingsGui.Add("Text", "w300 h20", "Setting:")
        this.settingNameEdit := SettingsGui.Add("Edit", "xm w300 h20", settingName)
        
        SettingsGui.Add("Text", "xm w300 h20", "Setting value:")
        this.settingValueEdit := SettingsGui.Add("Edit", "xm w300 h20", settingValue)
        
        this.SaveButton := SettingsGui.Add("Button", "w100 h20", "Save")
        CancelButton := SettingsGui.Add("Button", "w100 h20", "Cancel")
        this.DeleteButton := SettingsGui.Add("Button", "w100 h20", "Delete")

        SettingsGui.Show()

        CancelButton.onEvent("Click", (*) =>SettingsGui.Destroy())
        
        ; DeleteButton.onEvent("Click", (*) => 

        ;     this.listView.Delete(rowNumber)
        ;     IniDelete(this.iniFile, iniFileSection, settingName)
        ;     SettingsGui.Destroy()
        ; )
    }

    addSaveButtonEvent(eventType, action){
        if (Type(this.SaveButton) = "Gui.Button"){
            try{
                this.SaveButton.onEvent(eventType, action)
            }
            catch Error as e{
                MsgBox("Error in settings editor: " . e.Message)
            }
        }
        else{
            throw TypeError("Save button has not been created yet for SettingsEditor object.")
        }
    }

    addDeleteButtonEvent(eventType, action){
        if (Type(this.SaveButton) = "Gui.Button"){
            try{
                this.DeleteButton.onEvent(eventType, action)
            }
            catch Error as e{
                MsgBox("Error in settings editor: " . e.Message)
            }
        }
        else{
            throw TypeError("Delete button has not been created yet for SettingsEditor object.")
        }
    }

    GetSetting(){
        return this.settingNameEdit.Value
    }
    
    GetSettingValue(){
        return this.settingValueEdit.Value
    }
}