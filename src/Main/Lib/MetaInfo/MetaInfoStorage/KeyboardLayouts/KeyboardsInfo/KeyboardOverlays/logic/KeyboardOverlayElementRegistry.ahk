#Requires AutoHotkey v2.0

class KeyboardOverlayElementRegistry{

    overlayElementsIdentifier := ""
    KeyboardOverlayElements := Map()

    __New(overlayElementsIdentifier){
        this.overlayElementsIdentifier := overlayElementsIdentifier
        ; this.overlayElementsIdentifier = "OverlayElements"
    }

    addKeyboardOverlayElement(KeyboardOverlayElement){
        this.KeyboardOverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    getKeyboardOverlayElement(keyboardElementName){ 
        return this.KeyboardOverlayElements.Get(keyboardElementName)
    }

    getKeyboardOverlayElements(){
        return this.KeyboardOverlayElements
    }
    
    getKeyPairValuesToString(){
        elements := []
        for elementNames, KeyboardOverlayElement in this.KeyboardOverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    getFriendlyHotkeyActionPairValues(){
        elements := []
        for elementNames, KeyboardOverlayElement in this.KeyboardOverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

}