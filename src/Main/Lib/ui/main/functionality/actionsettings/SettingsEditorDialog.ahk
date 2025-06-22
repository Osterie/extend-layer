#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <DataModels\ActionSettings\ActionSetting>

class SettingsEditorDialog extends DomainSpecificGui{
    
    settingNameEdit := ""
    settingValueEdit := ""

    saveEventSubscribers := ""

    __New(ownerHwnd := ""){
        this.saveEventSubscribers := Array()
        Super.__New("+Resize", "Settings Editor Dialog")
        this.SetOwner(ownerHwnd)
    }

    CreateControls(setting){

        settingName := setting.getActionSettingName()
        settingValue := setting.getActionSettingValue()
        
        this.Add("Text", "w300 h20", "Action Setting:")
        this.settingNameEdit := this.Add("Edit", "xm w300 h20", settingName)
        
        this.Add("Text", "xm w300 h20", "Action Setting value:")
        this.settingValueEdit := this.Add("Edit", "xm w300 h20", settingValue)
        
        SaveButton := this.Add("Button", "w100 h20", "Save")
        SaveButton.onEvent("Click", (*) => this.NotifyListenersSave())
        CancelButton := this.Add("Button", "w100 h20", "Cancel")
        CancelButton.onEvent("Click", (*) =>this.Destroy())
    }

    SubscribeToSaveEvent(event){
        this.saveEventSubscribers.Push(event)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.getActionSetting())
        }
        this.Destroy()
    }

    getActionSetting(){
        return ActionSetting(this.getActionSettingName(), this.getActionSettingValue())
    }

    getActionSettingName(){
        return this.settingNameEdit.Value
    }
    
    getActionSettingValue(){
        return this.settingValueEdit.Value
    }
    
    DisableSettingNameEdit(){
        this.settingNameEdit.Opt("+Disabled")
    }

    DisableSettingValueEdit(){
        this.settingValueEdit.Opt("+Disabled")
    }
}