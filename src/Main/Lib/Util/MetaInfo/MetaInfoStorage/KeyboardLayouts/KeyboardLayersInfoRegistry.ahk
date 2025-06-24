#Requires AutoHotkey v2.0

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
class KeyboardLayersInfoRegistry{

    KeyboardOverlaysRegistry := ""
    HotkeyLayer := ""

    __New(){
        this.KeyboardOverlaysRegistry := Map()
        this.HotkeyLayer := Map()

        this.KeyboardOverlaysRegistry.Defualt := 0
        this.HotkeyLayer.Defualt := 0
    }

    AddKeyboardOverlayLayerInfo(KeyboardOverlay){
        this.KeyboardOverlaysRegistry[KeyboardOverlay.GetLayerIdentifier()] := KeyboardOverlay
    }

    AddHotkeyLayer(Hotkeys){
        this.HotkeyLayer[Hotkeys.GetLayerIdentifier()] := Hotkeys
    }

    addHotkey(layerIdentifier, hotkeyAction){
        this.HotkeyLayer[layerIdentifier].addHotkey(hotkeyAction)
    }

    deleteHotkey(layerIdentifier, hotkeyName){
        this.HotkeyLayer[layerIdentifier].deleteHotkey(hotkeyName)
    }

    ; TODO remove me perhaps, a new and better method is being developed...
    changeHotkey(layerIdentifier, hotkeyName, newHotkey){
        this.HotkeyLayer[layerIdentifier].ChangeHotkeyKey(hotkeyName, newHotkey)
    }

    ; TODO add checks if empty string or such is given.
    ChangeAction(layerIdentifier, hotkeyName, newAction){
        this.HotkeyLayer[layerIdentifier].ChangeHotkeyAction(hotkeyName, newAction)
    }

    ; TODO implement this and use it for creating new actions/hotkeys with the gui.
    ; SetAction(layerIdentifier, hotkeyName, action){
    ;     this.HotkeyLayer[layerIdentifier].SetHotkeyAction(hotkeyName, action)
    ; }

    GetRegistryByLayerIdentifier(layerIdentifier){
        registryToReturn := ""
        if (this.KeyboardOverlaysRegistry.Has(layerIdentifier)){
            registryToReturn := this.KeyboardOverlaysRegistry[layerIdentifier]
        }
        else if (this.HotkeyLayer.Has(layerIdentifier)){
            registryToReturn := this.HotkeyLayer[layerIdentifier]
        }
        ; else{
        ;     throw ("No registry found for layer identifier: " . layerIdentifier)
        ; }
        return registryToReturn
    }

    GetLayerIdentifiers(){
        layerIdentifiers := Array()
        for layerIdentifier, layerInfo in this.HotkeyLayer{
            layerIdentifiers.Push(layerIdentifier)
        }
        for layerIdentifier, layerInfo in this.KeyboardOverlaysRegistry{
            layerIdentifiers.Push(layerIdentifier)
        }
        return layerIdentifiers
    }

    GetKeyboardOverlaysRegistry(){
        return this.KeyboardOverlaysRegistry
    }

    GetHotkeyLayer(){
        return this.HotkeyLayer
    }    

    GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey){
        return this.GetRegistryByLayerIdentifier(layerIdentifier).GetHotkey(hotkeyKey)
    }
}