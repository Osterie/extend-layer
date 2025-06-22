#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON\JXON>

#Include <Shared\FilePaths>

#Include <DataModels\AppData\Themes\Theme>
#Include <DataModels\AppData\Themes\Themes>

class ThemesReader{

    PATH_TO_THEMES := ""
    themes := Array()

    __New(){
        this.PATH_TO_THEMES := FilePaths.GetThemes()
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
        
        For themeCategory, categoryThemes in themesJsonInfo{
            Loop categoryThemes.Length{
                
                themeInformationMap := categoryThemes[A_Index]
    
                ; The map has only one key because of the way the json is created
                For themeName, themeInformation in themeInformationMap{
                    BackgroundColor := themeInformation["BackgroundColor"]
                    TextColor := themeInformation["TextColor"]
                    ControlColor := themeInformation["ControlColor"]
                    CaptionColor := themeInformation["CaptionColor"]
                    CaptionFontColor := themeInformation["CaptionFontColor"]
    
                    themeToAdd := Theme(themeName, themeCategory, BackgroundColor, TextColor, ControlColor, CaptionColor, CaptionFontColor)
                    this.themes.Push(themeToAdd)
                }
            }
        }
        
        return this.themes
    }
}