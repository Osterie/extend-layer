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
}