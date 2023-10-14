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
        loop this.keyboardOverlays.Length
            this.keyboardOverlays[A_Index].HideGui()
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

    ; sets the keyboardOverlay to toggleValue if keyboardOverlay is 0, or to 0 if active laye is not zero
    ; toggleKeyboardOverlay(toggleValue){
    ;     if (this.activeOverlay == 0){
    ;         this.activeOverlay := toggleValue
    ;     }
    ;     else{
    ;         this.activeOverlay := 0
    ;     }
    ; }

    ; increases activeOverlay by 1, if upperLimit is reached, it is set back to 1 (Note, not does not go back to 0)
    ; cycleExtraKeyboardOverlays(){
    ;     layersAmount := this.keyboardOverlays.Length
    ;     this.activeOverlay := this.activeOverlay+1 
    ;     if( this.activeOverlay == layersAmount+1){
    ;         this.activeOverlay := 1
    ;     }
    ; }

    ; sets activeOverlay to 0
    ; resetKeyboardOverlays(){
    ;     this.activeOverlay := 0
    ; }

    getIndexOf(givenKeyboardOverlay){
        loop this.keyboardOverlays.Length{
            if (this.keyboardOverlays[A_Index] == givenKeyboardOverlay){
                return A_Index
            }
        }
    }
}