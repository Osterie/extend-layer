#Requires AutoHotkey v2.0

class OverlayLayerInfoRegistry{

    layersInfo := ""

    constructor(){
        this.layersInfo = Map()
    }

    AddOverlayLayerInfo(hotkeyName, HotkeyInfo){
        this.layersInfo[hotkeyName] := HotkeyInfo
    }

    GetHotkey(hotkeyName){
        return this.layersInfo.get(hotkeyName)
    }

    ToString(){

    }
   
}