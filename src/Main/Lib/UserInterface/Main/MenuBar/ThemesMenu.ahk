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
            themeCategoriesSubMenu := this.CreateThemeCategoriesSubMenu(themeCategories[A_index])
            this.Add(themeCategoryName, themeCategoriesSubMenu)
        }
    }

    CreateThemeCategoriesSubMenu(themeCategoryName){
        themeCategoriesSubMenu := ImprovedMenu()
        themeCategoriesSubMenu.SetMenuItemsRadioLikeOption(true)

        themesForCategory := Themes.getInstance().GetThemeNamesForCategory(themeCategoryName)

        Loop themesForCategory.Length{
            subMenuItem := themesForCategory[A_index]
            themeCategoriesSubMenu.Add(subMenuItem, (themeClicked, ItemPos, MenuClicked) => this.HandleThemeClicked(themeClicked, ItemPos, MenuClicked))
        }

        return themeCategoriesSubMenu
    }


    CheckCurrentThemeMenu(){
        themesInstance := Themes.getInstance()
        themeCategories := themesInstance.GetThemeCategories()
        currentTheme := FilePaths.GetCurrentTheme()

        currentThemeCategory := themesInstance.GetCategoryForTheme(currentTheme)
        this.Check(currentThemeCategory)
        this.CheckChildren(currentTheme)
    }

    HandleThemeClicked(themeClicked, ItemPos, MenuClicked){

        themesInstance := Themes.getInstance()
        currentTheme := FilePaths.GetCurrentTheme()

        newTheme := themesInstance.GetCategoryForTheme(themeClicked)

        this.Check(newTheme)
        MenuClicked.Check(themeClicked)

        FilePaths.SetCurrentTheme(themeClicked)
        this.callBack()
    }
}