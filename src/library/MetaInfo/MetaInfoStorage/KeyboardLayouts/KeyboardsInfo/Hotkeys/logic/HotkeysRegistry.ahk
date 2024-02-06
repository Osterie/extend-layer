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
        return this.hotkeys.get(hotkeyName)
    }

    ChangeHotkeyKey(hotkeyName, newHotkey){
        if (hotkeyName != newHotkey){
            
            if (StrLen(newHotKey) != 0){
                ; Replaces the old hotkey with the new one
                this.hotkeys[hotkeyName].changeHotkey(newHotkey)
                this.hotkeys[newHotKey] := this.hotkeys[hotkeyName]
            }
            ; If the new hotkey is empty, the original hotkey is just deleted instead of being replaced
            this.hotkeys.Delete(hotkeyName)
            Hotkey(hotkeyName, "Off")
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