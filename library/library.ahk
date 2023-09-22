#Requires AutoHotkey v1.1.36.02

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1

; ----------- CLASSES ------------------------

; test := new LayerIndicatorController()
; test.addLayerIndicator(1, "Green")

; Class LayerIndicatorController{

;     layers := []
;     activeLayer := 0

;     addLayerIndicator(layer, color){
;         layer := new LayerIndicator(layer, color)
;         layers.Push(layer)
;     }

;     showLayerIndicator(layer){
;         layers[layer].showOverlay()
;     }
;     hideLayerIndicator(layer){
;         layers[layer].hideOverlay()
;     }

;     getLayerIndicator(){
;         return layers[activeLayer]
;     }

;     setCurrentLayerIndicator(layer){
;         this.activeLayer := layer
;     }

;     toggleLayerIndicator(toggleValue){
;         if (this.activeLayer == 0){
;             this.activeLayer := toggleValue
;         }
;         else{
;             this.activeLayer := 0
;         }
;     }

;     ; increases currentLayer by 1, if upperLimit is reached, it is set back to 1 (Note, not does not go back to 0)
;     cycleLayerIndicators(){
;         keyboardsAmount := this.keyboards.Length
;         this.currentLayer := mod( (this.currentLayer) , keyboardsAmount-1)+1
;     }

;     ; sets currentLayer to 0
;     resetLayerIndicators(){
;         this.currentLayer := 0
;     }
    
; }

; Class LayerIndicator{

;     indicatorColor := ""
;     layer := 0

;     __New(layer, color) {
;         this.layer := layer
;         this.indicatorColor := color
;     }

;     createLayerIndicator(){
;         Gui, % this.layer: new
;         Gui, % this.layer: +AlwaysOnTop -Caption +ToolWindow
;         Gui, GUIPrivacyBox: Color, % this.indicatorColor
;     }

;     destroyLayerIndicator(){
;         Gui, % this.layer: destroy
;     }

;     showLayerIndicator(){
;         Gui, % this.layer: show
;     }

;     hideLayerIndicator(){
;         Gui, % this.layer: hide
;     }

;     setLayerColor(color){
;         this.indicatorColor := color
;         Gui, % this.layer: Color, % this.indicatorColor
;     }

;     getLayerColor(){
;         return this.indicatorColor
;     }
; }



; new keyboardlayer(1, "green")


; Class KeyboardLayer(){

;     layerNumber := 0
;     color := ""

;     __New(layer, color){
;         this.layerNumber := layer
;         this.color := color
;     }
; }

; Class Layer{
    
;     ; FIXME, probably dont have upperlimitlayers and such here, instead use ExtraKeyboards class or something
;     ; this should only be one layer, not multiple anython
;     currentLayer := 0
;     ; IndicatorColor := ""

;     __New(upperLimitLayers) {
;         this.upperLimitLayers := upperLimitLayers
;     }

;     ; switches layer between given layer or 0, depending on currentLayer's current value
;     toggleLayer(toggleValue){
;         if (this.currentLayer == 0){
;             this.currentLayer := toggleValue
;         }
;         else{
;             this.currentLayer := 0
;         }
;     }

;     ; increases currentLayer by 1, if upperLimit is reached, it is set back to 1 (Note, not does not go back to 0)
;     cycleExtraLayers(){
;         this.currentLayer := mod( (this.currentLayer) , this.upperLimitLayers-1)+1
;     }


;     ; sets currentLayer to 0
;     resetLayer(){
;         this.currentLayer := 0
;     }

;     ToggleCapsLockStateFirstLayer(){

;         SetCapsLockState % !GetKeyState("CapsLock", "T")
        
;         if GetKeyState("CapsLock", "T") = 0{
;             Gui, GUILayerIndicator: Hide
;             this.Layer := 0 

;         }
;         else if (GetKeyState("CapsLock", "T") = 1){
;             Gui, GUILayerIndicator: Color, Green
;             guiHeight := A_ScreenHeight-142
;             Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
;             this.Layer := 1
;         }
;     }
; }






; ToggleCapsLockStateSecondLayer(){

;     if GetKeyState("CapsLock", "T") = 0{
;         SetCapsLockState on            
;     }

;     if (This.Layer == 0 || This.Layer == 1){
;         This.IndicatorColor := "Red"
;         This.Layer := 2
;     }
;     else if (This.Layer == 0 || This.Layer == 2){
;         This.IndicatorColor := "Green"
;         This.Layer := 1
;     }

;     Gui, GUILayerIndicator: Color, % This.IndicatorColor
;     guiHeight := A_ScreenHeight-142
;     Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
; }

; ActivateFirstLayer(){

; }

; ActivateSecondLayer(){
    
; }


