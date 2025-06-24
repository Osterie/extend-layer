#Requires AutoHotkey v2.0

; KeyboardOverlayInfo
class KeyboardOverlayLayer {

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

    getKeyPairValuesToString() {
        return this.OverlayElements.getKeyPairValuesToString()
        ;         elements := []
        ; for elementNames, KeyboardOverlayElement in this.OverlayElements
        ;     elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        ; return elements
    }

    getShowKeyboardOverlayKey() {
        return this.ShowKeyboardOverlayKey
    }

    getFriendlyHotkeyActionPairValues() {
        return this.OverlayElements.getFriendlyHotkeyActionPairValues()

        ;         elements := []
        ; for elementNames, KeyboardOverlayElement in this.OverlayElements
        ;     elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        ; return elements
    }
}

#Requires AutoHotkey v2.0

class KeyboardOverlayElementRegistry {

    overlayElementsIdentifier := ""
    OverlayElements := Map()

    __New(overlayElementsIdentifier) {
        this.overlayElementsIdentifier := overlayElementsIdentifier
        ; this.overlayElementsIdentifier = "OverlayElements"
    }

    addKeyboardOverlayElement(KeyboardOverlayElement) {
        this.OverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    getKeyboardOverlayElement(keyboardElementName) {
        return this.OverlayElements.Get(keyboardElementName)
    }

    getKeyboardOverlayElements() {
        return this.OverlayElements
    }

    getKeyPairValuesToString() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    getFriendlyHotkeyActionPairValues() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

}
