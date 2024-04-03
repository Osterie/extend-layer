#Requires AutoHotkey v2.0

; TODO can be a more general class? perhaps create a "imporvedMenu" class which creates menus with more methods, like uncheking all, checking all etc.
class ThemesMenu extends Menu{

    __New(callback){
        this.callback := callback
        this.themeCategoryMenus := Array()
        this.CreateMenuBar()
    }


    ; TODO modularize
    CreateMenuBar(){


        themesInstance := Themes.getInstance()
        themeCategories := themesInstance.GetThemeCategories()
        currentTheme := FilePaths.GetCurrentTheme()
        currentThemeCategory := themesInstance.GetCategoryForTheme(currentTheme)
        
        Loop themeCategories.Length{
            themeCategoriesSubMenu := Menu()

            themeCategoryName := themeCategories[A_index]
            themesForCategory := themesInstance.GetThemeNamesForCategory(themeCategoryName)

            Loop themesForCategory.Length{
                subMenuItem := themesForCategory[A_index]
                themeCategoriesSubMenu.Add(subMenuItem, (ItemName, ItemPos, MyMenuBar) => this.HandleThemeClicked(ItemName, ItemPos, MyMenuBar))
                ; themeCategoriesSubMenu.Add(subMenuItem, this.HandleThemeClicked)
                if (currentTheme = subMenuItem){
                    themeCategoriesSubMenu.Check(subMenuItem)
                }
            }

            this.themeCategoryMenus.Push(themeCategoriesSubMenu)
            this.Add(themeCategoryName, themeCategoriesSubMenu)
            if (currentThemeCategory = themeCategoryName){
                this.Check(themeCategoryName)
            }
        }

    }

    HandleThemeClicked(ItemName, ItemPos, MyMenuBar){

        themesInstance := Themes.getInstance()
        currentTheme := FilePaths.GetCurrentTheme()
        currentThemeCategory := themesInstance.GetCategoryForTheme(currentTheme)

        newTheme := themesInstance.GetCategoryForTheme(ItemName)

        this.UnCheck(currentThemeCategory)
        this.Check(newTheme)

        Loop this.themeCategoryMenus.Length{
            try{
                this.themeCategoryMenus[A_index].UnCheck(currentTheme)

            }
        }
        MyMenuBar.Check(ItemName)
        FilePaths.SetCurrentTheme(ItemName)
        this.callBack()
    }

    GetMenu(){
        return this
    }

}