#Requires AutoHotkey v2.0

; A menu can have submenus
; A menu can have items
; 
; EXAMPLE
; 
;             Menu
;             |
;             |-> Submenu
;             |    |
;             |    |-> Item
;             |    |-> Item
;             |    |-> Item
;             |
;             |-> Submenu
;                  |
;                  |-> Item
;                  |-> Item
;                  |-> Item
;
; EXAMPLE WITH A REAL WORLD APPLICATION
;           THEMES
;             |
;             |-> Dark 
;             |    |
;             |    |-> Black
;             |    |-> Night
;             |    |-> Darkish
;             |
;             |-> Light
;                  |
;                  |-> Burn Your Eyes
;                  |-> FlashBang
;                  |-> The Sun
; 
; TODO TO IMPLEMENT:
; Different behavior if the menu is a submenu or a menu
; Different behavior if the menu has a submenu or an item

class ImprovedMenu extends Menu{

    subMenus := Array()
    itemNames := Array()
    MenuItemsRadioLike := false

    __New(){
        ; super.__New()
    }

    SetMenuItemsRadioLikeOption(boolean){
        this.MenuItemsRadioLike := boolean
    }

    Add(MenuItemName := "", CallbackOrSubmenu := "", Options := ""){
        super.Add(MenuItemName, CallbackOrSubmenu, Options)

        ; TODO handle differently?
        if (Type(CallbackOrSubmenu) = "ImprovedMenu"){
            this.subMenus.Push(CallbackOrSubmenu)
        }
            
        this.itemNames.Push(MenuItemName)
    }

    UncheckAll(){
        Loop this.subMenus.Length{
            if (this.subMenus[A_index].hasSubmenus()){
                this.subMenus[A_index].UncheckAll()
            }
            else{
                this.subMenus[A_index].UnCheck()
            }
        }
        this.UnCheck()
    }

    Check(MenuItemName?){
        if IsSet(MenuItemName){
            if (this.MenuItemsRadioLike){
                this.UncheckAll()
                super.Check(MenuItemName)
            }
            else{

            }
            super.Check(MenuItemName)
        }
        else{
            Loop this.itemNames.Length{
                super.Check(this.itemNames[A_index])
            }
        }
    }

    UnCheck(MenuItemName?){
        if IsSet(MenuItemName){
            super.UnCheck(MenuItemName)
        }
        else{
            Loop this.itemNames.Length{
                super.UnCheck(this.itemNames[A_index])
            }
        }
    }

    hasSubmenus(){
        return this.subMenus.Length > 0
    }
}