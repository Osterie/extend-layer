#Requires AutoHotkey v2.0

class HotkeysRegistry{

    hotkeys := ""
    layerIdentifier := ""

    constructor(){
        this.hotkeys = Map()
    }

    AddHotkey(HotkeyInfo, layerIdentifier){
        this.layerIdentifier := layerIdentifier
        this.hotkeys[HotkeyInfo.getHotkeyName()] := HotkeyInfo
    }

    GetHotkey(hotkeyName){
        return this.hotkeys.get(hotkeyName)
    }

    GetHotkeys(){
        return this.hotkeys
    }

    ToString(){

    }
}