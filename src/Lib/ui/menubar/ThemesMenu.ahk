#Requires AutoHotkey v2.0

#Include <ui\util\Menus\ImprovedMenu>

#Include <Infrastructure\Repositories\ThemesRepository>

#Include <Shared\MetaInfo>

class ThemesMenu extends ImprovedMenu{

    ThemesRepository := ThemesRepository.getInstance()

    __New(callback){
        this.callback := callback
        this.setMenuItemsRadioLikeOption(true)
        this.createMenuBar()
        this.checkCurrentThemeMenu()
    }

    createMenuBar(){
        themeCategories := this.ThemesRepository.getThemeCategories()
        
        Loop themeCategories.Length{
            themeCategoryName := themeCategories[A_index] 
            themeCategoriesSubMenu := this.createThemeCategoriesSubMenu(themeCategoryName)
            this.add(themeCategoryName, themeCategoriesSubMenu)
        }
    }

    createThemeCategoriesSubMenu(themeCategoryName){
        themeCategoriesSubMenu := ImprovedMenu()
        themeCategoriesSubMenu.setMenuItemsRadioLikeOption(true)
        
        this.setThemeCategoriesSubMenuItems(themeCategoriesSubMenu, themeCategoryName)
        
        return themeCategoriesSubMenu
    }

    setThemeCategoriesSubMenuItems(themeCategoriesSubMenu, themeCategoryName){
        themesForCategory := this.ThemesRepository.getThemeNamesForCategory(themeCategoryName)

        Loop themesForCategory.Length{
            subMenuItem := themesForCategory[A_index]
            themeCategoriesSubMenu.add(subMenuItem, (themeClicked, *) => this.handleThemeClicked(themeClicked))
        }
    }

    checkCurrentThemeMenu(){
        currentTheme := MetaInfo.getCurrentTheme()
        currentThemeCategory := this.ThemesRepository.getCategoryForTheme(currentTheme)

        try{
            this.check(currentThemeCategory)
        }
        catch Error as e{
            MsgBox("Error checking current theme category in menu. The current theme, found in meta.ini (" . currentTheme . "), might not exist anymore. Error details: " . e.Message)
        }
        this.checkChildren(currentTheme)
    }

    handleThemeClicked(themeClicked){
        MetaInfo.setCurrentTheme(themeClicked)
        this.checkCurrentThemeMenu()
        this.callBack()
    }
}