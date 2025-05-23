#Requires Autohotkey v2.0

#Include ".\LayerIndicator.ahk"

; TODO: perhaps it should be called registry?

; TODO; instead of multiple guis, it would be possible to just change the color and have the same gui no change...
#Include <Actions\Action>

Class LayerController extends Action{
    
    layers := Map()
    activeLayer := 0
    showLayerIndicatorOnAllMonitors := 0

    __New(showLayerIndicatorOnAllMonitors := 0){
        this.showLayerIndicatorOnAllMonitors := showLayerIndicatorOnAllMonitors
    }

    addLayerIndicator(layer, color, transparent := false){
        if (this.showLayerIndicatorOnAllMonitors = 0){
            layerIndicatorInstance := LayerIndicator(layer, color, transparent)
            layerIndicatorInstance.createLayerIndicator()
            this.storeLayerIndicator(layer, layerIndicatorInstance)
        }
        else if (this.showLayerIndicatorOnAllMonitors = 1){

            MonitorCount := MonitorGetCount()

            Loop MonitorCount{
                layerIndicatorInstance := LayerIndicator(layer, color, transparent, A_Index)
                layerIndicatorInstance.createLayerIndicator()
                this.storeLayerIndicator(layer, layerIndicatorInstance)
            }
        }
        else{
            MsgBox("Invalid value for showLayerIndicatorOnAllMonitors: " . this.showLayerIndicatorOnAllMonitors)
        }
    }

    storeLayerIndicator(layer, layerIndicatorInstance){
        if (this.layers.Has(layer) = true){
            existingLayerIndicatorInstances := this.layers.Get(layer)
            existingLayerIndicatorInstances.Push(layerIndicatorInstance)
        }
        else{
            this.layers.Set(layer, [layerIndicatorInstance])
        }
    }

    destroyLayerIndicator(layer){
        layerIndicatorInstances := this.layers.Get(layer)
        if (layerIndicatorInstances == 0){
            MsgBox("Layer indicator instance not found for layer: " . layer)
            return
        }
        
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstances[A_Index].Destroy()
        }
    }

    showLayerIndicator(layer){
        this.activeLayer := layer
        layerIndicatorInstances := this.layers.Get(layer)
        if (layerIndicatorInstances == 0){
            MsgBox("Layer indicator instance not found for layer: " . layer)
            return
        }
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstances[A_Index].Show()
        }
        this.hideInactiveLayers()
    }

    hideLayerIndicator(layer){
        layerIndicatorInstances := this.layers.Get(layer)
        if (layerIndicatorInstances == 0){
            MsgBox("Layer indicator instance not found for layer: " . layer)
            return
        }
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstances[A_Index].Hide()
        }
    }

    hideInactiveLayers(){
        loop this.layers.Count{
            if (A_Index != this.activeLayer){
                this.hideLayerIndicator(A_Index)
            }
        }
    }

    ; sets the layer to toggleValue if layer is 0, or to 0 if active laye is not zero
    toggleLayer(toggleValue){
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
    cycleLayers(defaultSetLayer){
        layersAmount := this.layers.Count
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

    getLayerIndicators(){
        return this.layers.Get(this.activeLayer)
    }

    getActiveLayer(){
        return this.activeLayer
    }

    setActiveLayer(activeLayer){
        this.activeLayer := activeLayer
        if (activeLayer != 0){
            this.showLayerIndicator(activeLayer)
        }
        else{
            this.hideInactiveLayers()
        }
    }

    Destroy(){
        loop this.layers.Count{
            this.destroyLayerIndicator(A_Index)
        }
    }
}