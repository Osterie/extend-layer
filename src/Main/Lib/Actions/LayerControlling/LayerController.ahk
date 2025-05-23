#Requires Autohotkey v2.0

#Include ".\LayerIndicator.ahk"

; TODO: perhaps it should be called registry?

; TODO; instead of multiple guis, it would be possible to just change the color and have the same gui no change...
#Include <Actions\Action>

Class LayerController extends Action{
    
    layers := Map()
    activeLayer := 0
    showLayerIndicatorOnAllMonitors := 0
    ; 0 is default, show layer indicator in bottom left corner of the screen
    ; 1 show indicator top middle of the screen
    ; 2 show indicator in all corners of the screen
    layerPositionMode := 0

    __New(showLayerIndicatorOnAllMonitors := 0, layerPositionMode := 0){
        this.showLayerIndicatorOnAllMonitors := showLayerIndicatorOnAllMonitors
        this.layerPositionMode := layerPositionMode
    }

    addLayerIndicator(layer, color, transparent := false){
        if (this.showLayerIndicatorOnAllMonitors = 0){
            if (this.layerPositionMode = 2){
                Loop 4{
                    this.createLayerIndicator(layer, color, transparent)
                }
            }
            else{
                this.createLayerIndicator(layer, color, transparent)
            }
        }
        else if (this.showLayerIndicatorOnAllMonitors = 1){
            if (this.layerPositionMode = 2){
                Loop MonitorGetCount(){
                    monitorIndex := A_Index
                    Loop 4{
                    this.createLayerIndicator(layer, color, transparent, monitorIndex)
                    }
                }
            }
            else{
                Loop MonitorGetCount(){
                    this.createLayerIndicator(layer, color, transparent, A_Index)
                }
            }
        }
        else{
            MsgBox("Invalid value for showLayerIndicatorOnAllMonitors: " . this.showLayerIndicatorOnAllMonitors)
        }
    }

    createLayerIndicator(layer, color, transparent := false, monitorIndex := 0){
        layerIndicatorInstance := 0
        if (monitorIndex = 0){
            layerIndicatorInstance := LayerIndicator(layer, color, transparent)
        }
        else{
            layerIndicatorInstance := LayerIndicator(layer, color, transparent, monitorIndex)
        }

        layerIndicatorInstance.createLayerIndicator()
        this.storeLayerIndicator(layer, layerIndicatorInstance)
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

        if (this.layerPositionMode = 0){
            this.showLayerPositionMode0(layerIndicatorInstances)
        }
        else if (this.layerPositionMode = 1){
            this.showLayerPositionMode1(layerIndicatorInstances)
        }
        else if (this.layerPositionMode = 2){
            this.showLayerPositionMode2(layerIndicatorInstances)
        }
        else{
            MsgBox("Invalid layer position mode: " . this.layerPositionMode)
        }
        this.hideInactiveLayers()
    }

    showLayerPositionMode0(layerIndicatorInstances){
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstance := layerIndicatorInstances[A_Index]
            monitorOfLayerIndicator := layerIndicatorInstance.monitor
            MonitorGetWorkArea monitorOfLayerIndicator, &workLeft, &workTop, &workRight, &workBottom

            layerIndicatorInstance.Show(workLeft, workBottom-142)
        }
    }

    showLayerPositionMode1(layerIndicatorInstances){
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstance := layerIndicatorInstances[A_Index]
            monitorOfLayerIndicator := layerIndicatorInstance.monitor
            MonitorGetWorkArea monitorOfLayerIndicator, &workLeft, &workTop, &workRight, &workBottom

            centerOfScreen := workLeft + ( (workRight - workLeft) / 2 )
            centerOfScreen := centerOfScreen - 25

            layerIndicatorInstance.Show(centerOfScreen, workTop)
        }
    }

    showLayerPositionMode2(layerIndicatorInstances){
        counter := 1
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstance := layerIndicatorInstances[A_Index]
            monitorOfLayerIndicator := layerIndicatorInstance.monitor
            MonitorGetWorkArea monitorOfLayerIndicator, &workLeft, &workTop, &workRight, &workBottom

            if (counter = 1){
                x := workLeft
                y := workBottom-142
            }
            else if (counter = 2){
                x := workRight-50
                y := workBottom-142
            }
            else if (counter = 3){
                x := workLeft
                y := workTop
            }
            else if (counter = 4){
                x := workRight-50
                y := workTop
            }
            else{
                counter := 0
            }
            counter := counter+1

            layerIndicatorInstance.Show(x, y)
        }

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