#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiSizeChanger>

#Include <Actions\Action>

; TODO use MVC design pattern.
Class KeysPressedGui extends Action{

    GuiShowKeysPressed := ""
    showKeysPressedControl := ""
    InputReaderInstance := ""
    abortKey := ""
    storedKeys := ""
    guiHidden := true

    ; TODO add method to change font size...

    CreateGui(){
        this.GuiShowKeysPressed := Gui()
        this.GuiShowKeysPressed.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
        this.GuiShowKeysPressed.BackColor := "EEAA99"
        this.GuiShowKeysPressed.SetFont("s40 w70 q4", "Cascadia Code")
        this.showKeysPressedControl := this.GuiShowKeysPressed.Add("Text")
    }

    ; The reason for the asterisk is because the Hotkey function is used to create hotkeys.
    ; And when it is used with a function or class method, the function or class method are automatically given one argument, which is the name of the hotkey that was pressed.
    ; Which is sad
    ToggleShowKeysPressed(){
        if (this.guiHidden){
            this.ShowKeysPressed()
        }
        else{
            this.HideKeysPressed()
        }
    }

    ShowKeysPressed(){
        this.CreateInputReader()
        this.Show()
    }

    Show(){
        this.guiHidden := false
        this.GuiShowKeysPressed.Show()
    }

    HideKeysPressed(){
        this.DestroyInputReader()
        this.storedKeys := ""
        GuiSizeChanger.SetTextAndResize(this.showKeysPressedControl, this.storedKeys)
        this.Hide()
    }

    Hide(){
        this.guiHidden := true
        this.GuiShowKeysPressed.Hide()
    }

    Destroy(){
        this.GuiShowKeysPressed.Destroy()
    }
    
    IsHidden(){
        return this.guiHidden
    }

    CreateInputReader() {
        Loop 95
        {
            k := Chr(A_Index + 31)
            k := (k = " ") ? "Space" : k
            Hotkey("~*" k, this.OnKeyPressed.Bind(this), "on")
        }
    
        Otherkeys := "Enter|BackSpace|ø|å|æ"
        Loop Parse, Otherkeys, "|"
        {
            Hotkey("~*" A_LoopField, this.OnKeyPressed.Bind(this), "on")
        }
    }
    
    DestroyInputReader(){
        Loop 95
        {
            k := Chr(A_Index + 31)
            k := (k = " ") ? "Space" : k
            Hotkey("~*" k , , "off")
        }
    
        Otherkeys := "Enter|BackSpace|ø|å|æ"
        Loop Parse, Otherkeys, "|"
        {
            Hotkey("~*" A_LoopField , , "off")
        }
    }
      
    OnKeyPressed(self){
        try {
    
            key := this.ValidateKeyPressed(A_ThisHotKey)
    
            if (key == "backspace"){
                this.storedKeys := SubStr(this.storedKeys, 1, -1*(1))
            }
            else if (key == "ctrl + backspace"){
    
                if (SubStr(this.storedKeys, -1, 1) == " ") {
                    this.storedKeys := SubStr(this.storedKeys, 1, -1*(1))
                }
    
                else if (!InStr(this.storedKeys, " ")){
                    this.storedKeys := ""
                }
                LastUnderScorePosition := InStr(this.storedKeys, " ", 0, -1)  ; get position of last occurrence of " "
                this.storedKeys := SubStr(this.storedKeys, 1, LastUnderScorePosition)  ; get substring from start to last dot
            }
    
            else if (key == "enter"){
                this.storedKeys := this.storedKeys . "`n"
            }
            else{
                this.storedKeys := this.storedKeys . key
            }
    
            GuiSizeChanger.SetTextAndResize(this.showKeysPressedControl, this.storedKeys)
        }
    }

    ValidateKeyPressed(pressedKey){

        pressedKey := StrReplace(pressedKey, "*", "")
        pressedKey := StrReplace(pressedKey, "~", "")
    
        if (pressedKey == "Space"){
            pressedKey := A_Space
        }
        else if (pressedKey == "BackSpace" && GetKeyState("Ctrl") ) {
            pressedKey := "ctrl + backspace"
        }
        else if (pressedKey == "BackSpace"){
            pressedKey := "backspace"
        }
        if ( GetKeyState("Shift") ){
            pressedKey := StrUpper(pressedKey)
        }
        else{
            pressedKey := StrLower(pressedKey)
        }
    
        return pressedKey
    }
}