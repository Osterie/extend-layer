﻿#Requires AutoHotkey v1.1.36.02

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1

; ----------- CLASSES ------------------------

Class Keyboard{

    Layer := 1
    IndicatorColor := ""

    __New() {

        Gui, GUILayerIndicator: new
        Gui, GUILayerIndicator: +AlwaysOnTop -Caption +ToolWindow
    }

    ToggleCapsLockStateFirstLayer(){

        SetCapsLockState % !GetKeyState("CapsLock", "T")
        
        if GetKeyState("CapsLock", "T") = 0{
            Gui, GUILayerIndicator: Hide
            this.Layer := 0 

        }
        else if (GetKeyState("CapsLock", "T") = 1){
            Gui, GUILayerIndicator: Color, Green
            guiHeight := A_ScreenHeight-142
            Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
            this.Layer := 1
        }
    }

    ToggleCapsLockStateSecondLayer(){

        if GetKeyState("CapsLock", "T") = 0{
            SetCapsLockState on            
        }

        if (This.Layer == 0 || This.Layer == 1){
            This.IndicatorColor := "Red"
            This.Layer := 2
        }
        else if (This.Layer == 0 || This.Layer == 2){
            This.IndicatorColor := "Green"
            This.Layer := 1
        }

        Gui, GUILayerIndicator: Color, % This.IndicatorColor
        guiHeight := A_ScreenHeight-142
        Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
    }

    ActivateFirstLayer(){

    }

    ActivateSecondLayer(){
        
    }

}

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


    <p> window.location.pathname </p>

    __New(){

        ; ------------------------GET DEVICE STATES--------------------------------
        deviceToggles := ""

        ; Capture the output and error separately
        FileDelete, %A_ScriptDir%\output.txt
        ; RunWait, %A_ScriptDir%\powerShellScripts\toggle-touch-screen.exe
        RunWait, powershell.exe -ExecutionPolicy Bypass -Command "& { . '%A_ScriptDir%\powerShellScripts\get-device-states.exe' } 2> %A_ScriptDir%\error.txt > %A_ScriptDir%\output.txt", , UseErrorLevel UseStderr

        ; Read the captured output and error from the files
        FileRead, deviceToggles, %A_ScriptDir%\output.txt

        ; Delete the files after reading them
        FileDelete, %A_ScriptDir%\output.txt

        StringSplit, deviceTogglesArray, deviceToggles, `n,
        

        This.BluetoothToggle := deviceTogglesArray1
        This.TouchPadToggle := deviceTogglesArray2
        This.TouchScreenToggle := deviceTogglesArray3
        This.CameraToggle := deviceTogglesArray4

        ; This.BluetoothToggle := "test"

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


Class Monitor{

    ; red 
    ; green
    ; blue
    ; brightnees

    SetBrightness( ByRef brightness := 50, timeout = 1 )
    {
        if ( brightness >= 0 && brightness <= 100 )
        {
            For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightnessMethods" )
                property.WmiSetBrightness( timeout, brightness )	
        }
         else if ( brightness > 100 )
         {
             brightness := 100
         }
         else if ( brightness < 0 )
         {
             brightness := 0
         }
    }
    
    GetCurrentBrightness()
    {
        For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightness" )
            currentBrightness := property.CurrentBrightness	
    
        return currentBrightness
    }
    
    ; Each parameter takes values from 0 to 255
    ; Change gamma of display, 0 dark, 128 normal, 255 bright
    SetGamma(red, green, blue){
        VarSetCapacity(gammaRamp, 512*3)
        Loop,	256
        {
            If  (newRed:=(red+128)*(A_Index-1))>65535
                 newRed:=65535
            NumPut(newRed, gammaRamp, 2*(A_Index-1), "Ushort")
    
            If  (newGreen:=(green+128)*(A_Index-1))>65535
                newGreen:=65535
            NumPut(newGreen, gammaRamp,  512+2*(A_Index-1), "Ushort")
            
            If  (newBlue:=(blue+128)*(A_Index-1))>65535
                newBlue:=65535
            NumPut(newBlue, gammaRamp, 1024+2*(A_Index-1), "Ushort")
        }
        hDC := DllCall("GetDC", "Uint", 0)
        DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gammaRamp)
        DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
    }

    GetCurrentGamma(){
    
        VarSetCapacity(gammaRamp, 1536, 0)
        hDC := DllCall("user32\GetDC", Ptr,0, Ptr)
        DllCall("gdi32\GetDeviceGammaRamp", Ptr,hDC, Ptr,&gammaRamp)

        gammaRampList := []
        gammaRampList["Red"]   := NumGet(gammaRamp,        2, "ushort") - 128
        gammaRampList["Green"] := NumGet(gammaRamp,  512 + 2, "ushort") - 128
        gammaRampList["Blue"]  := NumGet(gammaRamp, 1024 + 2, "ushort") - 128

        Return gammaRampList

    }
}


; ----------------------------------------------
; ----------- FUNCTIONS ------------------------
; ----------------------------------------------

; -----------WRITE ON SCREEN--------------------

ValidateKeyPressed(key){

    key = % StrReplace(key, "*", "")
    key = % StrReplace(key, "~", "")

    if (key == "Space"){
        key = % A_Space
    }
    else if (key == "BackSpace" && GetKeyState("Ctrl") ) {
        key = % "ctrl + backspace"
    }
    else if (key == "BackSpace"){
        ; key = % A_Space
        key = % "backspace"
    }
    if ( GetKeyState("Shift") ){
        StringUpper, key, key
    }
    else{
        StringLower, key, key
    }

    return key
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
    
    Sleep, 4000
    ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\feideBlackboardMaximized.png
    if (ErrorLevel = 1){
        ; MsgBox Icon could not be found on the screen.
        ImageSearch, MouseX, MouseY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\imageSearchImages\feideBlackboardMinimized.png

        if (ErrorLevel = 1){
            ; MsgBox Icon could not be found on the screen.
        }

        else{
            MouseClick, left, MouseX, MouseY
            Send, ^l
            Send, %url%
            Send {Enter}
        }
    }
    else{
        MouseClick, left, MouseX, MouseY
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

; ---------CHANGE VALUES---------------

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
