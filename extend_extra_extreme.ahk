#Requires AutoHotkey v1.1.36.02
; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1

; TODO: maybe have a gui to show which keys to press to go to which url, can be integrated with the show class schedule gui (make it)

; ? maybe make a function to show / hide gui, since i often do it...

; TODO: add shortcuts to change between layers? (hold shift and press capslock for privacy layer?)
; TODO: Create second script which can stop extend_extra_extreme.ahk and also run it. (as Admin!)
; TODO: show battery percentage
; TODO: Mute all windowes except spotify?.

; make it harder to switch layer if a certain button is pressed? (locks layer and requires a key combination to disable the layer)

; TODO! shortcut auto open and login to blackboard, maybe use c# to do the logging and ahk to launch script?
; TODO! maybe have indicators to check if camera/tocuh screen is disabled, maybe image of camra and screen with green or red square under, can toggle gui.

; Runs AHK script as Admin, allows excecution scripts which require admin privilleges
; SetWorkingDir %A_ScriptDir%
; if not A_IsAdmin
; 	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; -----------Show Keys Pressed (make into function or something?) or class? class can have create method and destroy method idk...---------

KeysPressed := ""
toggleKeysGUI := 0

Gui, GUIshowKeysPressed: new ; Create a new GUI
Gui, GUIshowKeysPressed: -Caption +AlwaysOnTop +Owner +LastFound 
Gui, GUIshowKeysPressed: Color, EEAA99
Gui, GUIshowKeysPressed: Font, s20 w70 q4, Times New Roman
Gui, GUIshowKeysPressed: add, Text, w890  h300 vKeysPressedText, %KeysPressed%

; -----------Keyboard layers---------

