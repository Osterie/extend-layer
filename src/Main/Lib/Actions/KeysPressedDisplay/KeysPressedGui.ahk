#Requires AutoHotkey v2.0

#Include <ui\Main\util\GuiSizeChanger>

#Include <Util\InputReader>

#Include <Actions\Action>
; TODO add more text-editor like features, cursors, move cursors, mark text? etc.
; TODO can create a text editor class, and this class is like that but for display purposes (show other people some text you type.)
; TODO use MVC design pattern.
Class KeysPressedGui extends Action{

    GuiShowKeysPressed := ""
    showKeysPressedControl := ""
    storedKeys := ""
    guiHidden := true

    InputReader := InputReader()  ; Create an instance of InputReader to handle key presses

    ; TODO add method to change font size...
    CreateGui(){
        this.GuiShowKeysPressed := Gui()
        this.GuiShowKeysPressed.Opt("-Caption +AlwaysOnTop +Owner +LastFound +Disabled")
        this.GuiShowKeysPressed.BackColor := "EEAA99"
        this.GuiShowKeysPressed.SetFont("s40 w70 q4", "Cascadia Code")
        this.showKeysPressedControl := this.GuiShowKeysPressed.Add("Text")
    }

    ToggleShowKeysPressed(){
        if (this.guiHidden){
            this.ShowKeysPressed()
        }
        else{
            this.HideKeysPressed()
        }
    }

    ShowKeysPressed(){
        this.InputReader.CreateInputReader(this.OnKeyPressed.Bind(this))
        this.Show()
    }

    Show(){
        this.guiHidden := false
        
        WinSetAlwaysOnTop 1, this.GuiShowKeysPressed
        this.GuiShowKeysPressed.Show("NoActivate")
    }

    HideKeysPressed(){
        this.InputReader.DestroyInputReader()
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
      
    OnKeyPressed(self){
        try {
            key := this.ValidateKeyPressed(A_ThisHotKey)
    
            if (key == "backspace"){
                this.storedKeys := SubStr(this.storedKeys, 1, -1*(1))
            }
            else if (key == "ctrl + backspace"){
    
                if (SubStr(this.storedKeys, -1) == " " || SubStr(this.storedKeys, -1) == "`n") {
                    this.storedKeys := SubStr(this.storedKeys, 1, -1)
                }
                else if (!InStr(this.storedKeys, " ") && !InStr(this.storedKeys, "`n")) {
                    this.storedKeys := ""
                    return
                }

                lastSpacePosition := InStr(this.storedKeys, " ", 0, -1)  ; get position of last occurrence of " "
                lastNewLinePosition := InStr(this.storedKeys, "`n", 0, -1)  ; get position of last occurrence of "`n"
                
                indexToUse := Max(lastSpacePosition, lastNewLinePosition)  ; get the maximum of the two positions

                this.storedKeys := SubStr(this.storedKeys, 1, indexToUse)  ; get substring from start to last dot
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