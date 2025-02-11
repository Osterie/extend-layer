#Requires Autohotkey v2.0

#Include <Actions\Action>

Class LayerIndicator extends Action{ 

    indicatorColor := ""
    layer := 0
    layerIndicatorGui := 0
    isTransparent := 0

    __New(layer, color, transparent := 0) {
        this.layer := layer
        this.indicatorColor := color
        this.isTransparent := transparent
    }

    ; TODO create settings for changing the location, color, size, and such of the layer indicator...
    createLayerIndicator(){
        this.layerIndicatorGui := Gui()
        this.layerIndicatorGui.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.layerIndicatorGui.BackColor := this.indicatorColor
        if (this.isTransparent == 1){
            WinSetTransColor(this.indicatorColor, this.layerIndicatorGui)
        }
    }

    Destroy(){
        this.layerIndicatorGui.destroy()
    }

    Show(){
        guiHeight := A_ScreenHeight-142
        WinSetAlwaysOnTop 1, this.layerIndicatorGui
        this.layerIndicatorGui.show("x0 y" . guiHeight . " w50 h142 NoActivate")
    }

    Hide(){
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