#Requires Autohotkey v2.0

#Include ".\LayerIndicator.ahk"

#Include <Actions\HotkeyAction>

Class LayerController extends HotkeyAction{
    
    layers := Map()
    layers.Default := []
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

    addLayerIndicator(layer, color, transparent := false, image := ""){
        if (this.showLayerIndicatorOnAllMonitors = 0){
            if (this.layerPositionMode = 2){
                Loop 4{
                    this.createLayerIndicator(layer, color, transparent, image)
                }
            }
            else{
                this.createLayerIndicator(layer, color, transparent, image)
            }
        }
        else if (this.showLayerIndicatorOnAllMonitors = 1){
            if (this.layerPositionMode = 2){
                Loop MonitorGetCount(){
                    monitorIndex := A_Index
                    Loop 4{
                    this.createLayerIndicator(layer, color, transparent, image, monitorIndex)
                    }
                }
            }
            else{
                Loop MonitorGetCount(){
                    this.createLayerIndicator(layer, color, transparent, image, A_Index)
                }
            }
        }
        else{
            MsgBox("Invalid value for showLayerIndicatorOnAllMonitors: " . this.showLayerIndicatorOnAllMonitors)
        }
    }

    createLayerIndicator(layer, color, transparent := false, image := "", monitorIndex := 0){
        layerIndicatorInstance := 0
        if (monitorIndex = 0){
            layerIndicatorInstance := LayerIndicator(layer, color, transparent, image)
        }
        else{
            layerIndicatorInstance := LayerIndicator(layer, color, transparent, image, monitorIndex)
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
            layerIndicatorInstances[A_Index].destroy()
        }
    }

    showLayerIndicator(layer){
        this.activeLayer := layer

        layerIndicatorInstances := this.layers.Get(this.activeLayer)
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
            
            heightOffset := layerIndicatorInstance.getIndicatorHeight()

            layerIndicatorInstance.Show(workLeft, workBottom-heightOffset)
        }
    }

    showLayerPositionMode1(layerIndicatorInstances){
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstance := layerIndicatorInstances[A_Index]
            monitorOfLayerIndicator := layerIndicatorInstance.monitor
            MonitorGetWorkArea monitorOfLayerIndicator, &workLeft, &workTop, &workRight, &workBottom

            widthOffset := layerIndicatorInstance.getIndicatorWidth()

            centerOfScreen := workLeft + ( (workRight - workLeft) / 2 )
            centerOfScreen := centerOfScreen - (widthOffset/2)

            layerIndicatorInstance.Show(centerOfScreen, workTop)
        }
    }

    showLayerPositionMode2(layerIndicatorInstances){
        counter := 1
        Loop layerIndicatorInstances.Length{
            layerIndicatorInstance := layerIndicatorInstances[A_Index]
            monitorOfLayerIndicator := layerIndicatorInstance.monitor
            MonitorGetWorkArea monitorOfLayerIndicator, &workLeft, &workTop, &workRight, &workBottom
            
            heightOffset := layerIndicatorInstance.getIndicatorHeight()
            widthOffset := layerIndicatorInstance.getIndicatorWidth()

            if (counter >= 5){
                counter := 1
            }
            
            if (counter = 1){
                x := workLeft
                y := workBottom-heightOffset
            }
            else if (counter = 2){
                x := workRight-widthOffset
                y := workBottom-heightOffset
            }
            else if (counter = 3){
                x := workLeft
                y := workTop
            }
            else if (counter = 4){
                x := workRight-widthOffset
                y := workTop
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

    ; Public, can be used as hotkey
    setActiveLayer(activeLayer){
        this.activeLayer := activeLayer
        if (activeLayer != 0){
            this.showLayerIndicator(activeLayer)
        }
        else{
            this.hideInactiveLayers()
        }
    }

    ; Public, can be used as hotkey
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

    ; Public, can be used as hotkey
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

    destroy(){
        loop this.layers.Count{
            this.destroyLayerIndicator(A_Index)
        }
    }
}