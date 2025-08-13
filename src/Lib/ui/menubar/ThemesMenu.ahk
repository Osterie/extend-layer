#Requires AutoHotkey v2.0

#Include <ui\util\Menus\ImprovedMenu>

#Include <Infrastructure\Repositories\ThemesRepository>

class ThemesMenu extends ImprovedMenu{

    ThemesRepository := ThemesRepository.getInstance()

    __New(callback){
        this.callback := callback
        this.SetMenuItemsRadioLikeOption(true)
        this.CreateMenuBar()
        this.CheckCurrentThemeMenu()
    }

    CreateMenuBar(){
        themeCategories := this.ThemesRepository.GetThemeCategories()
        
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
        themesForCategory := this.ThemesRepository.GetThemeNamesForCategory(themeCategoryName)

        Loop themesForCategory.Length{
            subMenuItem := themesForCategory[A_index]
            themeCategoriesSubMenu.Add(subMenuItem, (themeClicked, *) => this.HandleThemeClicked(themeClicked))
        }
    }

    CheckCurrentThemeMenu(){
        currentTheme := this.ThemesRepository.getCurrentTheme()
        currentThemeCategory := this.ThemesRepository.GetCategoryForTheme(currentTheme)

        this.Check(currentThemeCategory)
        this.CheckChildren(currentTheme)
    }

    HandleThemeClicked(themeClicked){
        this.ThemesRepository.setCurrentTheme(themeClicked)
        this.CheckCurrentThemeMenu()
        this.callBack()
    }
}