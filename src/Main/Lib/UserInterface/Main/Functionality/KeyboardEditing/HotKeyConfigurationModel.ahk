#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationModel{

    activeObjectsRegistry := ""
    arrayOfKeyNames := Array()
    hotkeyInfo := ""

    originalHotkeyKey := ""
    originalActionFriendly := ""

    __New(activeObjectsRegistry, arrayOfKeyNames, hotkeyInfo){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
        this.hotkeyInfo := hotkeyInfo

        this.originalHotkeyKey := this.hotkeyInfo.getHotkeyName()
        this.originalActionFriendly := this.hotkeyInfo.toString()
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetArrayOfKeyNames(){
        return this.arrayOfKeyNames
    }

    SetHotkeyKey(newHotkey){
        this.hotkeyInfo.changeHotkey(newHotkey)
    }

    SetHotkeyAction(newAction){
        hotkeyKey := this.hotkeyInfo.getHotkeyName()
        this.hotkeyInfo := newAction
        this.hotkeyINfo.changeHotkey(hotkeyKey)
    }

    SetHotkeyInfo(hotkeyInfo){
        this.hotkeyInfo := hotkeyInfo
    }

    GetHotkeyInfo(){
        return this.hotkeyInfo
    }

    GetOriginalHotkeyFriendly(){
        return HotkeyFormatConverter.convertToFriendlyHotkeyName(this.originalHotkeyKey)
    }

    GetOriginalHotkey(){
        return this.originalHotkeyKey
    }

    GetOriginalActionFriendly(){
        return this.originalActionFriendly
    }

    GetHotkeyFriendly(){
        return this.hotkeyInfo.getFriendlyHotkeyName()
    }

    GetActionFriendly(){
        return this.hotkeyInfo.toString()
    }
}
