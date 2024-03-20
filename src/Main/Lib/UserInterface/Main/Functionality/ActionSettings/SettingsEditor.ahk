#Requires AutoHotkey v2.0

#Include <UserInterface\Main\Util\DomainSpecificGui>

class SettingsEditor extends DomainSpecificGui{
    
    SaveButton := ""

    settingNameEdit := ""
    settingValueEdit := ""

    __New(){
        Super.__New("+Resize", "Settings")
    }

    CreateControls(settingName, settingValue){
        
        this.Add("Text", "w300 h20", "Setting:")
        this.settingNameEdit := this.Add("Edit", "xm w300 h20", settingName)
        
        this.Add("Text", "xm w300 h20", "Setting value:")
        this.settingValueEdit := this.Add("Edit", "xm w300 h20", settingValue)
        
        this.SaveButton := this.Add("Button", "w100 h20", "Save")
        CancelButton := this.Add("Button", "w100 h20", "Cancel")
        CancelButton.onEvent("Click", (*) =>this.Destroy())

        this.Show()
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

    GetSetting(){
        return this.settingNameEdit.Value
    }
    
    GetSettingValue(){
        return this.settingValueEdit.Value
    }
}