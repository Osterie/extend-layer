#Requires AutoHotkey v2.0

#Include <DataModels\AppData\Themes\Theme>

; TODO set current theme here?
class Themes{
    
    themes := Array()

    __New(){
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