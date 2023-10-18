#Requires Autohotkey v2.0

Class KeyboardOverlayRegistry{
    
    keyboardOverlays := Map()
    activeOverlay := ""

    AddKeyboardOverlay(keyboardOverlay, keyboardOverlayName){
        this.keyboardOverlays[keyboardOverlayName] := keyboardOverlay
    }

    ShowKeyboardOverlay(keyboardOverlayName){
        this.activeOverlay := keyboardOverlayName
        this.keyboardOverlays[keyboardOverlayName].ShowGui()
        this.HideInactiveLayers()
    }
    
    HideKeyboardOverlay(keyboardOverlayName){
        this.activeOverlay := keyboardOverlayName
        this.keyboardOverlays[keyboardOverlayName].HideGui()
    }

    HideInactiveLayers(){
        for keyboardOverlayName, KeyboardOverlayObject in this.keyboardOverlays{
            if (keyboardOverlayName != this.activeOverlay){
                KeyboardOverlayObject.HideGui()
            }
        }
    }

    HideAllLayers(){
        for keyboardOverlayName, KeyboardOverlayObject in this.keyboardOverlays{
            KeyboardOverlayObject.HideGui()
        }
    }

    GetActiveKeyboardOverlay(){
        return this.keyboardOverlays[this.activeOverlay]
    }

    GetActiveLayer(){
        return this.activeOverlay
    }

    GetKeyboardOverlay(keyboardOverlayName){
        return this.keyboardOverlays[keyboardOverlayName]
    }

    SetCurrentKeyboardOverlay(keyboardOverlay){
        this.activeOverlay := keyboardOverlay
    }
}