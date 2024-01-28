#Requires AutoHotkey v2.0

class OverlayElement{

    overlayElementsIdentifier := ""
    KeyboardOverlayElements := Map()

    __New(overlayElementsIdentifier){
        this.overlayElementsIdentifier = overlayElementsIdentifier
        ; this.overlayElementsIdentifier = "OverlayElements"
    }

    addKeyboardOverlayElement(KeyboardOverlayElement){
        this.KeyboardOverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    getKeyboardOverlayElement(keyboardElementName){ 
        return this.KeyboardOverlayElements.Get(keyboardElementName)
    }
    


}