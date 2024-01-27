#Requires AutoHotkey v2.0

class OverlayLayerInfo{

    
    ShowKeyboardOverlayKey := ""
    overlayElementsIdentifier := ""
    OverlayElements := ""

    __New(ShowKeyboardOverlayKey, overlayElementsIdentifier){
        this.ShowKeyboardOverlayKey = ShowKeyboardOverlayKey
        this.overlayElementsIdentifier := overlayElementsIdentifier

        this.OverlayElements := Map()        
    }

    addOverlayElement(OverlayElement){
        this.OverlayElements[OverlayElement.getElementName()] := OverlayElement
    }

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
}