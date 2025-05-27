#Requires Autohotkey v2.0

#Include <Actions\Action>
#Include <Util\ImageSizeFinder>


class LayerIndicator extends Action {

    indicatorColor := ""
    layer := 0
    layerIndicatorGui := 0
    image := ""
    isTransparent := 0
    monitor := MonitorGetPrimary()

    storedWidth := 0
    storedHeight := 0

    __New(layer, color, transparent := 0, image := "", monitor := MonitorGetPrimary()) {
        this.layer := layer
        this.indicatorColor := color
        this.isTransparent := transparent
        this.image := image
        this.monitor := monitor
    }

    ; TODO create settings for changing the location, color, size, and such of the layer indicator...
    createLayerIndicator() {
        this.layerIndicatorGui := Gui()
        this.layerIndicatorGui.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.layerIndicatorGui.BackColor := this.indicatorColor
        this.addImageControl()
    }
    
    addImageControl() {
        SplitPath(this.image, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt, &OutDrive)

        if (OutExtension = "") {
            this.useDefaultIndicatorSize() ; Fallback to default size if image loading fails
        }
        else if (OutExtension = "gif" || OutExtension = "svg") {
            try{
                imageSize := ImageSizeFinder.ImageSize(this.image)
                width := imageSize[1]
                height := imageSize[2]
                html := "<body style='margin:0'><img src='" this.image "' style='width:100%; height:100%; object-fit:contain;' /></body>"
                this.layerIndicatorGui.Add("ActiveX", "w" . width . " h" . height, "mshtml:" . html)
            }
            catch Error as e{
                this.useDefaultIndicatorSize() ; Fallback to default size if image loading fails
            }
        }
        else{
            try {
                this.layerIndicatorGui.Add("Picture", "AltSubmit", this.image)
            }
            catch Error as e {
                ; If no image is proviced, this will be used.
                this.useDefaultIndicatorSize() ; Fallback to default size if image loading fails
            }
        }
    }

    useDefaultIndicatorSize(){
        this.setIndicatorWidth(50) ; Default width if no image is provided
        this.setIndicatorHeight(140) ; Default height if no image is provided
    }

    Destroy() {
        this.layerIndicatorGui.destroy()
    }

    Show(x := 0, y := A_ScreenHeight - this.getIndicatorHeight(), w := this.getIndicatorWidth(), h := this.getIndicatorHeight()) {
        if (this.isTransparent == 1) {
            return
        }
        WinSetAlwaysOnTop 1, this.layerIndicatorGui
        this.layerIndicatorGui.show("x" . x . " y" . y . " w" . w . " h" . h . " NoActivate")
    }

    Hide() {
        this.layerIndicatorGui.hide()
    }

    setLayerColor(color) {
        this.indicatorColor := color
        this.layerIndicatorGui.Color(color)
    }

    getLayerColor() {
        return this.indicatorColor
    }

    getIndicatorWidth() {
        if (this.storedWidth != 0) {
            return this.storedWidth
        }
        this.calculateGuiDimensions()
        return this.storedWidth
    }

    setIndicatorWidth(width) {
        this.storedWidth := width
    }

    getIndicatorHeight() {
        if (this.storedHeight != 0) {
            return this.storedHeight
        }
        this.calculateGuiDimensions()
        return this.storedHeight
    }

    setIndicatorHeight(height) {
        this.storedHeight := height
    }

    calculateGuiDimensions() {
        if (this.storedWidth != 0 && this.storedHeight != 0) {
            return [this.storedWidth, this.storedHeight]
        }
        WinSetTransparent(0, this.layerIndicatorGui)
        this.layerIndicatorGui.show("NoActivate")
        this.layerIndicatorGui.GetPos(&x, &y, &w, &h)
        this.storedWidth := w
        this.storedHeight := h
        this.layerIndicatorGui.hide()
        WinSetTransparent(255, this.layerIndicatorGui)
        return [this.storedWidth, this.storedHeight]
    }
}
