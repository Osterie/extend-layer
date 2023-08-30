#Requires AutoHotkey v2.0
; [^ = Ctrl] [+ = Shift] [! = Alt] [# = Win]
; add macros to excecute scripts? something like that, can use extend layer to make macros that for example open upp bluetooth and turn it on...

; TODO: add a button to center the cursor? (DONE)
; TODO: add shortcuts to change between layers? (hold shift and press capslock for privacy layer?)
; Enable to allow stopping the script
; show battery percentage

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


; -----------Show Keys Pressed (make into function or something?) or class? class can have create method and destroy method idk...---------

KeysPressed := "he"
GUIshowKeysPressed := "KeysGUI" ;. IH_Count (? what does this do blah.... https://jacks-autohotkey-blog.com/2017/10/13/create-multiple-gui-pop-ups-in-a-single-script-autohotkey-scripting/#:~:text=The%20secret%20to%20building%20multiple,not%20modifying%20an%20existing%20one.%E2%80%9D)

; WinSet( TransColor, EEAA99)

; Gui( %GUIshowKeysPressed%: new ) ; Create a new GUI

; GUIshowKeysPressed := Gui()
; GUIshowKeysPressed.Opt("-Caption +AlwaysOnTop +Owner +LastFound")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
; GUIshowKeysPressed.SetColor := "White"
; ; Gui( %GUIshowKeysPressed%: -Caption +AlwaysOnTop +Owner +LastFound) 
; ; Gui( %GUIshowKeysPressed%: Color, EEAA99)
; Gui( %GUIshowKeysPressed%: Font, s20 w70 q4, Times New Roman)
; Gui( %GUIshowKeysPressed%: add, Text, w890 vKeysPressedText, %KeysPressed%)
; Gui( %GUIshowKeysPressed%: Show)

; -----------Keyboard layers---------
layerTwo := 0

GUIPrivacyBox := Gui()
GUIPrivacyBox.Opt("-Caption +AlwaysOnTop +Owner +LastFound")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
GUIPrivacyBox.BackColor := "Black"
; Gui( %GUIPrivacyBox%: Color, Black)1
; Gui( %GUIPrivacyBox%: +AlwaysOnTop -Caption +ToolWindow)


; ----------------------------------

KeyboardInstance := Keyboard()


Class Keyboard{

    GUILayerIndicator := "IndicatorGUI"
    Layer := 1
    IndicatorColor := ""

    __New() {

        This.GUILayerIndicator := Gui()
        This.GUILayerIndicator.Opt("-Caption +AlwaysOnTop +Owner +LastFound +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
        This.GUILayerIndicator.SetColor := "Red"
        ; Gui( GUILayerIndicator: Color, Red)
        ; Gui( GUILayerIndicator: +AlwaysOnTop -Caption +ToolWindow)
    }

    ToggleCapsLockStateFirstLayer(){

        if GetKeyState("CapsLock", "T") = 0
            {
                This.GUILayerIndicator.BackColor := "Green"
                guiHeight := A_ScreenHeight-142
                This.GUILayerIndicator.Show( Format("x0 y{1} w50 h142 NoActivate", guiHeight) )
            }
    
        else if (GetKeyState("CapsLock", "T") = 1)
            {
                This.GUILayerIndicator.Hide()
            }
        this.Layer := 1 
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }

    ToggleCapsLockStateSecondLayer(){

        SetCapsLockState !GetKeyState("CapsLock", "T")
    
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

            This.GUILayerIndicator.BackColor := This.IndicatorColor
            guiHeight := A_ScreenHeight-142
            This.GUILayerIndicator.Show( Format("x0 y{1} w50 h142 NoActivate", guiHeight) )
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
            This.GUILayerIndicator.BackColor := This.IndicatorColor
            guiHeight := A_ScreenHeight-142
            This.GUILayerIndicator.Show( Format("x0 y{1} w50 h142 NoActivate", guiHeight) )
            SetCapsLockState true
        }

    }
}


; O::{
;     %KeysPressed% = ""
;     SetTimer (UserInput,10)
; }

; I::{
;     SetTimer (UserInput, Off)
; }

CapsLock:: KeyboardInstance.ToggleCapsLockStateFirstLayer()
+CapsLock:: KeyboardInstance.ToggleCapsLockStateSecondLayer()


#HOTIF GetKeyState("CapsLock","T") && KeyboardInstance.Layer == 1

    
    1:: Run A_ComSpec Format(' /c {1}\powerShellScripts\toggle-touch-screen.exe" ', A_ScriptDir)
    2:: Run A_ComSpec Format(' /c {1}\powerShellScripts\toggle-hd-camera.exe" ', A_ScriptDir) 

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

    ; t:: MouseMove, 0   , -100 , 0, R
    ; g:: MouseMove, 0   , 20   , 0, R
    ; ,:: MouseMove, -100, 0    , 0, R
    ; .:: MouseMove, 20  , 0    , 0, R

    ,:: F6 ;allows focusing tab bar in most web browsers
    <:: MouseMove( (A_ScreenWidth//2)  , (A_ScreenHeight//2) )

    i:: Up
    j:: Left
    k:: Down
    l:: Right

#HOTIF


#HOTIF GetKeyState("CapsLock","T") && KeyboardInstance.Layer == 2 ; Start

    ; Hides screen
    A:: {
        GUIPrivacyBox.Show( Format("x0 y0 w{1} h{2} NoActivate", A_ScreenWidth, A_ScreenHeight) )
    }

    ; Hides window
    S::{
        WinGetPos( &XPos, &YPos, &Width, &Height, "A" )
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        GUIPrivacyBox.Show( Format("x{1} y{2} w{3} h{4} NoActivate", XPos, YPos, guiWidth, guiHeight) )
    }

    ; Hides tabs
    D::{

        ; WinGetActiveTitle(Title)
        ActiveWindowTitle := WinGetTitle("A")
            If (InStr(ActiveWindowTitle, "Google Chrome") || InStr(ActiveWindowTitle, "Mozilla Firefox") || InStr(ActiveWindowTitle, "Edge")){
                WinGetPos( &XPos, &YPos, &Width, &Height, "A" )
                guiWidth := Width*0.55
                GUIPrivacyBox.Show( Format("x{1} y{2} w{3} h40 NoActivate", XPos, YPos, guiWidth) )
            }
    
            Else If (InStr(ActiveWindowTitle, "Visual Studio")){
                WinGetPos( &XPos, &YPos, &Width, &Height, "A" )
                guiX := (XPos*1)+60
                guiY := (YPos*1)+45
                guiWidth := Width*0.66
                GUIPrivacyBox.Show( Format("x{1} y{2} w{3} h40 NoActivate", XPos, YPos, guiWidth) )
            }
    }

    ; Hides GUI
    F:: {
        GUIPrivacyBox.Hide()
    }

#HOTIF ; End

; UserInput:

;     Input, KeyPressed, L1 V, {Space}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}
    
;     if (KeyPressed = "i" Or KeyPressed = "p"){
;         SetTimer, UserInput, Off
;         Return
;     }

;     time := A_TickCount
;     KeyWait, %KeyPressed%
;     timePressedDown := A_TickCount - time
;     ToolTip User interaction at %A_Hour%:%A_Min%:%A_Sec%

;     KeysPressed = %KeysPressed%%KeyPressed%
;     GuiControl, %GUIshowKeysPressed%: show,  KeysPressedText, % KeysPressed
; Return

; Escape::{
;     ExitApp
; }
; return
