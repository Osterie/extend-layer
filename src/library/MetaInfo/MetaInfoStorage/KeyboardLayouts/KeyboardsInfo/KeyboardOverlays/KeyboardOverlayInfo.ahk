#Requires AutoHotkey v2.0

class KeyboardOverlayInfo{

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := ""

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier, OverlayElements){
        this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
        ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"

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

    ; "SecondaryLayer-KeyboardOverlay1": {
        ; "ShowKeyboardOverlayKey": "~Shift",
        ; "overlayElements":{
        ;     "Column1": {
        ;         "key": "1",
        ;         "description": "Open Time Table\""
        ;     },
        ;     "Column2": {
        ;         "key": "2",
        ;         "description": "Black Board\""
        ;     },
        ; }
    ; }
}