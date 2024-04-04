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

    __New(){
        Super.__New()
        this.menuItems := Array()
    }

    Add(MenuItemName := "", CallbackOrSubmenu := "", Options := ""){
        this.Add(MenuItemName, CallbackOrSubmenu, Options)
        msgbox(Type(CallbackOrSubmenu))
        ; TODO handle better... and make method?
        if (Type(CallbackOrSubmenu) = "ImprovedMenu"){
            this.menuItems.Push(CallbackOrSubmenu)
        }
        else if (Type(CallbackOrSubmenu) = "Menu"){
            throw Error("Unable to add value of type menu to Improved Menu")
        }
        else{
            
            this.menuItems.Push(MenuItemName)
        }
    }

    
    UncheckAll(menu_){
        currentTheme := FilePaths.GetCurrentTheme()
        Loop menu_.Length{
            try{
                menu_[A_index].UnCheck(currentTheme)
            }
        }
    }
}