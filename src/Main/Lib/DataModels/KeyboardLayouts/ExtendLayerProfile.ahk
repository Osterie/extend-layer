#Requires AutoHotkey v2.0

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
; KeyboardLayersInfoRegistry
class ExtendLayerProfile {

    keyboardOverlays := ""
    hotkeys := ""

    __New() {
        this.keyboardOverlays := Map()
        this.hotkeys := Map()

        this.keyboardOverlays.Defualt := 0
        this.hotkeys.Defualt := 0
    }

    AddKeyboardOverlayLayerInfo(KeyboardOverlay) {
        this.keyboardOverlays[KeyboardOverlay.GetLayerIdentifier()] := KeyboardOverlay
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

    GetRegistryByLayerIdentifier(layerIdentifier) {
        registryToReturn := ""
        if (this.keyboardOverlays.Has(layerIdentifier)) {
            registryToReturn := this.keyboardOverlays[layerIdentifier]
        }
        else if (this.hotkeys.Has(layerIdentifier)) {
            registryToReturn := this.hotkeys[layerIdentifier]
        }
        ; else{
        ;     throw ("No registry found for layer identifier: " . layerIdentifier)
        ; }
        return registryToReturn
    }

    GetLayerIdentifiers() {
        layerIdentifiers := Array()
        for layerIdentifier, layerInfo in this.hotkeys {
            layerIdentifiers.Push(layerIdentifier)
        }
        for layerIdentifier, layerInfo in this.keyboardOverlays {
            layerIdentifiers.Push(layerIdentifier)
        }
        return layerIdentifiers
    }

    GetKeyboardOverlaysRegistry() {
        return this.keyboardOverlays
    }

    GetHotkeyLayer() {
        return this.hotkeys
    }

    GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey) {
        return this.GetRegistryByLayerIdentifier(layerIdentifier).GetHotkey(hotkeyKey)
    }
}
