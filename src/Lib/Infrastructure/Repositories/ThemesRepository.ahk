#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>

#Include <DataModels\AppData\Themes\Theme>
#Include <DataModels\AppData\Themes\Themes>
#Include <Shared\Logger>

class ThemesRepository {
    
    static instance := false
    pathToThemes := ""
    Themes := Themes()
    Logger := Logger.getInstance()

    __New(pathToThemes := FilePaths.getPathToThemes()) {
        this.pathToThemes := pathToThemes
        this.readThemes()
    }

    static getInstance(pathToThemes := FilePaths.getPathToThemes()) {
        if ( IsObject( ThemesRepository.instance ) = false ) {
            ThemesRepository.instance := ThemesRepository(pathToThemes)
        }
        return ThemesRepository.instance
    }

    getTheme(name){
        return this.Themes.getTheme(name)
    }

    getCurrentTheme(){
        theme := this.getTheme(MetaInfo.getCurrentTheme())
        if (theme = ""){
            this.Logger.logError("Current theme set in meta.ini does not exist. Setting to default theme.")
            MsgBox("Current theme set in meta.ini (" . MetaInfo.getCurrentTheme() . ") does not exist. Setting to default theme (" . MetaInfo.getDefaultTheme() . ").")
            theme := this.getDefaultTheme()
        }
        return theme
    }

    getDefaultTheme() {
        theme := this.getTheme(MetaInfo.getDefaultTheme())
        if (theme = ""){
            this.Logger.logError("Failed to load any theme")
            Throw Error("Failed to load any theme")
        }

        return theme
    }

    getCategoryForTheme(name){
        return this.Themes.getCategoryForTheme(name)
    }

    getThemeCategories(){
        return this.Themes.getThemeCategories()
    }

    getThemesForCategory(category){
        return this.Themes.getThemesForCategory(category)
    }

    getThemeNames(){
        return this.Themes.getThemeNames()
    }

    getThemeNamesForCategory(category){
        return this.Themes.getThemeNamesForCategory(category)
    }

    ; TODO create ThemesParser class.
    readThemes(){

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