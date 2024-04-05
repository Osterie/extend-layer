#Requires AutoHotkey v2.0

#Include "..\entity\Theme.ahk"
#Include <Util\MetaInfo\MetaInfoReading\ThemesReader>

; TODO set current theme here?
class Themes{
    
    static theSingleInstance := 0
    themes_ := Array()

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

    AddTheme(theme){
        if (Type(theme) != "Theme"){
            throw Error("The theme must be an instance of Theme.")
        }
        this.themes.Push(theme)
    }

    RemoveTheme(name){
        Loop this.themes_.Length{
            if (this.themes_[A_Index].ThemeName() = name){
                this.themes_.Delete(A_Index)
            }
        }
    }

    GetCategoryForTheme(name){
        category := ""
        Loop this.themes_.Length{
            if (this.themes_[A_Index].ThemeName() = name){
                category := this.themes_[A_Index].Category()
                break
            }
        }
        return category
    }

    GetThemeCategories(){
        themeCategories := Array()
        Loop this.themes_.Length{
            if (!themeCategories.Contains(this.themes_[A_Index].Category())){
                themeCategories.Push(this.themes_[A_Index].Category())
            }
        }
        return themeCategories
    }

    GetTheme(name){
        themeToReturn := ""
        Loop this.themes_.Length{
            if (this.themes_[A_Index].ThemeName() = name){
                themeToReturn := this.themes_[A_Index]
                break
            }
        }
        return themeToReturn
    }

    GetThemesForCategory(category){
        themesForCategory := Array()
        Loop this.themes_.Length{
            if (this.themes_[A_Index].Category() = category){
                themesForCategory.Push(this.themes_[A_Index])
            }
        }
        return themesForCategory
    }

    GetThemeNames(){
        themeNames := Array()
        Loop this.themes_.Length{
            themeNames.Push(this.themes_[A_Index].ThemeName())
        }
        return themeNames
    }

    GetThemeNamesForCategory(category){
        themeNames := Array()
        Loop this.themes_.Length{
            if (this.themes_[A_Index].Category() = category){
                themeNames.Push(this.themes_[A_Index].ThemeName())
            }
        }
        return themeNames
    }
}