#Requires AutoHotkey v2.0

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

    ; TODO remove me perhaps, a new and better method is being developed...
    ChangeHotkey(layerIdentifier, hotkeyName, newHotkey){
        this.HotkeysRegistry[layerIdentifier].ChangeHotkeyKey(hotkeyName, newHotkey)
    }

    GetRegistryByLayerIdentifier(layerIdentifier){
        registryToReturn := ""
        if (this.KeyboardOverlaysRegistry.Has(layerIdentifier)){
            registryToReturn := this.KeyboardOverlaysRegistry[layerIdentifier]
        }
        else if (this.HotkeysRegistry.Has(layerIdentifier)){
            registryToReturn := this.HotkeysRegistry[layerIdentifier]
        }
        else{
            throw ("No registry found for layer identifier: " . layerIdentifier)
        }
        return registryToReturn
    }

    GetKeyboardOverlaysRegistry(){
        return this.KeyboardOverlaysRegistry
    }

    GetHotkeysRegistry(){
        return this.HotkeysRegistry
    }    
}