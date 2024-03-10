#Requires AutoHotkey v2.0

#Include ".\KeyChanging\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\KeyChanging\ActionChanging\ActionCrafterGui.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Util\HotkeyFormatConverter>

class HotKeyConfigurationModel{

    hotkeyDeleted := false

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

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetArrayOfKeyNames(){
        return this.arrayOfKeyNames
    }

    SetHotkeyInfo(hotkeyInfo){
        this.hotkeyInfo := hotkeyInfo
    }

    setHotkeyDeletedStatus(status){
        this.hotkeyDeleted := status
    }

    GetHotkeyInfo(){
        return this.hotkeyInfo
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
