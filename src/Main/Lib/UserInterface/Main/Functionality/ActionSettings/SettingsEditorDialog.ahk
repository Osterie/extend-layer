#Requires AutoHotkey v2.0

#Include <UserInterface\Main\Util\DomainSpecificGui>

class SettingsEditorDialog extends DomainSpecificGui{
    
    settingNameEdit := ""
    settingValueEdit := ""

    saveEventSubscribers := ""

    __New(ownerHwnd := ""){
        this.saveEventSubscribers := Array()
        Super.__New("+Resize", "Settings Editor Dialog")

        if (ownerHwnd != ""){
            this.SetOwner(ownerHwnd)
        }
        
    }

    CreateControls(setting){

        settingName := setting.GetSettingName()
        settingValue := setting.GetSettingValue()
        
        this.Add("Text", "w300 h20", "Setting:")
        this.settingNameEdit := this.Add("Edit", "xm w300 h20", settingName)
        
        this.Add("Text", "xm w300 h20", "Setting value:")
        this.settingValueEdit := this.Add("Edit", "xm w300 h20", settingValue)
        
        SaveButton := this.Add("Button", "w100 h20", "Save")
        SaveButton.onEvent("Click", (*) => this.NotifyListenersSave())
        CancelButton := this.Add("Button", "w100 h20", "Cancel")
        CancelButton.onEvent("Click", (*) =>this.Destroy())

        this.Show()
    }

    SubscribeToSaveEvent(event){
        this.saveEventSubscribers.Push(event)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.GetSetting())
        }
        this.Destroy()
    }

    GetSetting(){
        return Setting(this.getSettingName(), this.getSettingValue())
    }

    GetSettingName(){
        return this.settingNameEdit.Value
    }
    
    GetSettingValue(){
        return this.settingValueEdit.Value
    }
    
    DisableSettingNameEdit(){
        this.settingNameEdit.Opt("+Disabled")
    }

    DisableSettingValueEdit(){
        this.settingValueEdit.Opt("+Disabled")
    }
}