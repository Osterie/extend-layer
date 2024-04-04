#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\Menus\ImprovedMenu>

; TODO can be a more general class? perhaps create a "imporvedMenu" class which creates menus with more methods, like uncheking all, checking all etc.
class ThemesMenu extends ImprovedMenu{

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
            
            themeCategoriesSubMenu := ImprovedMenu()
            
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

            ; COntains darkish, lightish, colorful
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

        
        this.UncheckAll()
        ; this.UnCheck(currentThemeCategory)
        MyMenuBar.Check(ItemName)
        this.Check(newTheme)
        FilePaths.SetCurrentTheme(ItemName)
        this.callBack()
    }

    ; UncheckAll(menu_){
    ;     currentTheme := FilePaths.GetCurrentTheme()
    ;     Loop menu_.Length{
    ;         try{
    ;             menu_[A_index].UnCheck(currentTheme)
    ;         }
    ;     }
    ; }

    GetMenu(){
        return this
    }

}