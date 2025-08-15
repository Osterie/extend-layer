#Requires Autohotkey v2.0

#Include <Actions\HotkeyAction>
#Include <Util\ImageSizeFinder>
#Include <Util\GuiSizeFinder>
#Include <Util\FilePath>
#Include <Util\UrlUtils>

; TODO do not use "NONE" in the ini files for layer image, use "" instead if possible.
class LayerIndicator extends HotkeyAction {

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

    destroy() {
        this.layerIndicatorGui.destroy()
    }

    createLayerIndicator() {
        this.layerIndicatorGui := Gui()
        this.layerIndicatorGui.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.layerIndicatorGui.BackColor := this.indicatorColor
        this.addImageControl()
        this.calculateGuiDimensions()
    }
    
    addImageControl() {
        if (this.image == "NONE" || this.image == "") {
            this.useDefaultIndicatorSize()
            return
        }

        if (UrlUtils.isUrl(this.image)) {
            this.addImageFromUrl()
        }
        else{
            this.addImageFromFile()
        }
    }

    addImageFromUrl() {
        html := "<body style='margin:0'><img src='" this.image "' style='width:100%; height:100%; object-fit:contain;' /></body>"
        activeXControl := this.layerIndicatorGui.Add("ActiveX", "w100 h100", "mshtml:" . html)
    }

    addImageFromFile() {
        try{
            File := FilePath(this.image)
        }
        catch Error as e {
            MsgBox("Invalid image path, using default settings: " . e.Message . this.image)
            this.useDefaultIndicatorSize() ; Fallback to default size if image path is invalid
            return
        }

        imageFileExtension := File.getExtension()

        if (imageFileExtension = "") {
            MsgBox("Image file extension is missing, using default settings: " . this.image)
            this.useDefaultIndicatorSize()
        }
        else  {
            try{
                imageSize := ImageSizeFinder.ImageSize(this.image)
                width := imageSize[1]
                height := imageSize[2]
                html := "<body style='margin:0'><img src='" this.image "' style='width:100%; height:100%; object-fit:contain;' /></body>"
                this.layerIndicatorGui.Add("ActiveX", "w" . width . " h" . height, "mshtml:" . html)
            }
            catch Error as e{
                MsgBox("Failed to load image, using default settings: " . e.Message . this.image)
                this.useDefaultIndicatorSize() ; Fallback to default size if image loading fails
            }
        }
    }

    useDefaultIndicatorSize(){
        this.setIndicatorWidth(50) ; Default width if no image is provided
        this.setIndicatorHeight(140) ; Default height if no image is provided
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
        this.storedWidth := GuiSizeFinder.calculateGuiDimensions(this.layerIndicatorGui)[1]
        return this.storedWidth
    }
    
    setIndicatorWidth(width) {
        this.storedWidth := width
    }
    
    getIndicatorHeight() {
        if (this.storedHeight != 0) {
            return this.storedHeight
        }
        this.storedHeight := GuiSizeFinder.calculateGuiDimensions(this.layerIndicatorGui)[2]
        return this.storedHeight
    }

    setIndicatorHeight(height) {
        this.storedHeight := height
    }

    calculateGuiDimensions() {
        if (this.storedWidth != 0 && this.storedHeight != 0) {
            return
        }

        guiSizes := GuiSizeFinder.calculateGuiDimensions(this.layerIndicatorGui)
        this.setIndicatorWidth(guiSizes[1])
        this.setIndicatorHeight(guiSizes[2])
    }
}
