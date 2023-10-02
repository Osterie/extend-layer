#Requires Autohotkey v2.0

Class FirstKeyboardOverlay{

    IsVisible := false
    GUIFirstKeyboardOverlay := 0

    CreateKeyboardOverlay(){
 
        ; Changing this font size will resize the keyboard:
        fontSize := "10"
        fontName := "Verdana"  ; This can be blank to use the system's default font.
        fontStyle := "Bold"    ; Example of an alternative: Italic Underline
        
        ; Gui
        this.GUIFirstKeyboardOverlay := Gui()
        this.GUIFirstKeyboardOverlay.SetFont("s" . fontSize . " " . fontStyle, fontName)
        this.GUIFirstKeyboardOverlay.Opt("+E0x20 -Caption +AlwaysOnTop +Owner +ToolWindow")
        
        
        ;---- Calculate object dimensions based on chosen font size:
        displayBoxWidth := fontSize * 6
        displayBoxHeight := fontSize * 3
        
        ; Spacing to be used between the keys.
        displayBoxMargin := fontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        keySizeHelperRow := "w" . displayBoxWidth . " h" . displayBoxHeight
        positionHelperRow := "x+" . displayBoxMargin . " " . keySizeHelperRow
        
        ;---- Calculate object dimensions based on chosen font size:
        keyWidthDestination := fontSize * 6
        keyHeightDestination := fontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        keySizeDestination := "w" . keyWidthDestination . " h" . keyHeightDestination
        positionDestinationRow := "x+" . displayBoxMargin . " " . keySizeDestination
        
        ;   The first row.
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "1")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "2")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "3")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "4")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "5")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "6")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "7")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "8")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "9")
        this.GUIFirstKeyboardOverlay.Add("Button", positionHelperRow, "0")
        
        ;   The second row.
        this.GUIFirstKeyboardOverlay.Add("Button", "xm y+" . displayBoxMargin . " " . keySizeDestination , "Time Table")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Black Board")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Prog 1")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Team")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Math")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Prog Num Sec")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "Jupyter Hub")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "8")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "9")
        this.GUIFirstKeyboardOverlay.Add("Button", positionDestinationRow, "0")
        
        return
    }

    DestroyGui(){
        this.GUIFirstKeyboardOverlay.Destroy()
    }

    ShowGui(){
        ;---- Show the keyboard centered but not active (to maintain the current window's focus):
        this.GUIFirstKeyboardOverlay.Show("xCenter NoActivate")
        this.GUIFirstKeyboardOverlay.Title := "Virtual Keyboard View"

         
        ;    Get the window's Width and Height through the GUI's name.
        WinGetPos(, , &windowWidth, &windowHeight, "Virtual Keyboard View")
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:

        MonitorGetWorkArea(1, &workAreaLeft, &workAreaTop, &workAreaRight, &workAreaBottom)
        
        ; Calculate window's X-position:
        windowX := workAreaRight
        windowX -= workAreaLeft  ; Now windowX contains the width of this monitor.
        windowX -= windowWidth
        windowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        windowX += workAreaLeft
        
        ; Calculate window's Y-position:
        windowY := workAreaBottom
        windowY -= windowHeight
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove(windowX, windowY, , , "Virtual Keyboard View")
        this.IsVisible := true
    }

    HideGui(){
        this.GUIFirstKeyboardOverlay.Hide()
        this.IsVisible := false
    }

    GetVisibility(){
        return this.IsVisible
    }
}

