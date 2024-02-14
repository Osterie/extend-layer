#Requires Autohotkey v2.0

#Include ".\LayerIndicator.ahk"

; TODO: perhaps it should be called registry?

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
        this.hideInactiveLayers()
    }

    hideLayerIndicator(layer){
        this.layers[layer].hideGui()
    }

    hideInactiveLayers(){
        loop this.layers.Length{
            if (A_Index != this.activeLayer){
                this.hideLayerIndicator(A_Index)
            }
        }
    }

    ; sets the layer to toggleValue if layer is 0, or to 0 if active laye is not zero
    toggleLayerIndicator(toggleValue){
        if (this.activeLayer == 0){
            this.activeLayer := toggleValue
            this.showLayerIndicator(this.activeLayer)
        }
        else{
            this.activeLayer := 0
            this.hideInactiveLayers()
        }
    }

    ; increases activeLayer by 1, if upperLimit is reached, it is set back to 1 (Note, not does not go back to 0)
    cycleLayerIndicators(defaultSetLayer){
        layersAmount := this.layers.Length
        if (this.activeLayer == 0){
            this.activeLayer := defaultSetLayer
        }
        else{
            this.activeLayer := this.activeLayer+1 
            if(this.activeLayer == layersAmount+1){
                this.activeLayer := 1
            }
        }
        this.showLayerIndicator(this.activeLayer)
        this.hideInactiveLayers()
    }

    ; sets activeLayer to 0
    resetLayerIndicators(){
        this.activeLayer := 0
    }

    getLayerIndicator(){
        return this.layers[this.activeLayer]
    }

    getActiveLayer(){
        return this.activeLayer
    }

    setActiveLayer(activeLayer){
        this.activeLayer := activeLayer
    }
}