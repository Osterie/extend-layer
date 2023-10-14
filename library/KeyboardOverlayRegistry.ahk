#Requires Autohotkey v2.0

Class KeyboardOverlayRegistry{
    
    keyboardOverlays := []
    activeOverlay := ""

    addKeyboardOverlay(keyboardOverlay){
        this.keyboardOverlays.Push(keyboardOverlay) 
    }

    showKeyboardOverlay(keyboardOverlay){
        this.activeOverlay := this.getIndexOf(keyboardOverlay)
        this.keyboardOverlays[this.activeOverlay].ShowGui()
        this.hideInactiveLayers()
    }
    hideKeyboardOverlay(keyboardOverlay){
        this.activeOverlay := this.getIndexOf(keyboardOverlay)
        this.keyboardOverlays[this.activeOverlay].HideGui()
    }

    hideInactiveLayers(){
        loop this.keyboardOverlays.Length{
            if (A_index != this.activeOverlay){
                this.keyboardOverlays[A_Index].HideGui()
            }
        }
    }

    hideAllLayers(){
        loop this.keyboardOverlays.Length{
            this.keyboardOverlays[A_Index].HideGui()
        }
    }

    getKeyboardOverlay(){
        return this.keyboardOverlays[this.activeOverlay]
    }

    getActiveLayer(){
        return this.activeOverlay
    }

    setCurrentKeyboardOverlay(keyboardOverlay){
        this.activeOverlay := keyboardOverlay
    }

    getIndexOf(givenKeyboardOverlay){
        loop this.keyboardOverlays.Length{
            if (this.keyboardOverlays[A_Index] == givenKeyboardOverlay){
                return A_Index
            }
        }
    }
}