#Requires AutoHotkey v2.0

class SettingsEditor{
    
    SaveButton := ""
    DeleteButton := ""

    settingNameEdit := ""
    settingValueEdit := ""

    SettingsGui := ""


    CreateControls(settingName, settingValue){

        ; TODO should be set to on top, can not be not top ever...
        
        this.SettingsGui := Gui("+Resize +MinSize300x560", "Settings")
        
        this.SettingsGui.Add("Text", "w300 h20", "Setting:")
        this.settingNameEdit := this.SettingsGui.Add("Edit", "xm w300 h20", settingName)
        
        this.SettingsGui.Add("Text", "xm w300 h20", "Setting value:")
        this.settingValueEdit := this.SettingsGui.Add("Edit", "xm w300 h20", settingValue)
        
        this.SaveButton := this.SettingsGui.Add("Button", "w100 h20", "Save")
        CancelButton := this.SettingsGui.Add("Button", "w100 h20", "Cancel")
        CancelButton.onEvent("Click", (*) =>this.SettingsGui.Destroy())
        this.DeleteButton := this.SettingsGui.Add("Button", "w100 h20", "Delete")

        this.SettingsGui.Show()
    }

    DisableSettingNameEdit(){
        this.settingNameEdit.Opt("+Disabled")
    }

    DisableSettingValueEdit(){
        this.settingValueEdit.Opt("+Disabled")
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

    Destroy(){
        this.SettingsGui.Destroy()
    }
}