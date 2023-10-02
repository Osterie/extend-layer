#Requires AutoHotkey v2.0

Class KeyboardOverlay{

    ; Changing this font size will resize the keyboard:
    fontSize := "10"
    fontName := "Verdana"  ; This can be blank to use the system's default font.
    fontStyle := "Bold"    ; Example of an alternative: Italic Underline
    
    elementWidth := ""
    elementHeight := ""
    elementMargin := ""

    keyboardOverlay := ""

    positionFirstRow := ""
    positionSecondRow := ""

    __New(){
        
        ; Width to be used for all elements
        elementWidth := this.fontSize * 6
        ; Height to be used for the first row elements
        firstRowElementHeight := this.fontSize * 3
        ; Height to be used for the second row elements
        secondRowElementHeight := this.fontSize * 6
        
        ; the expression used to position gui elements, first row
        elementSizeFirstRow := "w" . elementWidth . " h" . firstRowElementHeight
        this.positionFirstRow := "x+1 ym " . elementSizeFirstRow
        
        ; the expression used to position gui elements, second row
        elementSizeSecondRow := "w" . elementWidth . " h" . secondRowElementHeight
        this.positionSecondRow := "xp y+ " . elementSizeSecondRow
    }

    CreateGui(){
        this.keyboardOverlay := Gui()
        this.keyboardOverlay.SetFont("s" . this.fontSize . " " . this.fontStyle, this.fontName)
        this.keyboardOverlay.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.keyboardOverlay.Title := "Virtual Keyboard View"
    }

    ShowGui(){
        this.keyboardOverlay.Show("xCenter NoActivate")
        WinGetPos(, , &windowWidth, &windowHeight, "Virtual Keyboard View")
        this.keyboardOverlay.Show("xCenter y" . A_ScreenHeight-windowHeight . "NoActivate")
    }

    HideGui(){
        this.keyboardOverlay.Hide()
    }

    DestroyGui(){
        this.keyboardOverlay.Destroy()
    }

    ; Adds a column to the keyboard overlay, first row showing what key to press to excecute the event in the second row
    ; Static means the second row is unchanged when the key pressed event happens
    AddStaticColumn(keyFirstRow, valueSecondRow){
        ; The first row.
        this.keyboardOverlay.Add("Button", this.positionFirstRow, keyFirstRow)
        ; The second row.
        this.keyboardOverlay.Add("Button", this.positionSecondRow, valueSecondRow)
    }


    ; Adds a column to the keyboard overlay, first row showing what key to press to excecute the event in the second row
    ; Dynamic means the second row is changed when the key pressed event happens
    AddColumnToggleValue(keyFirstRow, valueSecondRow, stateSecondRow){
        ; The first row.
        this.keyboardOverlay.Add("Button", this.positionFirstRow, keyFirstRow)
        ; The second row.
        this.keyboardOverlay.Add("Button", this.positionSecondRow . " v" . valueSecondRow , stateSecondRow . " " . valueSecondRow)
    }

    ToggleValue(valueSecondRow, state){


        if (StrLower(state) == "enable"){
            state := "Disable"
        }
        else if (StrLower(state) == "disable"){
            state := "Enable"
        }

        this.keyboardOverlay[valueSecondRow].Text := state . " " . valueSecondRow


        ; if (device == "Touch-Screen"){
        ;     If InStr(This.TouchScreenToggle, "Enable"){
        ;         This.TouchScreenToggle := StrReplace(This.TouchScreenToggle, "Enable", "Disable")
        ;     }
        ;     else{
        ;         This.TouchScreenToggle := StrReplace(This.TouchScreenToggle, "Disable", "Enable")
        ;     }

        ;     this.GUISecondKeyboardOverlay['TouchScreen'].Text := This.TouchScreenToggle

        ;     ; ogcButtonTouchScreen.Value := This.TouchScreenToggle
        ; }

        ; else if (device == "Bluetooth"){
        ;     If InStr(This.BluetoothToggle, "Enable")            {
        ;         This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Enable", "Disable")
        ;     }
        ;     else{
        ;         This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Disable", "Enable")
        ;     }

        ;     this.GUISecondKeyboardOverlay['Bluetooth'].Text := This.BluetoothToggle
        ;     ; ogcButtonBluetooth.Value := This.BluetoothToggle
        ; }

        ; else if (device == "TouchPad"){
        ;     If InStr(This.TouchPadToggle, "Enable"){
        ;         This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Enable", "Disable")
        ;     }
        ;     else{
        ;         This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Disable", "Enable")
        ;     }
        ;     this.GUISecondKeyboardOverlay['TouchPad'].Text := This.TouchPadToggle

        ;     ; ogcButtonTouchPad.Value := This.TouchPadToggle
        ; }

        ; else if (device == "Camera"){
        ;     If InStr(This.CameraToggle, "Enable"){
        ;         This.CameraToggle := StrReplace(This.CameraToggle, "Enable", "Disable")
        ;     }
        ;     else{
        ;         This.CameraToggle := StrReplace(This.CameraToggle, "Disable", "Enable")
        ;     }
        ;     this.GUISecondKeyboardOverlay['Camera'].Text := This.CameraToggle

            ; ogcButtonCamera.Value := This.CameraToggle
        ; }
    }

    ChangeElementWidth(){

    }
    ChangeElementHeight(){

    }

    

}

test := KeyboardOverlay()
test.CreateGUI()
test.AddColumnToggleValue("1", "Die", "Enable")
test.AddColumnToggleValue("2", "Live", "Enable")
test.AddColumnToggleValue("3", "Dont", "Enable")
test.ToggleValue("Live", "Enable")
test.ShowGui()
Esc:: ExitApp