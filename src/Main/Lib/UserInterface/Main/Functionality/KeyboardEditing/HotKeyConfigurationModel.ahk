#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotKeyConfigurationModel{

    activeObjectsRegistry := ""
    availableKeyNames := Array()
    hotkeyInformation := ""

    originalHotkeyKey := ""
    originalActionFriendly := ""

    __New(activeObjectsRegistry, availableKeyNames, hotkeyInformation){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.availableKeyNames := availableKeyNames
        
        this.hotkeyInformation := hotkeyInformation
        this.originalHotkeyKey := this.hotkeyInformation.getHotkeyName()
        this.originalActionFriendly := this.hotkeyInformation.toString()
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetAvailableKeyNames(){
        return this.availableKeyNames
    }

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
