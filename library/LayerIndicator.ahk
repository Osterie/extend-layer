#Requires AutoHotkey v1.1.36.02

Class LayerIndicator{

    indicatorColor := ""
    layer := 0

    __New(layer, color) {
        this.layer := layer
        this.indicatorColor := color
    }

    createLayerIndicator(){
        Gui, % this.layer . ": new"
        Gui, % this.layer . ": +AlwaysOnTop -Caption +ToolWindow"
        Gui, % this.layer . ": Color", % this.indicatorColor
    }

    destroy(){
        Gui, % this.layer . ": destroy"
    }

    show(){
        guiHeight := A_ScreenHeight-142
        Gui, % this.layer . ": show", x0 y%guiHeight% w50 h142 NoActivate
    }

    hide(){
        Gui, % this.layer . ": hide"
    }

    setLayerColor(color){
        this.indicatorColor := color
        Gui, % this.layer . ": Color", % color
    }

    getLayerColor(){
        return this.indicatorColor
    }
}