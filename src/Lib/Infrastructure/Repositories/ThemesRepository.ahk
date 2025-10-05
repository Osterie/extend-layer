#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>

#Include <DataModels\AppData\Themes\Theme>
#Include <DataModels\AppData\Themes\Themes>

; TODO set current theme here?
class ThemesRepository {
    
    static instance := false
    pathToThemes := ""
    Themes := Themes()

    __New(pathToThemes := FilePaths.getPathToThemes()) {
        this.pathToThemes := pathToThemes
        this.ReadThemes()
    }

    static getInstance(pathToThemes := FilePaths.getPathToThemes()) {
        if ( IsObject( ThemesRepository.instance ) = false ) {
            ThemesRepository.instance := ThemesRepository(pathToThemes)
        }
        return ThemesRepository.instance
    }

    GetCategoryForTheme(name){
        return this.Themes.GetCategoryForTheme(name)
    }

    GetThemeCategories(){
        return this.Themes.GetThemeCategories()
    }

    GetTheme(name){
        return this.Themes.GetTheme(name)
    }

    GetThemesForCategory(category){
        return this.Themes.GetThemesForCategory(category)
    }

    GetThemeNames(){
        return this.Themes.GetThemeNames()
    }

    GetThemeNamesForCategory(category){
        return this.Themes.GetThemeNamesForCategory(category)
    }

    setCurrentTheme(currentTheme) {
        MetaInfo.setCurrentTheme(currentTheme)
    }

    getCurrentTheme() {
        return MetaInfo.getCurrentTheme()
    }

    getDefaultTheme() {
        return MetaInfo.getDefaultTheme()
    }

    ReadThemes(){

        if (!FileExist(this.pathToThemes)) {
            throw Error("Themes file does not exist at: " . this.pathToThemes)
        }

        jsonStringThemes := FileRead(this.pathToThemes, "UTF-8")
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
                    this.Themes.AddTheme(themeToAdd)
                }
            }
        }
    }
}