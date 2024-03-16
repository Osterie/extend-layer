#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotKeyConfigurationModel{

    activeObjectsRegistry := ""
    arrayOfKeyNames := Array()
    hotkeyInformation := ""

    originalHotkeyKey := ""
    originalActionFriendly := ""

    __New(activeObjectsRegistry, arrayOfKeyNames, hotkeyInformation){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
        
        this.hotkeyInformation := hotkeyInformation
        this.originalHotkeyKey := this.hotkeyInformation.getHotkeyName()
        this.originalActionFriendly := this.hotkeyInformation.toString()
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetArrayOfKeyNames(){
        return this.arrayOfKeyNames
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
