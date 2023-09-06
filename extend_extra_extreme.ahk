; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win] is this correct?
; add macros to excecute scripts? something like that, can use extend layer to make macros that for example open upp bluetooth and turn it on...


msgbox, %A_AhkVersion%

; todo shortcuts to go to blackboard an the class i want, f.eks math, prog 1 and such (use urls probably)
; TODO: add a button to center the cursor? (DONE)
; TODO: add shortcuts to change between layers? (hold shift and press capslock for privacy layer?)
; Enable to allow stopping the script
; show battery percentage
; Mute all windowes except spotify?.

; TODO: make scraper which scraps classes i am going to have for the week and a gui which can be displayed showing the classes i will
; have for the week, and for the day...

; Disable mouse shortcut, maybe for the 2 layer? RButton LButton probably

; make it harder to switch layer if a certain button is pressed? (locks layer and requires a key combination to disable the layer)


; TODO! able to write large text on screen.
; TODO! change between users in google chrome? useful because i will have a lot of chrome tab groups for different classes.
; press numbers to launch other scripts? probably not what i want to do.
; TODO! shortcut auto open and login to blackboard, maybe use c# to do the logging and ahk to launch script?
; TODO! script to enable/disable camera, enable/disable touch screen.
; TODO! maybe have indicators to check if camera/tocuh screen is disabled, maybe image of camra and screen with green or red square under, can toggle gui.

; TODO! move script to own folder with scripts and such in it also for relative pathing...

; Runs AHK script as Admin, allows excecution scripts which require admin privilleges
; SetWorkingDir %A_ScriptDir%
; if not A_IsAdmin
; 	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.



layerTwo := 0