; Class Keyboard{

;     Layer := 1
;     IndicatorColor := ""

;     __New() {

;         Gui, GUILayerIndicator: new
;         Gui, GUILayerIndicator: +AlwaysOnTop -Caption +ToolWindow
;     }

;     ToggleCapsLockStateFirstLayer(){

;         SetCapsLockState % !GetKeyState("CapsLock", "T")
        
;         if GetKeyState("CapsLock", "T") = 0{
;             Gui, GUILayerIndicator: Hide
;             this.Layer := 0 

;         }
;         else if (GetKeyState("CapsLock", "T") = 1){
;             Gui, GUILayerIndicator: Color, Green
;             guiHeight := A_ScreenHeight-142
;             Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
;             this.Layer := 1
;         }
;     }

;     ToggleCapsLockStateSecondLayer(){

;         if GetKeyState("CapsLock", "T") = 0{
;             SetCapsLockState on            
;         }

;         if (This.Layer == 0 || This.Layer == 1){
;             This.IndicatorColor := "Red"
;             This.Layer := 2
;         }
;         else if (This.Layer == 0 || This.Layer == 2){
;             This.IndicatorColor := "Green"
;             This.Layer := 1
;         }

;         Gui, GUILayerIndicator: Color, % This.IndicatorColor
;         guiHeight := A_ScreenHeight-142
;         Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
;     }

;     ActivateFirstLayer(){

;     }

;     ActivateSecondLayer(){
        
;     }

; }

