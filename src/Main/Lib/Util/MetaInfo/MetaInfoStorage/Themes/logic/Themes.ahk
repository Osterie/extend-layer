#Requires AutoHotkey v2.0

#Include "..\entity\Theme.ahk"
#Include <Util\MetaInfo\MetaInfoReading\ThemesReader>

; TODO set current theme here?
class Themes{
    
    static instance := false
    themes := Array()

    __New(){
        themesReader_ := ThemesReader()
        this.themes := themesReader_.ReadThemes()
    }

    static getInstance() {
        if ( IsObject( Themes.instance ) = false ) {
            Themes.instance := Themes()
        }
        return Themes.instance
    }

    AddTheme(theme){
        if (Type(theme) != "Theme"){
            throw Error("The theme must be an instance of Theme.")
        }
        this.themes.Push(theme)
    }

    RemoveTheme(name){
        Loop this.themes.Length{
            if (this.themes[A_Index].ThemeName() = name){
                this.themes.Delete(A_Index)
            }
        }
    }

    GetCategoryForTheme(name){
        category := ""
        Loop this.themes.Length{
            if (this.themes[A_Index].ThemeName() = name){
                category := this.themes[A_Index].Category()
                break
            }
        }
        return category
    }

    GetThemeCategories(){
        themeCategories := Array()
        Loop this.themes.Length{
            if (!themeCategories.Contains(this.themes[A_Index].Category())){
                themeCategories.Push(this.themes[A_Index].Category())
            }
        }
        return themeCategories
    }

    GetTheme(name){
        themeToReturn := ""
        Loop this.themes.Length{
            if (this.themes[A_Index].ThemeName() = name){
                themeToReturn := this.themes[A_Index]
                break
            }
        }
        return themeToReturn
    }

    GetThemesForCategory(category){
        themesForCategory := Array()
        Loop this.themes.Length{
            if (this.themes[A_Index].Category() = category){
                themesForCategory.Push(this.themes[A_Index])
            }
        }
        return themesForCategory
    }

    GetThemeNames(){
        themeNames := Array()
        Loop this.themes.Length{
            themeNames.Push(this.themes[A_Index].ThemeName())
        }
        return themeNames
    }

    GetThemeNamesForCategory(category){
        themeNames := Array()
        Loop this.themes.Length{
            if (this.themes[A_Index].Category() = category){
                themeNames.Push(this.themes[A_Index].ThemeName())
            }
        }
        return themeNames
    }
}