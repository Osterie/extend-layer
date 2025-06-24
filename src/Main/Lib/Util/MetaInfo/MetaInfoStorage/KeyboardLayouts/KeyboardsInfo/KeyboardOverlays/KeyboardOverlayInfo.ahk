#Requires AutoHotkey v2.0

; class KeyboardOverlayInfo{

;     KeyboardLayerOverlayIdentifier := ""
;     ShowKeyboardOverlayKey := ""
;     OverlayElements := ""

;     __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier, OverlayElements){
;         this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
;         this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
;         ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"
;         ; TODO add type checks...
;         this.OverlayElements := OverlayElements
;     }

;     GetLayerIdentifier(){
;         return this.KeyboardLayerOverlayIdentifier
;     }

;     getOverlayElements(){
;         return this.OverlayElements
;     }

;     getOverlayElement(OverlayElementName){
;         return this.OverlayElements.getOverlay[OverlayElementName]
;     }

;     getKeyPairValuesToString(){
;         return this.OverlayElements.getKeyPairValuesToString()
;     }

;     getShowKeyboardOverlayKey(){
;         return this.ShowKeyboardOverlayKey
;     }

;     getFriendlyHotkeyActionPairValues(){
;         return this.OverlayElements.getFriendlyHotkeyActionPairValues()
;     }
; }

class KeyboardOverlayInfo {

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := Map()

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier) {
        this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
        ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"
        ; TODO add type checks...
    }

    addKeyboardOverlayElement(KeyboardOverlayElement) {
        this.OverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    GetLayerIdentifier() {
        return this.KeyboardLayerOverlayIdentifier
    }

    getOverlayElements() {
        return this.OverlayElements
    }

    getOverlayElement(OverlayElementName) {
        return this.OverlayElements.Get(OverlayElementName)
    }

    ; TODO renmae or remove, is this in use?
    getKeyPairValuesToString() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    getShowKeyboardOverlayKey() {
        return this.ShowKeyboardOverlayKey
    }

    ; TODO renmae or remove, is this in use?
    getFriendlyHotkeyActionPairValues() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }
}
