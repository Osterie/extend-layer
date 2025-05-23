#Requires Autohotkey v2.0

#Include <Actions\Action>

Class LayerIndicator extends Action{ 

    indicatorColor := ""
    layer := 0
    layerIndicatorGui := 0
    isTransparent := 0
    monitor := "default"

    __New(layer, color, transparent := 0, monitor := "default"){
        this.layer := layer
        this.indicatorColor := color
        this.isTransparent := transparent
        this.monitor := monitor
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
        if (this.monitor = "default"){
            guiHeight := A_ScreenHeight-142
            WinSetAlwaysOnTop 1, this.layerIndicatorGui
            this.layerIndicatorGui.show("x0 y" . guiHeight . " w50 h142 NoActivate")
        }
        else{
            this.ShowOnOtherMonitor()
        }
    }

    ShowOnOtherMonitor(){
        if (!IsInteger(this.monitor)){
            MsgBox("Invalid monitor number: " . this.monitor)
            return
        }
        if (this.monitor < 1 || this.monitor > MonitorGetCount()){
            MsgBox("Invalid monitor number: " . this.monitor)
            return
        }

        MonitorGetWorkArea this.monitor, &workLeft, &workTop, &workRight, &workBottom

        guiHeight := workBottom-142
        WinSetAlwaysOnTop 1, this.layerIndicatorGui
        this.layerIndicatorGui.show("x" . workLeft . " y" . guiHeight . " w50 h142 NoActivate")
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