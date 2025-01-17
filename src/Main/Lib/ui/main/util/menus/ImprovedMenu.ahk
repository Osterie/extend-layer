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

    Add(MenuItemName := unset, CallbackOrSubmenu := unset, Options := unset) {
        ; Initialize an empty array to collect arguments to pass to super.Add
        params := Array()
    
        ; Add only set parameters to the params array
        if IsSet(MenuItemName){
            params.Push(MenuItemName)
        }
        if IsSet(CallbackOrSubmenu){
            params.Push(CallbackOrSubmenu)
        }
        if IsSet(Options){
            params.Push(Options)
        }
    
        super.Add(params*)
    
        if IsSet(MenuItemName){
            this.itemNames.Push(MenuItemName)
        }
    
        if (Type(CallbackOrSubmenu) = "ImprovedMenu"){
            this.subMenus.Push(CallbackOrSubmenu)
        }
    }

    Check(MenuItemName?){
        if (this.MenuItemsRadioLike){
            this.CheckRadio(MenuItemName?)
        }
        else{
            this.CheckDefault(MenuItemName?)
        }
    }

    ; Private method
    CheckRadio(MenuItemName?){
        if IsSet(MenuItemName){
            try{
                this.UnCheckSelf()
            }
            super.Check(MenuItemName)
        }
        else{
            throw Error("For radio-like menus, you must specify a MenuItemName to check.")
        }        
    }

    ; Private method
    CheckDefault(MenuItemName?){
        if IsSet(MenuItemName){
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
            this.UnCheckSelf()
        }
    }

    CheckAll(MenuItemName?){
        this.CheckChildren(MenuItemName?)
        this.Check()
    }

    CheckChildren(MenuItemName?){
        Loop this.subMenus.Length{
            if (this.subMenus[A_index].hasSubmenus()){
                this.subMenus[A_index].CheckAll(MenuItemName?)
            }
            else{
                try{
                    this.subMenus[A_index].Check(MenuItemName?)
                }
            }
        }
    }

    UnCheckChildren(MenuItemName?){
        Loop this.subMenus.Length{
            if (this.subMenus[A_index].hasSubmenus()){
                this.subMenus[A_index].UncheckAll(MenuItemName?)
            }
            else{
                try{
                    this.subMenus[A_index].UnCheck(MenuItemName?)
                }
            }
        }
    }

    UncheckAll(MenuItemName?){
        this.UnCheckChildren(MenuItemName?)
        this.UnCheckSelf()
    }

    UncheckSelf(){
        Loop this.itemNames.Length{
            super.UnCheck(this.itemNames[A_index])
        }
    }

    hasSubmenus(){
        return this.subMenus.Length > 0
    }
}