#Requires AutoHotkey v2.0

#Include "..\..\JsonParsing\JXON\JXON.ahk"

#Include <Util\MetaInfo\MetaInfoStorage\Themes\entity\Theme>
#Include <Util\MetaInfo\MetaInfoStorage\Themes\logic\Themes>



class ThemesReader{

    PATH_TO_THEMES := ""
    Themes_ := Map()

    __New(){
        this.PATH_TO_THEMES := FilePaths.GetThemes()
        ; this.Themes_ := Themes()
    }

    ReadThemes(){
        try{
            jsonStringThemes := FileRead(this.PATH_TO_THEMES, "UTF-8")
        }
        catch{
            throw ValueError("Could not read the file: " . this.PATH_TO_THEMES)
        }
        themesJsonInfo := jxon_load(&jsonStringThemes)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For themeName , themeInformation in themesJsonInfo{
            BackgroundColor := themeInformation["BackgroundColor"]
            TextColor := themeInformation["TextColor"]
            ControlColor := themeInformation["ControlColor"]
            CaptionColor := themeInformation["CaptionColor"]
            CaptionFontColor := themeInformation["CaptionFontColor"]

            themeToAdd := Theme(BackgroundColor, TextColor, ControlColor, CaptionColor, CaptionFontColor)
            this.Themes_[themeName] := themeToAdd
        }
        return this.Themes_
    }
}