#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\Menus\ImprovedMenu>

; TODO can be a more general class? perhaps create a "imporvedMenu" class which creates menus with more methods, like uncheking all, checking all etc.
class ThemesMenu extends ImprovedMenu{

    __New(callback){
        this.callback := callback
        this.SetMenuItemsRadioLikeOption(true)
        this.CreateMenuBar()
    }

    ; TODO modularize
    CreateMenuBar(){

        themesInstance := Themes.getInstance()
        themeCategories := themesInstance.GetThemeCategories()
        currentTheme := FilePaths.GetCurrentTheme()
        
        Loop themeCategories.Length{
            
            themeCategoriesSubMenu := ImprovedMenu()
            themeCategoriesSubMenu.SetMenuItemsRadioLikeOption(true)
            
            themeCategoryName := themeCategories[A_index]
            themesForCategory := themesInstance.GetThemeNamesForCategory(themeCategoryName)

            Loop themesForCategory.Length{
                subMenuItem := themesForCategory[A_index]
                themeCategoriesSubMenu.Add(subMenuItem, (themeClicked, ItemPos, MenuClicked) => this.HandleThemeClicked(themeClicked, ItemPos, MenuClicked))
                if (currentTheme = subMenuItem){
                    msgbox("check")
                    themeCategoriesSubMenu.Check(subMenuItem)
                }
            }
            this.Add(themeCategoryName, themeCategoriesSubMenu)
        }
        
        currentThemeCategory := themesInstance.GetCategoryForTheme(currentTheme)
        this.Check(currentThemeCategory)
    }

    HandleThemeClicked(themeClicked, ItemPos, MenuClicked){

        themesInstance := Themes.getInstance()
        currentTheme := FilePaths.GetCurrentTheme()

        newTheme := themesInstance.GetCategoryForTheme(themeClicked)

        ; Radio button like. Uncheck all and then check the super menu and its submenues down to the path.
        ; this.UncheckAll()
        this.Check(newTheme)
        MenuClicked.Check(themeClicked)

        FilePaths.SetCurrentTheme(themeClicked)
        this.callBack()
    }
}