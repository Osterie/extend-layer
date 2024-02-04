#Requires AutoHotkey v2.0

class HotkeysRegistry{

    hotkeys := ""
    layerIdentifier := ""

    __New(layerIdentifier){
        this.layerIdentifier := layerIdentifier
        this.hotkeys := Map()
    }

    AddHotkey(HotkeyInfo){
        this.hotkeys[HotkeyInfo.getHotkeyName()] := HotkeyInfo
    }

    GetLayerIdentifier(){
        return this.layerIdentifier
    }

    GetHotkey(hotkeyName){
        return this.hotkeys.get(hotkeyName)
    }

    ChangeHotkeyKey(hotkeyName, newHotkey){
        this.hotkeys[hotkeyName].changeHotkey(newHotkey)
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