; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]
#Requires AutoHotkey v1.1.36.02
#Include library.ahk

;---------------------- OPTIMIZATIONS ------------------

#NoEnv
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
ListLines Off
Process, Priority, , A
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
DllCall("ntdll\ZwSetTimerResolution","Int",5000,"Int",1,"Int*",MyCurrentTimerResolution) ;setting the Windows Timer Resolution to 0.5ms, THIS IS A GLOBAL CHANGE

;--------------------- Runs AHK script as Admin, allows excecution scripts which require admin privilleges -------------------

SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

; -------------- TO-DO LIST -------------------------



; TODO: in lib.ahk, there are two very similiar classes, use inheritance or whatever, take arguments, do something to reuse code, ugly now

; // TODO: scrape assignemtns and add to keyboard overlay? which also has link to it and color showing if it is completed or not

; TODO: connect/disconnect airpods,

;// Cant check battery temp TODO: show warning when computer gets too hot!! show temperature also

; TODO: set brightness to full, and set it to zero shortcut

; TODO: change background of the keyboard overlay keys for disabling/enabling to have green/red background based on if it is on or off
; TODO: keyboard overlay for disabling/enabling devices should maybe use images instead of text?

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO: the url to the schedule can be changed to "from the current week to week 48" so i dont have to scroll

; TODO when screen darkened show battery percentage and maybe a countdown to sleep? maybe even make sleep impossible when screen darkened
; TODO make it possible to switch performance mode, add gui to show current mode, auto switch for screen darkner and such

; WinKill, "C:\Users\adria\github\extend-layer\secondLayerKeyboardOverlay.ahk"

; TODO: both first and second layer use keys to run scripts/go to urls, have a overlay keyboard for each to show which keys do what
; At the same time, the keys can change color for the "Deactivate/Activate" shortcuts.

; TODO: Create functions in lib.ahk

; TODO: maybe have a gui to show which keys to press to go to which url

; TODO: automatically slowly change gamma values for fun...

; ? maybe make a function to show / hide gui, since i often do it...

; TODO: Mute all windowes except spotify?.

; make it harder to switch layer if a certain button is pressed? (locks layer and requires a key combination to disable the layer)

; TODO! shortcut auto open and login to blackboard, maybe use c# to do the logging and ahk to launch script?
; TODO! maybe have indicators to check if camera/tocuh screen is disabled, maybe image of camra and screen with green or red square under, can toggle gui.


; -----------Show Keys Pressed (make into function or something?) or class? class can have create method and destroy method idk...---------
;------------- Second layer ctrl + 0 (^0) shortcut, shows a gui which can be written text into.------------


KeysPressed := ""
toggleKeysGUI := 0

Gui, GUIshowKeysPressed: new ; Create a new GUI
Gui, GUIshowKeysPressed: -Caption +AlwaysOnTop +Owner +LastFound 
Gui, GUIshowKeysPressed: Color, EEAA99
Gui, GUIshowKeysPressed: Font, s20 w70 q4, Times New Roman
Gui, GUIshowKeysPressed: add, Text, w890  h300 vKeysPressedText, %KeysPressed%


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

; -----------Keyboard layers---------

Gui, GUIPrivacyBox: new
Gui, GUIPrivacyBox: +AlwaysOnTop -Caption +ToolWindow
Gui, GUIPrivacyBox: Color, Black

; ----------------------------------


KeyboardInstance := new Keyboard()

FirstKeyboardOverlayInstance := new FirstKeyboardOverlay()
FirstKeyboardOverlayInstance.CreateKeyboardOverlay()

SecondKeyboardOverlayInstance := new SecondKeyboardOverlay()
SecondKeyboardOverlayInstance.CreateKeyboardOverlay()

MonitorInstance := new Monitor()


CapsLock:: 
    KeyboardInstance.ToggleCapsLockStateFirstLayer()
Return


+CapsLock:: 
    KeyboardInstance.ToggleCapsLockStateSecondLayer()

    if (FirstKeyboardOverlayInstance.GetVisibility() == true){
        FirstKeyboardOverlayInstance.Hide()
        SecondKeyboardOverlayInstance.Show()

    }
    else if (SecondKeyboardOverlayInstance.GetVisibility() == true){
        SecondKeyboardOverlayInstance.Hide()
        FirstKeyboardOverlayInstance.Show()

    }
    
Return


