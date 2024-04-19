#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotKeyConfigurationModel{

    activeObjectsRegistry := ""
    hotkeyInformation := ""

    originalHotkeyKey := ""
    originalActionFriendly := ""

    __New(activeObjectsRegistry, hotkeyInformation){
        this.activeObjectsRegistry := activeObjectsRegistry
        
        this.hotkeyInformation := hotkeyInformation
        this.originalHotkeyKey := this.hotkeyInformation.getHotkeyName()
        this.originalActionFriendly := this.hotkeyInformation.toString()
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }


    ; TODO dont do this here... do it after save+done is clicked...!!
    SetHotkeyKey(newHotkey){
        this.hotkeyInformation.changeHotkey(newHotkey)
    }

    SetHotkeyAction(newAction){
        hotkeyKey := this.hotkeyInformation.getHotkeyName()
        this.hotkeyInformation := newAction
        this.hotkeyInformation.changeHotkey(hotkeyKey)
    }

    SetHotkeyInfo(hotkeyInformation){
        this.hotkeyInformation := hotkeyInformation
    }

    GetHotkeyInfo(){
        return this.hotkeyInformation
    }

    GetOriginalHotkey(){
        return this.originalHotkeyKey
    }

    GetOriginalActionFriendly(){
        return this.originalActionFriendly
    }

    GetHotkey(){
        return this.hotkeyInformation.getHotkeyName()
    }

    GetHotkeyFriendly(){
        return this.hotkeyInformation.getFriendlyHotkeyName()
    }

    GetActionFriendly(){
        return this.hotkeyInformation.toString()
    }

}
