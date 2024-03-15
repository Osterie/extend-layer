#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotKeyConfigurationModel{

    activeObjectsRegistry := ""
    arrayOfKeyNames := Array()
    hotkeyInformation := ""

    originalHotkeyKey := "No hotkey set."
    originalActionFriendly := "No action set."

    __New(activeObjectsRegistry, arrayOfKeyNames, hotkeyInformation := ""){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
        if (hotkeyInformation != ""){
            this.hotkeyInformation := hotkeyInformation
            this.originalHotkeyKey := this.hotkeyInformation.getHotkeyName()
            this.originalActionFriendly := this.hotkeyInformation.toString()
        }
        else{
            this.hotkeyInformation := HotKeyInfo("")
            this.originalHotkeyKey := "No hotkey set."
            this.originalActionFriendly := "No action set."
        }
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
        this.hotkeyINfo.changeHotkey(hotkeyKey)
    }

    SetHotkeyInfo(hotkeyInformation){
        this.hotkeyInformation := hotkeyInformation
    }

    GetHotkeyInfo(){
        return this.hotkeyInformation
    }

    GetOriginalHotkeyFriendly(){
        friendlyNameToReturn := "No hotkey set."
        if (this.originalHotkeyKey != ""){
            friendlyNameToReturn := HotkeyFormatConverter.convertToFriendlyHotkeyName(this.originalHotkeyKey)
        }
        return friendlyNameToReturn
    }

    GetOriginalHotkey(){
        return this.originalHotkeyKey
    }

    GetOriginalActionFriendly(){
        return this.originalActionFriendly
    }

    GetHotkeyFriendly(){
        friendlyNameToReturn := "No hotkey set."
        if (this.hotkeyInformation != ""){
            friendlyNameToReturn := this.hotkeyInformation.getFriendlyHotkeyName()
        }
        return friendlyNameToReturn
    }

    GetActionFriendly(){
        friendlyNameToReturn := "No action set."
        if (this.hotkeyInformation != ""){
            friendlyNameToReturn := this.hotkeyInformation.toString()
        }
        return friendlyNameToReturn
    }
}
