#Requires AutoHotkey v2.0

class Theme{

    CaptionColor_ := ""
    CaptionFontColor_ := ""
    BackgroundColor_ := ""
    TextColor_ := ""
    ControlColor_ := ""

    __New(BackgroundColor, TextColor, ControlColor, CaptionColor := "ffffff", CaptionFontColor := "000000"){
        this.BackgroundColor_ := BackgroundColor
        this.TextColor_ := TextColor
        this.ControlColor_ := ControlColor
        this.CaptionColor_ := CaptionColor
        this.CaptionFontColor_ := CaptionFontColor
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

    CaptionFontColor(){
        return this.CaptionFontColor_
    }
}