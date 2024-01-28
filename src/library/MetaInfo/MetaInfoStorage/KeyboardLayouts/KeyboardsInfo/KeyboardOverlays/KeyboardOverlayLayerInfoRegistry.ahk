#Requires AutoHotkey v2.0

class OverlayLayerInfoRegistry{

    KeybaordOverlays := Map()

    __New(){

    }

    AddKeyboardOverlay(KeyboardOverlayInfo){
        this.KeybaordOverlays.Set(KeyboardOverlayInfo.getKeyboardLayerOverlayIdentifier(), KeyboardOverlayInfo)
    }

    GetKeyboardOverlay(KeyboardLayerOverlayIdentifier){
        return this.KeybaordOverlays.Get(KeyboardLayerOverlayIdentifier)
    }
}