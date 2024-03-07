#Requires Autohotkey v2.0

Class LayerIndicator{

    indicatorColor := ""
    layer := 0
    layerIndicatorGui := 0

    __New(layer, color) {
        this.layer := layer
        this.indicatorColor := color
    }

    ; TODO create settings for changing the location, color, size, and such of the layer indicator...
    createLayerIndicator(){
        this.layerIndicatorGui := Gui()
        this.layerIndicatorGui.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.layerIndicatorGui.BackColor := this.indicatorColor
    }

    destroyGui(){
        this.layerIndicatorGui.destroy()
    }

    showGui(){
        guiHeight := A_ScreenHeight-142
        WinSetAlwaysOnTop 1, this.layerIndicatorGui
        this.layerIndicatorGui.show("x0 y" . guiHeight . " w50 h142 NoActivate")
    }

    hideGui(){
        this.layerIndicatorGui.hide()
    }

    setLayerColor(color){
        this.indicatorColor := color
        this.layerIndicatorGui.Color(color)
    }

    getLayerColor(){
        return this.indicatorColor
    }
}