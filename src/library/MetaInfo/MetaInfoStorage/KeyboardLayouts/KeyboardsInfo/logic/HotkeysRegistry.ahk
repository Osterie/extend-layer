#Requires AutoHotkey v2.0

class LayerInfoRegistry extends LayerInfoRegistry{

    hotkeys := ""

    constructor(){
        super()
        this.hotkeys = Map()
    }

    AddHotkey(hotkeyName, HotkeyInfo){
        this.Hotkeys[hotkeyName] := HotkeyInfo
    }

    GetHotkey(hotkeyName){
        return this.Hotkeys.get(hotkeyName)
    }

    ToString(){

    }




}