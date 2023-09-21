; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]
#Requires AutoHotkey v1.1.36.02
#Include .\library\CountDownGUI.ahk
#Include .\library\library.ahk
#Include .\library\LayerIndicatorController.ahk


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

; ----Ensures consistency------

SetCapsLockState off

; -------------- TO-DO LIST -------------------------

; FIXME; bug, sometimes gui is shown at the lowest layer (not prioritised to show over all other apps) dont know why, but perhaps has something to do with reduced windows appereance.
; FIXME: bug, when second layer is turned on first, when shift is held down the ovelay is not shown. Fix by showing overlay when shift+Capslock is first pressed and whatever.
; TODO; able to restart a wireless router? check here and search: https://github.com/shajul/Autohotkey/blob/master/Scriplets/Wireless_Router_Restart.ahk


; TODO; should be possible to have gui over taskbar, since screen hider is over the taskbar...
; TODO; powershell is slow. is there an alternative? can it be made faster? can it be used without opening the terminal view at all?
; TODO; timer that counts down until screen turns dark, and for computer goes to sleep.

; TODO; have a timer show up when screen is about to go to sleep? probably worthless since it dimmens before turning off.

; TODO: create a class called keyboard registry or something, connect keyboard class to keyboard overlay class also.
; TODO; auto search for the copied text shortcut. (first layer obvs)

; TODO: in lib.ahk, there are two very similiar classes, use inheritance or whatever, take arguments, do something to reuse code, ugly now

; // TODO: scrape assignemtns and add to keyboard overlay? which also has link to it and color showing if it is completed or not

; TODO: connect/disconnect airpods,

;// Cant check battery temp TODO: show warning when computer gets too hot!! show temperature also

; TODO: change background of the keyboard overlay keys for disabling/enabling to have green/red background based on if it is on or off
; TODO: keyboard overlay for disabling/enabling devices should maybe use images instead of text?

; TODO: i believe the promt which apperas when a powerhsell script runs can be hidden

; TODO when screen darkened show battery percentage and maybe a countdown to sleep? maybe even make sleep impossible when screen darkened
; TODO make it possible to switch performance mode, add gui to show current mode, auto switch for screen darkner and such

; TODO FUTURE: possible to integrate with real life appliances, for example to control lights in rooms, a third layer could be created for this
; TODO: automatically slowly change gamma values for fun...

; TODO: the scroll wheel shortcut should probably only scroll once, not twice.

; TODO: a shortcut to turn the screen black(which alredy exists), but randomly change rgb values and then black. (so it looks like it is glitching.) Maybe have it connected to if mouse is used or clicked or something, maybe a certain keypress

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


; screenSleepCountdown := new ClockDisplay(3,0)
; storedSecond := A_Sec
; countdownCanceled := false

; ----------------------------------

layers := new LayerIndicatorController()
layers.addLayerIndicator(1, "Green")
layers.addLayerIndicator(2, "Red")

MonitorInstance := new Monitor()


; countdownGui := new CountdownGUI(3,3)
; countdownGui.createGui()
; countdownGui.showGui()
; countdownGui.startCountdown()



CapsLock:: 
    ; changes the layer to 0 if it is not zero, or 1 if it is zero
    layers.toggleLayerIndicator(1)
    ; shows the active layer
    layers.showLayerIndicator(layers.getActiveLayer())
    ; hides layers which are not the acrive layer
    layers.hideInactiveLayers()
    ; toggles capslock
    SetCapsLockState % !GetKeyState("CapsLock", "T")
Return

+CapsLock:: 

    activeLayer := layers.getActiveLayer()
    
    if (activeLayer == 0){
        layers.setCurrentLayerIndicator(2)
        layers.showLayerIndicator(2)
        SetCapsLockState on
    }
    else{
        layers.cycleExtraLayerIndicators()
        layers.showLayerIndicator(layers.getActiveLayer())
        layers.hideInactiveLayers()
    }
Return

^!ø::
    Reload
Return

^!w:: ;close tabs to the right
    Send \^l{F6}{AppsKey}{Up}{Enter}
    Send +{F6 2} ;go back to body of page 
Return


#IF GetKeyState("CapsLock","T") && layers.getActiveLayer() == 1

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

    ; opens a new tab in chrome which searches for the highlited content, if not content is highlighted, clipboard content is sent.
    t:: SearchHighlitedOrClipboard()
    Return


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

    G:: AppsKey
    i:: Up
    j:: Left
    k:: Down
    l:: Right

#IF


#IF GetKeyState("CapsLock","T") && layers.getActiveLayer() == 2 ; Start

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
        RunWait, powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass %A_ScriptDir%\powerShellScripts\toggle-touch-screen.exe
    Return

    +2:: 
        SecondKeyboardOverlayInstance.ChangeState("Camera")
        RunWait, powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass %A_ScriptDir%\powerShellScripts\toggle-hd-camera.exe
    Return

    +3:: 
        SecondKeyboardOverlayInstance.ChangeState("Bluetooth")
        RunWait, powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass %A_ScriptDir%\powerShellScripts\toggle-bluetooth.exe
    Return

    +4:: 
        SecondKeyboardOverlayInstance.ChangeState("Touchpad")
        RunWait, powershell.exe -NoProfile -WindowStyle hidden -ExecutionPolicy Bypass %A_ScriptDir%\powerShellScripts\toggle-touchpad.exe
    Return
    
    ; Hides screen
    A::
    ; TODO: make a function or class or whatever...
        Gui, GUIPrivacyBox: Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
        
        Gui, GUICountdown: new
        Gui, GUICountdown: +AlwaysOnTop -Caption +ToolWindow
        Gui, GUICountdown: Color, black
        Gui, GUICountdown: Font, cDA4F49
        Gui, GUICountdown: Add, Text, w200 Center vCountdown, % screenSleepCountdown.getTimeAsString()
        GuiControl, GUICountdown:, Countdown, % screenSleepCountdown.getTimeAsString()
        Gui, GUICountdown: show

        loop {
            if (storedSecond != A_Sec){
                screenSleepCountdown.decrementTime()
                GuiControl, GUICountdown:, Countdown, % A_TimeIdle
                GuiControl, GUICountdown:, Countdown, % screenSleepCountdown.getTimeAsString()
                if (A_TimeIdle + 1000 < 2000){
                    screenSleepCountdown.setTime(1,0)
                }
                storedSecond := A_Sec
            }
        } until screenSleepCountdown.isMidnight() || countdownCanceled
        return
    Return

    ; Hides window
    S::
        countdownCanceled := true
        Gui, GUICountdown: Destroy
        WinGetPos, X, Y, Width, Height, A
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        Gui, GUIPrivacyBox: Show, x%X% y%Y% w%guiWidth% h%guiHeight% NoActivate
    Return

    ; Hides tabs
    D::
        countdownCanceled := true
        Gui, GUICountdown: Destroy
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
        countdownCanceled := true
        Gui, GUICountdown: Destroy

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