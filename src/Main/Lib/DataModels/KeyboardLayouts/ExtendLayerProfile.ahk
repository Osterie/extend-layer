#Requires AutoHotkey v2.0

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
; KeyboardLayersInfoRegistry
class ExtendLayerProfile {

    keyboardOverlayLayers := Map()
    hotkeys := Map()

    __New() {
        this.keyboardOverlayLayers.Defualt := 0
        this.hotkeys.Defualt := 0
    }

    AddKeyboardOverlayLayerInfo(KeyboardOverlayLayer) {
        this.keyboardOverlayLayers[KeyboardOverlayLayer.GetLayerIdentifier()] := KeyboardOverlayLayer
    }

    AddHotkeyLayer(Hotkeys) {
        this.hotkeys[Hotkeys.GetLayerIdentifier()] := Hotkeys
    }

    addHotkey(layerIdentifier, hotkeyAction) {
        this.hotkeys[layerIdentifier].addHotkey(hotkeyAction)
    }

    deleteHotkey(layerIdentifier, hotkeyName) {
        this.hotkeys[layerIdentifier].deleteHotkey(hotkeyName)
    }

    ; TODO remove me perhaps, a new and better method is being developed...
    changeHotkey(layerIdentifier, hotkeyName, newHotkey) {
        this.hotkeys[layerIdentifier].ChangeHotkeyKey(hotkeyName, newHotkey)
    }

    ; TODO add checks if empty string or such is given.
    ChangeAction(layerIdentifier, hotkeyName, newAction) {
        this.hotkeys[layerIdentifier].ChangeHotkeyAction(hotkeyName, newAction)
    }

    ; TODO implement this and use it for creating new actions/hotkeys with the gui.
    ; SetAction(layerIdentifier, hotkeyName, action){
    ;     this.hotkeys[layerIdentifier].SetHotkeyAction(hotkeyName, action)
    ; }

    ; TODO refactor

    GetRegistryByLayerIdentifier(layerIdentifier) {
        registryToReturn := ""
        if (this.keyboardOverlayLayers.Has(layerIdentifier)) {
            registryToReturn := this.keyboardOverlayLayers[layerIdentifier]
        }
        else if (this.hotkeys.Has(layerIdentifier)) {
            registryToReturn := this.hotkeys[layerIdentifier]
        }
        else{
            throw ("No registry found for layer identifier: " . layerIdentifier)
        }
        return registryToReturn
    }

    getKeyboardOverlayByLayerIdentifier(layerIdentifier) {
        if (this.keyboardOverlayLayers.Has(layerIdentifier)) {
            return this.keyboardOverlayLayers[layerIdentifier]
        }
        else {
            throw ("No keyboard overlay found for layer identifier: " . layerIdentifier)
        }
    }

    getHotkeyLayerByLayerIdentifier(layerIdentifier) {
        if (this.hotkeys.Has(layerIdentifier)) {
            return this.hotkeys[layerIdentifier]
        }
        else {
            throw ("No hotkey layer found for layer identifier: " . layerIdentifier)
        }
    }

    GetLayerIdentifiers() {
        layerIdentifiers := Array()
        for layerIdentifier, layerInfo in this.hotkeys {
            layerIdentifiers.Push(layerIdentifier)
        }
        for layerIdentifier, layerInfo in this.keyboardOverlayLayers {
            layerIdentifiers.Push(layerIdentifier)
        }
        return layerIdentifiers
    }

    GetKeyboardOverlays() {
        ; TODO return array instead of map?
        return this.keyboardOverlayLayers
    }

    GetHotkeyLayer() {
        return this.hotkeys
    }

    GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey) {
        return this.GetRegistryByLayerIdentifier(layerIdentifier).GetHotkey(hotkeyKey)
    }

    toJson(){
        jsonObject := Map()
        
        for hotkeyLayerIdentifier, HotkeyLayer in this.hotkeys {
            jsonObject[hotkeyLayerIdentifier] := HotkeyLayer.toJson()
        }
        
        for keyboardOverlayLayerIdentifier, KeyboardOverlayLayer in this.keyboardOverlayLayers {
            jsonObject[keyboardOverlayLayerIdentifier] := KeyboardOverlayLayer.toJson()
        }
        
        return jsonObject
    }

    fromJson(jsonObject) {
        ; TODO implement this
        throw "Not implemented yet"
    }
}
