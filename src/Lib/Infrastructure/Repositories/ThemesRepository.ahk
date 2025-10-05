#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

#Include <DataModels\AppData\Themes\Theme>
#Include <DataModels\AppData\Themes\Themes>

#Include <Infrastructure\Parsers\ThemesParser>

#Include <Shared\FilePaths>
#Include <Shared\Logger>



class ThemesRepository {
    
    static instance := false
    Themes := Themes()
    Logger := Logger.getInstance()
    PATH_TO_THEMES := FilePaths.getPathToThemes()

    __New() {
        this.readThemes()
    }

    static getInstance() {
        if ( IsObject( ThemesRepository.instance ) = false ) {
            ThemesRepository.instance := ThemesRepository()
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

    readThemes(){
        parser := ThemesParser()
        this.Themes := parser.readThemes(this.PATH_TO_THEMES)
    }
}