#IF
	OnKeyPressed:
		try {
            
			key := ValidateKeyPressed(A_ThisHotKey)

            if (key == "backspace"){
                StringTrimRight, KeysPressed, KeysPressed, 1
            }
            else if (key == "ctrl + backspace"){

                if (SubStr(KeysPressed,0,1) == " ") {
                    StringTrimRight, KeysPressed, KeysPressed, 1
                }

                else if (!InStr(KeysPressed, " ")){
                    KeysPressed = % ""
                }
                LastUnderScorePosition := InStr(KeysPressed," ",0,0)  ; get position of last occurrence of " "
                KeysPressed := SubStr(KeysPressed,1,LastUnderScorePosition)  ; get substring from start to last dot
            }

            else if (key == "enter"){
                KeysPressed = %KeysPressed%`n
                
            }
            else{
                KeysPressed = % KeysPressed key
            }
            GuiControl, GUIshowKeysPressed:, KeysPressedText, % KeysPressed
		}

#IF

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


Gui, GUIPrivacyBox: new
Gui, GUIPrivacyBox: +AlwaysOnTop -Caption +ToolWindow
Gui, GUIPrivacyBox: Color, Black

; ----------------------------------

Class Keyboard{

    Layer := 1
    IndicatorColor := ""

    __New() {

        Gui, GUILayerIndicator: new
        Gui, GUILayerIndicator: +AlwaysOnTop -Caption +ToolWindow
    }

    ToggleCapsLockStateFirstLayer(){

        if GetKeyState("CapsLock", "T") = 0
            {
                Gui, GUILayerIndicator: Color, Green
                guiHeight := A_ScreenHeight-142
                Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
            }
    
        else if (GetKeyState("CapsLock", "T") = 1)
            {
                Gui, GUILayerIndicator: Hide
            }
        this.Layer := 1 
        SetCapsLockState % !GetKeyState("CapsLock", "T")
    }

    ToggleCapsLockStateSecondLayer(){

        SetCapsLockState % !GetKeyState("CapsLock", "T")
    
        if GetKeyState("CapsLock", "T") = 1
        {
            if (This.Layer == 1){
                This.IndicatorColor := "Red"
                This.Layer := 2
            }
            else if (This.Layer == 2){
                This.IndicatorColor := "Green"
                This.Layer := 1
            }


            Gui, GUILayerIndicator: Color, % This.IndicatorColor
            guiHeight := A_ScreenHeight-142
            Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
        }
        else if GetKeyState("CapsLock", "T") = 0
        {
            if (This.Layer == 1){
                This.IndicatorColor := "Red"
                This.Layer := 2
            }
            else if (This.Layer == 2){
                This.IndicatorColor := "Green"
                This.Layer := 1
            }

            Gui, GUILayerIndicator: Color, % This.IndicatorColor
            guiHeight := A_ScreenHeight-142
            Gui, GUILayerIndicator: Show, x0 y%guiHeight% w50 h142 NoActivate
            SetCapsLockState on
        }
    }
}

KeyboardInstance := new Keyboard()

CapsLock:: KeyboardInstance.ToggleCapsLockStateFirstLayer()
+CapsLock:: KeyboardInstance.ToggleCapsLockStateSecondLayer()

#IF GetKeyState("CapsLock","T") && KeyboardInstance.Layer == 1

    1:: Run  %A_ScriptDir%\toggle-touch-screen.exe
    2:: Run  %A_ScriptDir%\toggle-hd-camera.exe
    3:: Run  %A_ScriptDir%\toggle-bluetooth.exe
    4:: Run  %A_ScriptDir%\toggle-touchpad.exe

    q:: Esc
    å:: Esc
    
    a:: Alt
    d:: Shift
    f:: Ctrl
    n:: Tab

    w:: WheelUp
    s:: WheelDown

    e:: Browser_Back
    r:: Browser_Forward

    y:: PgUp
    h:: PgDn

    u:: Home
    o:: End
    p:: Del
    ø:: BackSpace

    z:: ^z
    x:: ^x
    c:: ^c
    v:: ^v

    m::Click

    ,:: F6 ;allows focusing tab bar in most web browsers
    <:: MouseMove, (A_ScreenWidth//2)  , (A_ScreenHeight//2)

    i:: Up
    j:: Left
    k:: Down
    l:: Right

#IF


#IF GetKeyState("CapsLock","T") && KeyboardInstance.Layer == 2 ; Start

    ; Go to study plan
    1:: Run, chrome.exe "https://tp.educloud.no/ntnu/timeplan/?type=student&&&week=34&weekTo=48&ar=2023&&id[]=38726&&"

    ; Go to blackboard
    2:: Run, chrome.exe "https://ntnu.blackboard.com/ultra/course"

    ; Go to programming 1
    3:: Run, chrome.exe "https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline"

    ; Go to team class
    4:: Run, chrome.exe "https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline"

    ; Go to Math
    5:: Run, chrome.exe "https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline"

    ; Go to programming and numeric safety stuff...
    6:: Run, chrome.exe "https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline"

    ; Go to jupyterhub
    7:: Run, chrome.exe "https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab"

    ^0:: 
        toggleKeysGUI = % !toggleKeysGUI
        if (toggleKeysGUI){
            CreateHotkey()
            Gui, GUIshowKeysPressed: Show 
        }
        else {
            DisableHotKey()
            KeysPressed = % ""
            GuiControl, GUIshowKeysPressed:, KeysPressedText, % KeysPressed
            Gui, GUIshowKeysPressed: Hide

        }
    Return    
    
    ; Hides screen
    A::
        Gui, GUIPrivacyBox: Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
    Return

    ; Hides window
    S::
        WinGetPos, X, Y, Width, Height, A
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        Gui, GUIPrivacyBox: Show, x%X% y%Y% w%guiWidth% h%guiHeight% NoActivate
        Return

    ; Hides tabs
    D::
        WinGetActiveTitle, Title
        If (InStr(Title, "Google Chrome") || InStr(Title, "Mozilla Firefox") || InStr(Title, "Edge")){
            WinGetPos, X, Y, Width, Height, A
            guiWidth := Width*0.55
            Gui, GUIPrivacyBox: Show, x%X% y%Y% w%guiWidth% h40 NoActivate
        }

        Else If (InStr(Title, "Visual Studio")){
            WinGetPos, X, Y, Width, Height, A
            guiX := (X*1)+60
            guiY := (Y*1)+45
            guiWidth := Width*0.66
            Gui, GUIPrivacyBox: Show, x%guiX% y%guiY% w%guiWidth% h40 NoActivate
        }
    Return

    ; Hides GUI
    F::
        Gui, GUIPrivacyBox: Hide
    Return

#IF ; End
return