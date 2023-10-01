#Requires AutoHotkey v2.0


Class KeysPressedGui{

    GuiShowKeysPressed := ""
    showKeysPressedControl := ""
    InputReaderInstance := ""
    abortKey := ""
    storedKeys := ""
    guiHidden := true

    CreateGui(){
        this.GuiShowKeysPressed := Gui()
        this.GuiShowKeysPressed.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
        this.GuiShowKeysPressed.BackColor := "EEAA99"
        this.GuiShowKeysPressed.SetFont("s20 w70 q4", "Times New Roman")
        this.showKeysPressedControl := this.GuiShowKeysPressed.AddText(, "")
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
        this.CreateInputReader()
        this.ShowGui()
    }

    ShowGui(){
        this.guiHidden := false
        this.GuiShowKeysPressed.Show()
    }

    HideKeysPressed(){
        this.DestroyInputReader()
        this.storedKeys := ""
        this.SetTextAndResize(this.showKeysPressedControl, this.storedKeys)
        this.HideGui()
    }

    HideGui(){
        this.guiHidden := true
        this.GuiShowKeysPressed.Hide()
    }

    DestroyGui(){
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
    
            this.SetTextAndResize(this.showKeysPressedControl, this.storedKeys)
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
    
    SetTextAndResize(textCtrl, text) {
        textCtrl.Move(,, GetTextSize(textCtrl, text)*)
        textCtrl.Value := text
        textCtrl.Gui.Show('AutoSize')
    
        GetTextSize(textCtrl, text) {
            static WM_GETFONT := 0x0031, DT_CALCRECT := 0x400
            hDC := DllCall('GetDC', 'Ptr', textCtrl.Hwnd, 'Ptr')
            hPrevObj := DllCall('SelectObject', 'Ptr', hDC, 'Ptr', SendMessage(WM_GETFONT,,, textCtrl), 'Ptr')
            height := DllCall('DrawText', 'Ptr', hDC, 'Str', text, 'Int', -1, 'Ptr', buf := Buffer(16), 'UInt', DT_CALCRECT)
            width := NumGet(buf, 8, 'Int') - NumGet(buf, 'Int')
            DllCall('SelectObject', 'Ptr', hDC, 'Ptr', hPrevObj, 'Ptr')
            DllCall('ReleaseDC', 'Ptr', textCtrl.Hwnd, 'Ptr', hDC)
            return [Round(width * 96/A_ScreenDPI), Round(height * 96/A_ScreenDPI)]
        }
    }
}