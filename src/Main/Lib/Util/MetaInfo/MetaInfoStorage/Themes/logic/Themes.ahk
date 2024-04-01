#Requires AutoHotkey v2.0

#Include "..\entity\Theme.ahk"
#Include <Util\MetaInfo\MetaInfoReading\ThemesReader>

class Themes{
    
    static theSingleInstance := 0
    themes_ := Map()

    __New(){
        themesReader_ := ThemesReader()
        this.themes_ := themesReader_.ReadThemes()
    }

    static getInstance() {
        if ( IsObject( Themes.theSingleInstance ) = 0 ) {
            Themes.theSingleInstance := Themes()
        }
        return Themes.theSingleInstance
    }

    AddTheme(name, theme){
        if (Type(theme) != "Theme"){
            throw Error("The theme must be an instance of Theme.")
        }
        this.themes_[name] := theme
    }

    RemoveTheme(name){
        this.themes_.Delete(name)
    }

    GetTheme(name){
        return this.themes_[name]
    }

    GetThemeNames(){
        return this.themes_.Keys()
    }

}