; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win] is this correct?
; add macros to excecute scripts? something like that, can use extend layer to make macros that for example open upp bluetooth and turn it on...

; TODO! able to write large text on screen.
; TODO! change between users in google chrome? useful because i will have a lot of chrome tab groups for different classes.
; press numbers to launch other scripts? probably not what i want to do.
; TODO! shortcut auto open and login to blackboard, maybe use c# to do the logging and ahk to launch script?
layerTwo := 0

GUIPrivacyBox := "PrivacyGUI" 
GUILayerIndicator := "IndicatorGUI"

Gui, %GUIPrivacyBox%: Color, Black
Gui, %GUIPrivacyBox%: +AlwaysOnTop -Caption +ToolWindow

Gui, %GUILayerIndicator%: Color, Red
Gui, %GUILayerIndicator%: +AlwaysOnTop -Caption +ToolWindow


+CapsLock:: 
    
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
    ; 1::Send, (b￣◇￣)

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
    ,:: send, "{F6}" ;allows focusing tab bar in most web browsers
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