#IF GetKeyState("CapsLock","T") && KeyboardInstance.Layer == 1

    ~Shift:: 
        FirstKeyboardOverlayInstance.Show()
        keywait, Shift
    return

    Shift up:: 
        SecondKeyboardOverlayInstance.Hide()
        FirstKeyboardOverlayInstance.Hide()
    return


    ; Go to study plan (from current week to end of first semester currently)
    +1::
        Run, chrome.exe "https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&"
    Return

    ; Go to blackboard
    +2:: 
        Run, chrome.exe "https://ntnu.blackboard.com/ultra/course"
        Sleep, 4000
    Return
    ; Go to programming 1
    +3:: 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline")
    Return

    ; Go to team class
    +4:: 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_39995_1/cl/outline")
    Return

    ; Go to Math
    +5:: 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_44996_1/cl/outline")
    Return
    
    ; Go to programming and numeric safety stuff...
    +6:: 
        LoginToBlackboard("https://ntnu.blackboard.com/ultra/courses/_43055_1/cl/outline")
    Return

    ; Go to jupyterhub
    +7:: 
        Run, chrome.exe "https://inga1002.apps.stack.it.ntnu.no/user/adriangb/lab"
        Sleep, 2000
        LoginToJupyterHub()
    Return

    ; Shows gui which can be written in to help classmates/colleagues or whatever
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

    ~Shift:: 
        SecondKeyboardOverlayInstance.Show()
        keywait, Shift
    return

    Shift up:: 
        FirstKeyboardOverlayInstance.Hide()
        SecondKeyboardOverlayInstance.Hide()
    return

    +1:: 
        SecondKeyboardOverlayInstance.ChangeState("Touch-Screen")
        RunWait, %A_ScriptDir%\powerShellScripts\toggle-touch-screen.exe
    Return

    +2:: 
        SecondKeyboardOverlayInstance.ChangeState("Camera")
        RunWait  %A_ScriptDir%\powerShellScripts\toggle-hd-camera.exe
    Return

    +3:: 
        SecondKeyboardOverlayInstance.ChangeState("Bluetooth")
        RunWait  %A_ScriptDir%\powerShellScripts\toggle-bluetooth.exe
    Return

    +4:: 
        SecondKeyboardOverlayInstance.ChangeState("Touchpad")
        RunWait  %A_ScriptDir%\powerShellScripts\toggle-touchpad.exe
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

    ; Blocks input from keyboard and mouse, can be deactivated using pipe (|)
    q::
        BlockInput On
        BlockInput, MouseMove
        Suspend On
    Return

    ; If input is blocked (q has been pressed while in second layer), it can be enabled again.
    $|::
        Suspend Permit
        BlockInput Off
        BlockInput, MouseMoveOff
        Suspend Off
    Return


    u:: 
        brightness := MonitorInstance.GetCurrentBrightness()
        if (brightness == 100){
            MonitorInstance.SetBrightness(50)
        }
        else{
            MonitorInstance.SetBrightness(100)
        }
    Return

    j:: 
        brightness := MonitorInstance.GetCurrentBrightness()
        if (brightness == 0){
            MonitorInstance.SetBrightness(50)
        }
        else{
            MonitorInstance.SetBrightness(0)
        }
    Return

    i:: 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp["Red"]
        green := gammaRamp["Green"]
        blue := gammaRamp["Blue"]

        if ( (red + green + blue) == 0 ){
            MonitorInstance.SetGamma(128, 128, 128)
        }
        else{
            MonitorInstance.SetGamma(0, 0, 0)
        }
    Return 

    o:: 
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp["Red"]
        green := gammaRamp["Green"]
        blue := gammaRamp["Blue"]

        if ( (red + green + blue) < 255*3 ){
            MonitorInstance.SetGamma(255, 255, 255) 
        }
        else{
            MonitorInstance.SetGamma(128, 128, 128)
        }
    Return

    k::
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp["Red"]
        red := CycleColorValue(red)
        green := gammaRamp["Green"]
        blue := gammaRamp["Blue"]

        MonitorInstance.SetGamma(red, green, blue)
    Return

    l::
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp["Red"]
        green := gammaRamp["Green"]
        green := CycleColorValue(green)
        blue := gammaRamp["Blue"]

        MonitorInstance.SetGamma(red, green, blue)
    Return
    
    ø::
        gammaRamp := MonitorInstance.GetCurrentGamma()
        red := gammaRamp["Red"]
        green := gammaRamp["Green"]
        blue := gammaRamp["Blue"]
        blue := CycleColorValue(blue)

        MonitorInstance.SetGamma(red, green, blue)
    Return

    Esc::ExitApp

#IF ; End:)