#Requires AutoHotkey v2.0

class HotkeysRegistry{

    hotkeys := Map()
    layerIdentifier := ""

    __New(layerIdentifier){
        this.layerIdentifier := layerIdentifier
        this.hotkeys.Default := ""
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

    ; TODO instead of reading the entire profile for keyboard again, perhaps i can just change the hotkey with this...
    ChangeHotkeyKey(hotkeyName, newHotkey){
        if (hotkeyName != newHotkey){
            
            if (StrLen(newHotKey) != 0){
                ; Replaces the old hotkey with the new one
                ; TODO can also check if hotkeyName is blank...
                if (this.hotkeys.Has(newHotkey)){
                    this.hotkeys[hotkeyName].changeHotkey(newHotkey)
                    this.hotkeys[newHotKey] := this.hotkeys[hotkeyName]
                }
                else{
                    ; TODO this method is not complete, it should have a parameter for hotkeyInfo, which is the hotkey that will be replaced and such... 
                    ; this.hotkeys[newHotKey] := this.hotkeys[hotkeyName]
                }
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