Class FirstKeyboardOverlay{

    IsVisible := false

    CreateKeyboardOverlay(){
 
        ; Changing this font size will resize the keyboard:
        k_FontSize = 10
        k_FontName = Verdana  ; This can be blank to use the system's default font.
        k_FontStyle = Bold    ; Example of an alternative: Italic Underline
        
        ; Gui
        Gui, GUIFirstKeyboardOverlay: Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
        Gui, GUIFirstKeyboardOverlay: +E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow
        
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidth := k_FontSize * 6
        k_KeyHeight := k_FontSize * 3
        
        ; Spacing to be used between the keys.
        k_KeyMargin := k_FontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        k_KeySizeHelperRow = w%k_KeyWidth% h%k_KeyHeight%
        k_PositionHelperRow = x+%k_KeyMargin% %k_KeySizeHelperRow%
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidthDestination := k_FontSize * 6
        k_KeyHeightDestination := k_FontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        k_KeySizeDestination = w%k_KeyWidthDestination% h%k_KeyHeightDestination%
        k_PositionDestinationRow = x+%k_KeyMargin% %k_KeySizeDestination%
        
        ;   The first row.
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 1
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 2
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 3
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 4
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 5
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 6 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 7 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 8 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 9 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 0
        
        ;   The second row.
        Gui, GUIFirstKeyboardOverlay: Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight% w%k_PositionDestinationRow%, Time Table
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Black Board
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Prog 1
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Team
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Math
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Prog Num Sec
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, Jupyter Hub
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 8 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 9 
        Gui, GUIFirstKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 0
        

        return
    }

    Destroy(){
        Gui, GUIFirstKeyboardOverlay: Destroy
    }

    Show(){
        ;---- Show the keyboard centered but not active (to maintain the current window's focus):
        Gui, GUIFirstKeyboardOverlay: Show, xCenter NoActivate, Virtual Keyboard View
         
        ;    Get the window's Width and Height through the GUI's name.
        WinGetPos,,, k_WindowWidth, k_WindowHeight, Virtual Keyboard View
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:
        SysGet, k_WorkArea, MonitorWorkArea, 1
        
        ; Calculate window's X-position:
        k_WindowX = %k_WorkAreaRight%
        k_WindowX -= %k_WorkAreaLeft%  ; Now k_WindowX contains the width of this monitor.
        k_WindowX -= %k_WindowWidth%
        k_WindowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        k_WindowX += %k_WorkAreaLeft%
        
        ; Calculate window's Y-position:
        k_WindowY = %k_WorkAreaBottom%
        k_WindowY -= %k_WindowHeight%
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove, Virtual Keyboard View,, %k_WindowX%, %k_WindowY%
        this.IsVisible := true
    }

    Hide(){
        Gui, GUIFirstKeyboardOverlay: Hide
        this.IsVisible := false
    }

    GetVisibility(){
        return this.IsVisible
    }
}

Class SecondKeyboardOverlay{

    IsVisible := false

    BluetoothToggle := ""
    TouchPadToggle := ""
    TouchScreenToggle := ""
    CameraToggle := ""

    __New(){

        ; ------------------------GET DEVICE STATES--------------------------------
        deviceToggles := ""

        ; Capture the output (delets the output.txt file if it alredy exists)
        ; FileDelete, %A_ScriptDir%\output.txt
        ; RunWait, powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass -Command "& { . '%A_ScriptDir%\powerShellScripts\get-device-states.exe' } 1> %A_ScriptDir%\output.txt", 

        ; ; Read the captured output from the file
        ; FileRead, deviceToggles, %A_ScriptDir%\output.txt

        ; ; Delete the file after reading them
        ; FileDelete, %A_ScriptDir%\output.txt

        ; StringSplit, deviceTogglesArray, deviceToggles, `n,
        
        This.BluetoothToggle := deviceTogglesArray1
        This.TouchPadToggle := deviceTogglesArray2
        This.TouchScreenToggle := deviceTogglesArray3
        This.CameraToggle := deviceTogglesArray4
    }

    CreateKeyboardOverlay(){

        global
 
        ; Changing this font size will resize the keyboard:
        k_FontSize = 10
        k_FontName = Verdana  ; This can be blank to use the system's default font.
        k_FontStyle = Bold    ; Example of an alternative: Italic Underline
        
        ; Gui
        Gui, GUISecondKeyboardOverlay: Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
        Gui, GUISecondKeyboardOverlay: +E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidth := k_FontSize * 6
        k_KeyHeight := k_FontSize * 3
        
        ; Spacing to be used between the keys.
        k_KeyMargin := k_FontSize // 10
        
        
        ; Only a facilitator for creating GUI.
        k_KeySizeHelperRow = w%k_KeyWidth% h%k_KeyHeight%
        k_PositionHelperRow = x+%k_KeyMargin% %k_KeySizeHelperRow%
        
        ;---- Calculate object dimensions based on chosen font size:
        k_KeyWidthDestination := k_FontSize * 6
        k_KeyHeightDestination := k_FontSize * 6
        
        ; Spacing to be used between the keys for destination row (second row probably).
        ; Only a facilitator for creating GUI.
        k_KeySizeDestination = w%k_KeyWidthDestination% h%k_KeyHeightDestination%
        k_PositionDestinationRow = x+%k_KeyMargin% %k_KeySizeDestination%
        
        ;   The first row.
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 1
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 2
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 3
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 4
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 5
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 6 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 7 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 8 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 9 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionHelperRow%, 0
        
        ;   The second row.
        Gui, GUISecondKeyboardOverlay: Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight% w%k_PositionDestinationRow% vTouchScreen, % This.TouchScreenToggle
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow% vCamera, % This.CameraToggle
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow% vBluetooth, % This.BluetoothToggle
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow% vTouchPad, % This.TouchPadToggle
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 5
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 6
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 7
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 8 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 9 
        Gui, GUISecondKeyboardOverlay: Add, Button, %k_PositionDestinationRow%, 0
        return
    }

    Destroy(){
        Gui, GUISecondKeyboardOverlay: Destroy

    }

    Show(){
        ;---- Show the keyboard centered but not active (to maintain the current window's focus):
        Gui, GUISecondKeyboardOverlay: Show, xCenter NoActivate, Virtual Keyboard View
         
        ;    Get the window's Width and Height through the GUI's name.
        WinGetPos,,, k_WindowWidth, k_WindowHeight, Virtual Keyboard View
         
        ;---- Position the keyboard at the bottom of the screen while avoiding the taskbar:
        SysGet, k_WorkArea, MonitorWorkArea, 1
        
        ; Calculate window's X-position:
        k_WindowX = %k_WorkAreaRight%
        k_WindowX -= %k_WorkAreaLeft%  ; Now k_WindowX contains the width of this monitor.
        k_WindowX -= %k_WindowWidth%
        k_WindowX /= 2  ; Calculate position to center it horizontally.
        ; The following is done in case the window will be on a non-primary monitor
        ; or if the taskbar is anchored on the left side of the screen:
        k_WindowX += %k_WorkAreaLeft%
        
        ; Calculate window's Y-position:
        k_WindowY = %k_WorkAreaBottom%
        k_WindowY -= %k_WindowHeight%
         
        ;   Move the window to the bottom-center position of the monitor.
        WinMove, Virtual Keyboard View,, %k_WindowX%, %k_WindowY%
        this.IsVisible := true
    }

    Hide(){
        Gui, GUISecondKeyboardOverlay: Hide
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

            GuiControl, GUISecondKeyboardOverlay:, TouchScreen, % This.TouchScreenToggle
        }

        else if (device == "Bluetooth"){
            If InStr(This.BluetoothToggle, "Enable")            {
                This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Enable", "Disable")
            }
            else{
                This.BluetoothToggle := StrReplace(This.BluetoothToggle, "Disable", "Enable")
            }

            GuiControl, GUISecondKeyboardOverlay:, Bluetooth, % This.BluetoothToggle
        }

        else if (device == "Touchpad"){
            If InStr(This.TouchPadToggle, "Enable"){
                This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Enable", "Disable")
            }
            else{
                This.TouchPadToggle := StrReplace(This.TouchPadToggle, "Disable", "Enable")
            }

            GuiControl, GUISecondKeyboardOverlay:, TouchPad, % This.TouchPadToggle
        }

        else if (device == "Camera"){
            If InStr(This.CameraToggle, "Enable"){
                This.CameraToggle := StrReplace(This.CameraToggle, "Enable", "Disable")
            }
            else{
                This.CameraToggle := StrReplace(This.CameraToggle, "Disable", "Enable")
            }

            GuiControl, GUISecondKeyboardOverlay:, Camera, % This.CameraToggle
        }
    }
}








; ----------------------------------------------
; ----------- FUNCTIONS ------------------------
; ----------------------------------------------

; -----------WRITE ON SCREEN--------------------

ValidateKeyPressed(pressedKey){

    pressedKey = % StrReplace(pressedKey, "*", "")
    pressedKey = % StrReplace(pressedKey, "~", "")

    if (pressedKey == "Space"){
        pressedKey = % A_Space
    }
    else if (pressedKey == "BackSpace" && GetKeyState("Ctrl") ) {
        pressedKey = % "ctrl + backspace"
    }
    else if (pressedKey == "BackSpace"){
        ; pressedKey = % A_Space
        pressedKey = % "backspace"
    }
    if ( GetKeyState("Shift") ){
        StringUpper, pressedKey, pressedKey
    }
    else{
        StringLower, pressedKey, pressedKey
    }

    return pressedKey
}

CreateHotkey() {
	Loop, 95
	{
		k := Chr(A_Index + 31)
		k := (k = " ") ? "Space" : k
		Hotkey, % "~*" k, OnKeyPressed, on
	}

	Otherkeys := "Enter|BackSpace|ø|å|æ"
    Loop, parse, Otherkeys, |
	{
		Hotkey, % "~*" A_LoopField, OnKeyPressed, on
	}
}

DisableHotKey(){
	Loop, 95
	{
		k := Chr(A_Index + 31)
		k := (k = " ") ? "Space" : k
		Hotkey, % "~*" k, OnKeyPressed, off
	}

	Otherkeys := "Enter|BackSpace|ø|å|æ"
    Loop, parse, Otherkeys, |
	{
		Hotkey, % "~*" A_LoopField, OnKeyPressed, off
	}
}

; ------------LOGIN TO SITES----------------------

LoginToBlackboard(url){
    Run, chrome.exe %url%
    
    Sleep, 3000
    ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\feideBlackboardMaximized.png
    if (ErrorLevel = 1){
        ; MsgBox Icon could not be found on the screen.
        ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\feideBlackboardMinimized.png

        if (ErrorLevel = 1){
            ; MsgBox Icon could not be found on the screen.
        }

        else{
            MouseClick, left, MouseX, MouseY
            Sleep, 2000
            Send, ^l
            Send, %url%
            Send {Enter}
        }
    }
    else{
        MouseClick, left, MouseX, MouseY
        Sleep, 2000
        Send, ^l
        Send, %url%
        Send {Enter}
    }
}

LoginToJupyterHub(){
    ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\jupyterHubMaximized.png
    if (ErrorLevel = 1){
        ; MsgBox Icon could not be found on the screen.
        ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\jupyterHubMinimized.png

        if (ErrorLevel = 1){
            ; MsgBox Icon could not be found on the screen.
        }

        else{
            MouseClick, left, MouseX, MouseY
        }
    }
    else{
        MouseClick, left, MouseX, MouseY
    }
}

; --------------Seach----------


SearchHighlitedOrClipboard(){
    clip := clipboard
    send, ^c
    googleSearchUrl := "https://www.google.com/search?q="
    isUrl := SubStr(clipboard, 1 , 8)
    if (isUrl = "https://") {   ; if it starts with "https://" go to, rather than search in google search
        run, %clipboard%
    }
    else { ;search using google search
        joined_url = %googleSearchUrl%%clipboard%
        run, %joined_url%
        }
    clipboard := clip ;put the last copied thing back in the clipboard
    return
}

; ---------CHANGE VALUES---------------

; FIXME: this should be made more general. "CycleValue" or something. Take currentValue, lowerlimit, upperlimit and step.

CycleColorValue(colorValue){
    if (colorValue == 0){
        colorValue = 128
    }
    else if (colorValue == 128){
        colorValue = 255
    }
    else{
        colorValue = 0
    }
    Return colorValue
}
