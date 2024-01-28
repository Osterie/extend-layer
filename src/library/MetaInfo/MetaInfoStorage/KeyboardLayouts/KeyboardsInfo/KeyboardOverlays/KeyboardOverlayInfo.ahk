#Requires AutoHotkey v2.0

class OverlayLayerInfo{

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := ""

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier, OverlayElements){
        this.ShowKeyboardOverlayKey = ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
        ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"

        this.OverlayElements := OverlayElements
    }

    getKeyboardLayerOverlayIdentifier(){
        return this.KeyboardLayerOverlayIdentifier
    }

    getOverlayElements(){
        return this.OverlayElements
    }

    getOverlayElement(OverlayElementName){
        return this.OverlayElements.getOverlay[OverlayElementName]
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