GUIshowKeysPressedAndDuration := "KeysGUI" ;. IH_Count (? what does this do blah.... https://jacks-autohotkey-blog.com/2017/10/13/create-multiple-gui-pop-ups-in-a-single-script-autohotkey-scripting/#:~:text=The%20secret%20to%20building%20multiple,not%20modifying%20an%20existing%20one.%E2%80%9D)
GUIPrivacyBox := "PrivacyGUI" 
GUILayerIndicator := "IndicatorGUI"


KeysPressed := "hei"
KeysPressedDurations := "hei"

Gui, %GUIshowKeysPressedAndDuration%: new ; Create a new GUI
Gui, %GUIshowKeysPressedAndDuration%: -Caption +AlwaysOnTop +Owner +LastFound 
WinSet, TransColor, EEAA99
Gui, %GUIshowKeysPressedAndDuration%: Color, EEAA99
Gui, %GUIshowKeysPressedAndDuration%: Font, s20 w70 q4, Times New Roman
Gui, %GUIshowKeysPressedAndDuration%: add, Text, w890 vKeysPressedText, %KeysPressed%
Gui, %GUIshowKeysPressedAndDuration%: add, Text, w890 vKeysPressedDurationsText, %KeysPressedDurations%
Gui, %GUIshowKeysPressedAndDuration%: Show

Gui, %GUIPrivacyBox%: Color, Black
Gui, %GUIPrivacyBox%: +AlwaysOnTop -Caption +ToolWindow

Gui, %GUILayerIndicator%: Color, Red
Gui, %GUILayerIndicator%: +AlwaysOnTop -Caption +ToolWindow


; O::
;     KeysPressed = 
;     KeysPressedDurations = 
;     SetTimer,UserInput,10
; Return

; I::
;     SetTimer, UserInput, Off
; Return

UserInput:

    Input, KeyPressed, L1 V, {LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
    
    if (KeyPressed = "i" Or KeyPressed = "p"){
        SetTimer, UserInput, Off
        Return
    }

    time := A_TickCount
    KeyWait, %KeyPressed%
    timePressedDown := A_TickCount - time
    ToolTip User interaction at %A_Hour%:%A_Min%:%A_Sec%

    KeysPressed = %KeysPressed%%KeyPressed%
    GuiControl, %GUIshowKeysPressedAndDuration%:,  KeysPressedText, % KeysPressed
Return



Rshift & CapsLock:: 
    
    SetCapsLockState % !GetKeyState("CapsLock", "T")

    if GetKeyState("CapsLock", "T") = 1
    {
        layerTwo = % !layerTwo
        IndicatorColor := (layerTwo ? "Red" : "Green")
        Gui, %GUILayerIndicator%: Color, %IndicatorColor%
        guiHeight := A_ScreenHeight-142
        Gui, %GUILayerIndicator%: Show, x0 y%guiHeight% w50 h142 NoActivate
    }
    else if GetKeyState("CapsLock", "T") = 0
    {
        layerTwo = % !layerTwo
        IndicatorColor := (layerTwo ? "Red" : "Green")
        Gui, %GUILayerIndicator%: Color, %IndicatorColor%
        guiHeight := A_ScreenHeight-142
        Gui, %GUILayerIndicator%: Show, x0 y%guiHeight% w50 h142 NoActivate
        SetCapsLockState, on
    }

Return

CapsLock:: 
    if GetKeyState("CapsLock", "T") = 0
        {
            Gui, %GUILayerIndicator%: Color, Green
            
            guiHeight := A_ScreenHeight-142
            Gui, %GUILayerIndicator%: Show, x0 y%guiHeight% w50 h142 NoActivate
        }

    else if GetKeyState("CapsLock", "T") = 1
        {
            Gui, %GUILayerIndicator%: Hide
        }
    layerTwo = 0
    SetCapsLockState % !GetKeyState("CapsLock", "T")
Return




#IF GetKeyState("CapsLock","T") && layerTwo

    ; Hides screen
    A::
    Gui, %GUIPrivacyBox%: Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate
    Return

    ; Hides window
    S::
        WinGetPos, X, Y, Width, Height, A
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        Gui, %GUIPrivacyBox%: Show, x%X% y%Y% w%guiWidth% h%guiHeight% NoActivate
        Return

    ; Hides tabs
    D::
        WinGetActiveTitle, Title
        If (InStr(Title, "Google Chrome") || InStr(Title, "Mozilla Firefox") || InStr(Title, "Edge")){
            WinGetPos, X, Y, Width, Height, A
            guiWidth := Width*0.55
            Gui, %GUIPrivacyBox%: Show, x%X% y%Y% w%guiWidth% h40 NoActivate
        }

        Else If (InStr(Title, "Visual Studio")){
            WinGetPos, X, Y, Width, Height, A
            guiX := (X*1)+60
            guiY := (Y*1)+45
            guiWidth := Width*0.66
            Gui, %GUIPrivacyBox%: Show, x%guiX% y%guiY% w%guiWidth% h40 NoActivate
        }
    Return

    ; Hides GUI
    F::
        Gui, %GUIPrivacyBox%: Hide
    Return

#IF

#IF GetKeyState("CapsLock","T") && !layerTwo

    1:: Run  %A_ScriptDir%\toggle-touch-screen.exe

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

    z:: send, ^z 
    Return
    x:: send, ^x 
    Return
    c:: send, ^c 
    Return
    v:: send, ^v 
    Return

    m::Click

    ; t:: MouseMove, 0   , -100 , 0, R
    ; g:: MouseMove, 0   , 20   , 0, R
    ; ,:: MouseMove, -100, 0    , 0, R
    ,:: send, {F6} ;allows focusing tab bar in most web browsers
    Return
    ; .:: MouseMove, 20  , 0    , 0, R
    <:: MouseMove, (A_ScreenWidth//2)  , (A_ScreenHeight//2)

    i:: Up
    j:: Left
    k:: Down
    l:: Right
#IF


; TODO: add a button to center the cursor? (DONE)
; TODO: add shortcuts to change between layers? (hold shift and press capslock for privacy layer?)
; Enable to allow stopping the script

; Escape::
; ExitApp
; return
