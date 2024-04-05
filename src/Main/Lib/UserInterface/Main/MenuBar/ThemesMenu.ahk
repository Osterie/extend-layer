#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\Menus\ImprovedMenu>

; TODO can be a more general class? perhaps create a "imporvedMenu" class which creates menus with more methods, like uncheking all, checking all etc.
class ThemesMenu extends ImprovedMenu{

    __New(callback){
        this.callback := callback
        this.SetMenuItemsRadioLikeOption(true)
        this.CreateMenuBar()
        this.CheckCurrentThemeMenu()
    }

    ; TODO modularize
    CreateMenuBar(){

        themeCategories := Themes.getInstance().GetThemeCategories()
        
        Loop themeCategories.Length{
            themeCategoryName := themeCategories[A_index] 
            themeCategoriesSubMenu := this.CreateThemeCategoriesSubMenu(themeCategoryName)
            this.Add(themeCategoryName, themeCategoriesSubMenu)
        }
    }

    CreateThemeCategoriesSubMenu(themeCategoryName){
        themeCategoriesSubMenu := ImprovedMenu()
        themeCategoriesSubMenu.SetMenuItemsRadioLikeOption(true)

        themesForCategory := Themes.getInstance().GetThemeNamesForCategory(themeCategoryName)

        Loop themesForCategory.Length{
            subMenuItem := themesForCategory[A_index]
            themeCategoriesSubMenu.Add(subMenuItem, (themeClicked, ItemPos, themeCategoriesSubMenu) => this.HandleThemeClicked(themeClicked, ItemPos, themeCategoriesSubMenu))
        }

        return themeCategoriesSubMenu
    }

    CheckCurrentThemeMenu(){
        currentTheme := FilePaths.GetCurrentTheme()
        currentThemeCategory := Themes.getInstance().GetCategoryForTheme(currentTheme)

        this.Check(currentThemeCategory)
        this.CheckChildren(currentTheme)
    }
    
    HandleThemeClicked(themeClicked, ItemPos, themeCategoriesSubMenu){

        ; themeCategoryClicked := Themes.getInstance().GetCategoryForTheme(themeClicked)

        ; this.Check(themeCategoryClicked)
        ; themeCategoriesSubMenu.Check(themeClicked)

        FilePaths.SetCurrentTheme(themeClicked)
        this.CheckCurrentThemeMenu()
        this.callBack()
    }
}