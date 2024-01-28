#Requires AutoHotkey v2.0

class KeyboardLayersInfoRegistry{

    KeyboardOverlayLayerInfoRegistry := ""
    HotkeysRegistry := ""

    AddKeyboardOverlayLayerInfoRegistry(KeyboardOverlayLayerInfoRegistry){
        this.KeyboardOverlayLayerInfoRegistry := KeyboardOverlayLayerInfoRegistry
    }
    AddHotkeysRegistry(HotkeysRegistry){
        this.HotkeysRegistry := HotkeysRegistry
    }
}