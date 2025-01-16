#Requires AutoHotkey v2.0

#Include <ui\Main\util\Menus\ImprovedMenu>

class ThemesMenu extends ImprovedMenu{

    __New(callback){
        this.callback := callback
        this.SetMenuItemsRadioLikeOption(true)
        this.CreateMenuBar()
        this.CheckCurrentThemeMenu()
    }

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
        
        this.SetThemeCategoriesSubMenuItems(themeCategoriesSubMenu, themeCategoryName)
        
        return themeCategoriesSubMenu
    }

    SetThemeCategoriesSubMenuItems(themeCategoriesSubMenu, themeCategoryName){
        themesForCategory := Themes.getInstance().GetThemeNamesForCategory(themeCategoryName)

        Loop themesForCategory.Length{
            subMenuItem := themesForCategory[A_index]
            themeCategoriesSubMenu.Add(subMenuItem, (themeClicked, *) => this.HandleThemeClicked(themeClicked))
        }
    }

    CheckCurrentThemeMenu(){
        currentTheme := FilePaths.GetCurrentTheme()
        currentThemeCategory := Themes.getInstance().GetCategoryForTheme(currentTheme)

        this.Check(currentThemeCategory)
        this.CheckChildren(currentTheme)
    }

    HandleThemeClicked(themeClicked){
        FilePaths.SetCurrentTheme(themeClicked)
        this.CheckCurrentThemeMenu()
        this.callBack()
    }
}