Class SecondKeyboardOverlay{

    IsVisible := false
    GUISecondKeyboardOverlay := 0

    BluetoothToggle := ""
    TouchPadToggle := ""
    TouchScreenToggle := ""
    CameraToggle := ""

    __New(){

        ; ------------------------GET DEVICE STATES--------------------------------
        deviceToggles := ""

        ; Capture the output (delets the output.txt file if it alredy exists)
        try{
            FileDelete(A_ScriptDir "\output.txt")
        }
        catch{
            ; File does not exist...
        }

        Run("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass -Command `"& { . '" A_ScriptDir "\powerShellScripts\get-device-states.exe' } 1> " A_ScriptDir "\output.txt`"")

        ; Read the captured output from the file
        deviceToggles := Fileread(A_ScriptDir "\output.txt")

        ; Delete the file after reading them
        FileDelete(A_ScriptDir "\output.txt")

        deviceTogglesArray := StrSplit(deviceToggles,"`n")
        
        This.BluetoothToggle := deviceTogglesArray[1]
        This.TouchPadToggle := deviceTogglesArray[2]
        This.TouchScreenToggle := deviceTogglesArray[3]
        This.CameraToggle := deviceTogglesArray[4]
    }

    CreateKeyboardOverlay(){
 
        ; Changing this font size will resize the keyboard:
        fontSize := "10"
        fontName := "Verdana"  ; This can be blank to use the system's default font.
        fontStyle := "Bold"    ; Example of an alternative: Italic Underline
        
        ; Gui
        this.GUISecondKeyboardOverlay := Gui()
        this.GUISecondKeyboardOverlay.SetFont("s" . fontSize . " " . fontStyle, fontName)
        this.GUISecondKeyboardOverlay.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.GUISecondKeyboardOverlay.Title := "Virtual Keyboard View"

        ;---- Calculate object dimensions based on chosen font size:
        displayBoxWidth := fontSize * 6
        displayBoxHeight := fontSize * 3
        
        ; Spacing to be used between the keys.
        displayBoxMargin := fontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        keySizeHelperRow := "w" . displayBoxWidth . " h" . displayBoxHeight
        positionHelperRow := "x+" . displayBoxMargin . " " . keySizeHelperRow
        
        ;---- Calculate object dimensions based on chosen font size:
        keyWidthDestination := fontSize * 6
        keyHeightDestination := fontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        keySizeDestination := "w" . keyWidthDestination . " h" . keyHeightDestination
        positionDestinationRow := "x+" . displayBoxMargin . " " . keySizeDestination

        ;   The first row.
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "1")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "2")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "3")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "4")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "5")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "6")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "7")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "8")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "9")
        this.GUISecondKeyboardOverlay.Add("Button", positionHelperRow, "0")
        
        ;   The second row.
        this.GUISecondKeyboardOverlay.Add("Button", "xm y+" . displayBoxMargin . " " . keySizeDestination . " vTouchScreen", This.TouchScreenToggle)
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow . " vCamera", This.CameraToggle)
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow . " vBluetooth", This.BluetoothToggle)
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow . " vTouchPad", This.TouchPadToggle)
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "5")
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "6")
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "7")
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "8")
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "9")
        this.GUISecondKeyboardOverlay.Add("Button", positionDestinationRow, "0")
        return
    }

    DestroyGui(){
        this.GUISecondKeyboardOverlay.Destroy()
    }

    ShowGui(){
        ;---- Show the keyboard centered but not active (to maintain the current window's focus):
        this.GUISecondKeyboardOverlay.Show("xCenter NoActivate")
         
        ;    Get the window's Width and Height through the GUI's name.
        WinGetPos(, , &windowWidth, &windowHeight, "Virtual Keyboard View")
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:
        MonitorGetWorkArea(1, &workAreaLeft, &workAreaTop, &workAreaRight, &workAreaBottom)
        
        ; Calculate window's X-position:
        windowX := workAreaRight
        windowX -= workAreaLeft  ; Now windowX contains the width of this monitor.
        windowX -= windowWidth
        windowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        windowX += workAreaLeft
        
        ; Calculate window's Y-position:
        windowY := workAreaBottom
        windowY -= windowHeight
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove(windowX, windowY, , , "Virtual Keyboard View")
        this.IsVisible := true
    }

    HideGui(){
        this.GUISecondKeyboardOverlay.Hide()
        this.IsVisible := false
    }

    GetVisibility(){
        return this.IsVisible
    }

    ChangeState(device){

        if (device == "Touch-Screen"){
            If InStr(This.TouchScreenToggle, "Enable"){
                This.TouchScreenToggle := StrReplace(This.TouchScreenToggle, "Enable", "Disable")
            }
            else{
                This.TouchScreenToggle := StrReplace(This.TouchScreenToggle, "Disable", "Enable")
            }

            this.GUISecondKeyboardOverlay['TouchScreen'].Text := This.TouchScreenToggle

            ; ogcButtonTouchScreen.Value := This.TouchScreenToggle
        }

        else if (device == "Bluetooth"){
            If InStr(This.BluetoothToggle, "Enable")            {
                This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Enable", "Disable")
            }
            else{
                This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Disable", "Enable")
            }

            this.GUISecondKeyboardOverlay['Bluetooth'].Text := This.BluetoothToggle
            ; ogcButtonBluetooth.Value := This.BluetoothToggle
        }

        else if (device == "TouchPad"){
            If InStr(This.TouchPadToggle, "Enable"){
                This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Enable", "Disable")
            }
            else{
                This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Disable", "Enable")
            }
            this.GUISecondKeyboardOverlay['TouchPad'].Text := This.TouchPadToggle

            ; ogcButtonTouchPad.Value := This.TouchPadToggle
        }

        else if (device == "Camera"){
            If InStr(This.CameraToggle, "Enable"){
                This.CameraToggle := StrReplace(This.CameraToggle, "Enable", "Disable")
            }
            else{
                This.CameraToggle := StrReplace(This.CameraToggle, "Disable", "Enable")
            }
            this.GUISecondKeyboardOverlay['Camera'].Text := This.CameraToggle

            ; ogcButtonCamera.Value := This.CameraToggle
        }
    }
}

; ----------------------------------------------
; ----------- FUNCTIONS ------------------------
; ----------------------------------------------

; --------------Seach----------

; Searches google for the currently highlighteded text, or the text stored in the clipboard
SearchHighlitedOrClipboard(){
    clipboardValue := A_Clipboard
    Send("^c")
    googleSearchUrl := "https://www.google.com/search?q="
    
    ; if it starts with "https://" go to, rather than search in google search
    isUrl := SubStr(A_Clipboard, 1, 8)
    if (isUrl = "https://") {   
        Run(A_Clipboard)
    }
    else { ;search using google search
        joined_url := googleSearchUrl . "" . A_Clipboard
        Run(joined_url)
    }
    
    ;put the last copied thing back in the clipboard
    A_Clipboard := clipboardValue 
}

; ---------CHANGE VALUES---------------

; FIXME: this should be made more general. "CycleValue" or something. Take currentValue, lowerlimit, upperlimit and step.
; ToggleValue(givenValue, value1, value2, defaultValue){
;     valueToReturn := 0
;     if (givenValue == value1){
;         valueToReturn := value2
;     }
;     else if (givenValue == value2){
;         valueToReturn := value1
;     }
;     else{
;         valueToReturn := defaultValue
;     }
;     return valueToReturn
    
; }

