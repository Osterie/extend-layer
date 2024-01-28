#Requires AutoHotkey v2.0

class OverlayLayerInfo{

    keyboardLayerIdentifier := ""
    overlayElementsIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := ""

    __New(ShowKeyboardOverlayKey, overlayElementsIdentifier, keyboardLayerIdentifier){
        this.ShowKeyboardOverlayKey = ShowKeyboardOverlayKey
        this.overlayElementsIdentifier := overlayElementsIdentifier
        this.keyboardLayerIdentifier := keyboardLayerIdentifier

        this.OverlayElements := Map()        
    }

    getOverlayElements(){
        return this.OverlayElements
    }

    getOverlayElement(OverlayElementName){
        return this.OverlayElements[OverlayElementName]
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