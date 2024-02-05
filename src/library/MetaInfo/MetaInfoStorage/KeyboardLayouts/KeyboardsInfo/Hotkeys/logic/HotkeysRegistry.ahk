#Requires AutoHotkey v2.0

class HotkeysRegistry{

    hotkeys := Map()
    layerIdentifier := ""

    __New(layerIdentifier){
        this.layerIdentifier := layerIdentifier
    }

    AddHotkey(HotkeyInfo){
        this.hotkeys[HotkeyInfo.getHotkeyName()] := HotkeyInfo
    }

    GetLayerIdentifier(){
        return this.layerIdentifier
    }

    GetHotkey(hotkeyName){
        msgbox(hotkeyName)
        return this.hotkeys.get(hotkeyName)
    }

    ChangeHotkeyKey(hotkeyName, newHotkey){
        if (hotkeyName != newHotkey){
            this.hotkeys[hotkeyName].changeHotkey(newHotkey)
            this.hotkeys[newHotKey] := this.hotkeys[hotkeyName]
            this.hotkeys.Delete(hotkeyName).changeHotkey(newHotkey)
        }
    }

    GetHotkeys(){
        return this.hotkeys
    }

    getKeyPairValuesToString(){
        elements := []
        for key, value in this.hotkeys
            elements.push([key, value.ToString()])

        return elements
    }

    getFriendlyHotkeyActionPairValues(){
        elements := []
        for key, value in this.hotkeys
            elements.push([value.getFriendlyHotkeyName(), value.ToString()])

        return elements
    }


    ToString(){

    }
}