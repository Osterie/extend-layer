#Requires AutoHotkey v2.0

class GuiTheme{

    CaptionColor_ := ""
    BackgroundColor_ := ""
    TextColor_ := ""
    ControlColor_ := ""

    __New(BackgroundColor_, TextColor_, ControlColor_, CaptionColor_ := "ffffff"){
        this.BackgroundColor_ := BackgroundColor_
        this.TextColor_ := TextColor_
        this.ControlColor_ := ControlColor_
        this.CaptionColor_ := CaptionColor_
    }

    BackgroundColor(){
        return this.BackgroundColor_
    }

    TextColor(){
        return this.TextColor_
    }

    ControlColor(){
        return this.ControlColor_
    }

    CaptionColor(){
        return this.CaptionColor_
    }
}