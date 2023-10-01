#Requires Autohotkey v2.0

Class FirstKeyboardOverlay{

    IsVisible := false
    GUIFirstKeyboardOverlay := 0

    CreateKeyboardOverlay(){
 
        ; Changing this font size will resize the keyboard:
        k_FontSize := "10"
        k_FontName := "Verdana"  ; This can be blank to use the system's default font.
        k_FontStyle := "Bold"    ; Example of an alternative: Italic Underline
        
        ; Gui
        this.GUIFirstKeyboardOverlay := Gui()
        this.GUIFirstKeyboardOverlay.SetFont("s" . k_FontSize . " " . k_FontStyle, k_FontName)
        this.GUIFirstKeyboardOverlay.Opt("+E0x20 -Caption +AlwaysOnTop +Owner +ToolWindow")
        
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidth := k_FontSize * 6
        k_KeyHeight := k_FontSize * 3
        
        ; Spacing to be used between the keys.
        k_KeyMargin := k_FontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        k_KeySizeHelperRow := "w" . k_KeyWidth . " h" . k_KeyHeight
        k_PositionHelperRow := "x+" . k_KeyMargin . " " . k_KeySizeHelperRow
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidthDestination := k_FontSize * 6
        k_KeyHeightDestination := k_FontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        k_KeySizeDestination := "w" . k_KeyWidthDestination . " h" . k_KeyHeightDestination
        k_PositionDestinationRow := "x+" . k_KeyMargin . " " . k_KeySizeDestination
        
        ;   The first row.
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "1")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "2")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "3")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "4")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "5")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "6")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "7")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "8")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "9")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionHelperRow, "0")
        
        ;   The second row.
        this.GUIFirstKeyboardOverlay.Add("Button", "xm y+" . k_KeyMargin . " " . k_KeySizeDestination , "Time Table")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Black Board")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Prog 1")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Team")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Math")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Prog Num Sec")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "Jupyter Hub")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "8")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "9")
        this.GUIFirstKeyboardOverlay.Add("Button", k_PositionDestinationRow, "0")
        
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
        WinGetPos(, , &k_WindowWidth, &k_WindowHeight, "Virtual Keyboard View")
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:

        MonitorGetWorkArea(1, &k_WorkAreaLeft, &k_WorkAreaTop, &k_WorkAreaRight, &k_WorkAreaBottom)
        
        ; Calculate window's X-position:
        k_WindowX := k_WorkAreaRight
        k_WindowX -= k_WorkAreaLeft  ; Now k_WindowX contains the width of this monitor.
        k_WindowX -= k_WindowWidth
        k_WindowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        k_WindowX += k_WorkAreaLeft
        
        ; Calculate window's Y-position:
        k_WindowY := k_WorkAreaBottom
        k_WindowY -= k_WindowHeight
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove(k_WindowX, k_WindowY, , , "Virtual Keyboard View")
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
        ; FileDelete(A_ScriptDir "\output.txt")
        ;FIXME probably just use run instead of runwait
        ; RunWait("powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass -Command `"& { . '" A_ScriptDir "\powerShellScripts\get-device-states.exe' } 1> " A_ScriptDir "\output.txt`"")

        ; ; Read the captured output from the file
        ; deviceToggles := Fileread(A_ScriptDir "\output.txt")

        ; ; Delete the file after reading them
        ; FileDelete(A_ScriptDir "\output.txt")

        ; deviceTogglesArray := StrSplit(deviceToggles,"`n")
        
        ; This.BluetoothToggle := deviceTogglesArray[1]
        ; This.TouchPadToggle := deviceTogglesArray[2]
        ; This.TouchScreenToggle := deviceTogglesArray[3]
        ; This.CameraToggle := deviceTogglesArray[4]
    }

    CreateKeyboardOverlay(){
 
        ; Changing this font size will resize the keyboard:
        k_FontSize := "10"
        k_FontName := "Verdana"  ; This can be blank to use the system's default font.
        k_FontStyle := "Bold"    ; Example of an alternative: Italic Underline
        
        ; Gui
        this.GUISecondKeyboardOverlay := Gui()
        this.GUISecondKeyboardOverlay.SetFont("s" . k_FontSize . " " . k_FontStyle, k_FontName)
        this.GUISecondKeyboardOverlay.Opt("+E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow")
        this.GUISecondKeyboardOverlay.Title := "Virtual Keyboard View"

        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidth := k_FontSize * 6
        k_KeyHeight := k_FontSize * 3
        
        ; Spacing to be used between the keys.
        k_KeyMargin := k_FontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        k_KeySizeHelperRow := "w" . k_KeyWidth . " h" . k_KeyHeight
        k_PositionHelperRow := "x+" . k_KeyMargin . " " . k_KeySizeHelperRow
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidthDestination := k_FontSize * 6
        k_KeyHeightDestination := k_FontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        k_KeySizeDestination := "w" . k_KeyWidthDestination . " h" . k_KeyHeightDestination
        k_PositionDestinationRow := "x+" . k_KeyMargin . " " . k_KeySizeDestination

        ;   The first row.
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "1")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "2")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "3")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "4")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "5")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "6")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "7")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "8")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "9")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionHelperRow, "0")
        
        ;   The second row.
        ; Gui, GUISecondKeyboardOverlay: Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight% w%k_PositionDestinationRow% vTouchScreen, % This.TouchScreenToggle
        ; this.GUISecondKeyboardOverlay.Add("Button", "xm y+" . k_KeyMargin . " " . k_KeySizeDestination , "Time Table")
        this.GUISecondKeyboardOverlay.Add("Button", "xm y+" . k_KeyMargin . " " . k_KeySizeDestination . " vTouchScreen", This.TouchScreenToggle)
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow . " vCamera", This.CameraToggle)
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow . " vBluetooth", This.BluetoothToggle)
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow . " vTouchPad", This.TouchPadToggle)
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "5")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "6")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "7")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "8")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "9")
        this.GUISecondKeyboardOverlay.Add("Button", k_PositionDestinationRow, "0")
        return
    }

    DestroyGui(){
        this.GUISecondKeyboardOverlay.Destroy()
    }

    ShowGui(){
        ;---- Show the keyboard centered but not active (to maintain the current window's focus):
        this.GUISecondKeyboardOverlay.Show("xCenter NoActivate")
         
        ;    Get the window's Width and Height through the GUI's name.
        WinGetPos(, , &k_WindowWidth, &k_WindowHeight, "Virtual Keyboard View")
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:
        MonitorGetWorkArea(1, &k_WorkAreaLeft, &k_WorkAreaTop, &k_WorkAreaRight, &k_WorkAreaBottom)
        
        ; Calculate window's X-position:
        k_WindowX := k_WorkAreaRight
        k_WindowX -= k_WorkAreaLeft  ; Now k_WindowX contains the width of this monitor.
        k_WindowX -= k_WindowWidth
        k_WindowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        k_WindowX += k_WorkAreaLeft
        
        ; Calculate window's Y-position:
        k_WindowY := k_WorkAreaBottom
        k_WindowY -= k_WindowHeight
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove(k_WindowX, k_WindowY, , , "Virtual Keyboard View")
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

