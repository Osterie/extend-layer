#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationModel{

    hotkeyDeleted := false
    actionDeleted := false

    currentActionTextControl := ""

    activeObjectsRegistry := ""

    arrayOfKeyNames := Array()

    hotkeyInfo := ""

    originalHotkey := ""
    originalAction := ""


    __New(activeObjectsRegistry, arrayOfKeyNames, hotkeyInfo){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.arrayOfKeyNames := arrayOfKeyNames
        this.hotkeyInfo := hotkeyInfo

        this.originalHotkey := this.hotkeyInfo.getHotkeyName()
        this.originalAction := this.hotkeyInfo.toString()
    }

    SetHotkeyInfo(hotkeyInfo){
        this.hotkeyInfo := hotkeyInfo
    }

    GetOriginalHotkey(){
        return this.originalHotkey
    }

    GetOriginalAction(){
        return this.originalAction
    }

    GetHotkeyFriendly(){
        return this.hotkeyInfo.getFriendlyHotkeyName()
    }

    GetActionFriendly(){
        return this.hotkeyInfo.toString()
    }
}
