#Requires Autohotkey v2.0

#Include <Actions\Action>

Class LayerIndicator extends Action{ 

    indicatorColor := ""
    layer := 0
    layerIndicatorGui := 0
    isTransparent := 0
    monitor := MonitorGetPrimary()

    __New(layer, color, transparent := 0, monitor := MonitorGetPrimary()){
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

    Show(x := 0, y := A_ScreenHeight-142, w := 50, h := 142){
        
        if (this.monitor = MonitorGetPrimary()){
            WinSetAlwaysOnTop 1, this.layerIndicatorGui
            this.layerIndicatorGui.show("x" . x . " y" . y . " w" . w . " h" . h . " NoActivate")
        }
        else{
            this.ShowOnOtherMonitor(x, y, w, h)
        }
    }

    ShowOnOtherMonitor(x := 0, y := A_ScreenHeight-142, w := 50, h := 142){
        if (!IsInteger(this.monitor)){
            MsgBox("Invalid monitor number: " . this.monitor)
            return
        }
        if (this.monitor < 1 || this.monitor > MonitorGetCount()){
            MsgBox("Invalid monitor number: " . this.monitor)
            return
        }

        MonitorGetWorkArea this.monitor, &workLeft, &workTop, &workRight, &workBottom

        WinSetAlwaysOnTop 1, this.layerIndicatorGui
        this.layerIndicatorGui.show("x" . x . " y" . y . " w" . w . " h" . h . " NoActivate")

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