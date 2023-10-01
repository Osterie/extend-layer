#Requires Autohotkey v2.0

#Include "%A_ScriptDir%\library\LayerIndicator.ahk"

; TODO; instead of multiple guis, it would be possible to just change the color and have the same gui no change...
Class LayerIndicatorController{
    
    layers := []
    activeLayer := 0

    addLayerIndicator(layer, color){
        
        layerIndicatorInstance := LayerIndicator(layer, color)
        layerIndicatorInstance.createLayerIndicator()
        this.layers.InsertAt(layer, layerIndicatorInstance) 
    }

    showLayerIndicator(layer){
        this.activeLayer := layer
        this.layers[layer].showGui()
    }
    hideLayerIndicator(layer){
        this.activeLayer := 0
        this.layers[layer].hideGui()
    }

    hideInactiveLayers(){
        loop this.layers.Length
            if (A_Index != this.activeLayer){
                this.layers[A_Index].hideGui()
            }
    }

    getLayerIndicator(){
        return this.layers[this.activeLayer]
    }

    getActiveLayer(){
        return this.activeLayer
    }

    setCurrentLayerIndicator(layer){
        this.activeLayer := layer
    }

    ; sets the layer to toggleValue if layer is 0, or to 0 if active laye is not zero
    toggleLayerIndicator(toggleValue){
        if (this.activeLayer == 0){
            this.activeLayer := toggleValue
        }
        else{
            this.activeLayer := 0
        }
    }

    ; increases activeLayer by 1, if upperLimit is reached, it is set back to 1 (Note, not does not go back to 0)
    cycleExtraLayerIndicators(){
        layersAmount := this.layers.Length
        this.activeLayer := this.activeLayer+1 
        if( this.activeLayer == layersAmount+1){
            this.activeLayer := 1
        }
    }

    ; sets activeLayer to 0
    resetLayerIndicators(){
        this.activeLayer := 0
    }
}