#Requires AutoHotkey v2.0

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
class KeyboardLayersInfoRegistry{

    KeyboardOverlaysRegistry := ""
    HotkeysRegistry := ""

    __New(){
        this.KeyboardOverlaysRegistry := Map()
        this.HotkeysRegistry := Map()

        this.KeyboardOverlaysRegistry.Defualt := 0
        this.HotkeysRegistry.Defualt := 0
    }

    AddKeyboardOverlayLayerInfo(KeyboardOverlay){
        this.KeyboardOverlaysRegistry[KeyboardOverlay.GetLayerIdentifier()] := KeyboardOverlay
    }

    AddHotkeysRegistry(Hotkeys){
        this.HotkeysRegistry[Hotkeys.GetLayerIdentifier()] := Hotkeys
    }

    addHotkey(layerIdentifier, hotkeyAction){
        this.HotkeysRegistry[layerIdentifier].addHotkey(hotkeyAction)
    }

    deleteHotkey(layerIdentifier, hotkeyName){
        this.HotkeysRegistry[layerIdentifier].deleteHotkey(hotkeyName)
    }

    ; TODO remove me perhaps, a new and better method is being developed...
    changeHotkey(layerIdentifier, hotkeyName, newHotkey){
        this.HotkeysRegistry[layerIdentifier].ChangeHotkeyKey(hotkeyName, newHotkey)
    }

    ; TODO add checks if empty string or such is given.
    ChangeAction(layerIdentifier, hotkeyName, newAction){
        this.HotkeysRegistry[layerIdentifier].ChangeHotkeyAction(hotkeyName, newAction)
    }

    ; TODO implement this and use it for creating new actions/hotkeys with the gui.
    ; SetAction(layerIdentifier, hotkeyName, action){
    ;     this.HotkeysRegistry[layerIdentifier].SetHotkeyAction(hotkeyName, action)
    ; }

    GetRegistryByLayerIdentifier(layerIdentifier){
        registryToReturn := ""
        if (this.KeyboardOverlaysRegistry.Has(layerIdentifier)){
            registryToReturn := this.KeyboardOverlaysRegistry[layerIdentifier]
        }
        else if (this.HotkeysRegistry.Has(layerIdentifier)){
            registryToReturn := this.HotkeysRegistry[layerIdentifier]
        }
        ; else{
        ;     throw ("No registry found for layer identifier: " . layerIdentifier)
        ; }
        return registryToReturn
    }

    GetLayerIdentifiers(){
        layerIdentifiers := Array()
        for layerIdentifier, layerInfo in this.HotkeysRegistry{
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

    GetHotkeysRegistry(){
        return this.HotkeysRegistry
    }    

    GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey){
        return this.GetRegistryByLayerIdentifier(layerIdentifier).GetHotkey(hotkeyKey)
    }
}