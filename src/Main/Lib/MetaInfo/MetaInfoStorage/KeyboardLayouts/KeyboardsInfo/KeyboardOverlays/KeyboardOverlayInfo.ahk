#Requires AutoHotkey v2.0

class KeyboardOverlayInfo{

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := ""

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier, OverlayElements){
        this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
        ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"
        ; TODO add type checks...
        this.OverlayElements := OverlayElements
    }

    GetLayerIdentifier(){
        return this.KeyboardLayerOverlayIdentifier
    }

    getOverlayElements(){
        return this.OverlayElements
    }

    getOverlayElement(OverlayElementName){
        return this.OverlayElements.getOverlay[OverlayElementName]
    }

    getKeyPairValuesToString(){
        return this.OverlayElements.getKeyPairValuesToString()
    }

    getShowKeyboardOverlayKey(){
        return this.ShowKeyboardOverlayKey
    }

    getFriendlyHotkeyActionPairValues(){
        return this.OverlayElements.getFriendlyHotkeyActionPairValues()
    }
}