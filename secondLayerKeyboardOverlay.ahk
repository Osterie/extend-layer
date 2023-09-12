#Requires AutoHotkey v1.1.36.02
 
; Changing this font size will resize the keyboard:
k_FontSize = 10
k_FontName = Verdana  ; This can be blank to use the system's default font.
k_FontStyle = Bold    ; Example of an alternative: Italic Underline

; Gui
Gui, Font, s%k_FontSize% %k_FontStyle%, %k_FontName%
Gui, +E0x20 -Caption +AlwaysOnTop -MaximizeBox +ToolWindow


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
k_KeyMargin := k_FontSize // 10
; Only a facilitator for creating GUI.
k_KeySizeDestination = w%k_KeyWidthDestination% h%k_KeyHeightDestination%
k_PositionDestinationRow = x+%k_KeyMargin% %k_KeySizeDestination%

;   The first row.
Gui, Add, Button, %k_PositionHelperRow%, 1
Gui, Add, Button, %k_PositionHelperRow%, 2
Gui, Add, Button, %k_PositionHelperRow%, 3
Gui, Add, Button, %k_PositionHelperRow%, 4
Gui, Add, Button, %k_PositionHelperRow%, 5
Gui, Add, Button, %k_PositionHelperRow%, 6 
Gui, Add, Button, %k_PositionHelperRow%, 7 
Gui, Add, Button, %k_PositionHelperRow%, 8 
Gui, Add, Button, %k_PositionHelperRow%, 9 
Gui, Add, Button, %k_PositionHelperRow%, 0

;   The second row.
Gui, Add, Button, xm y+%k_KeyMargin% h%k_KeyHeight% w%k_PositionDestinationRow%, Time Table
Gui, Add, Button, %k_PositionDestinationRow%, Black Board
Gui, Add, Button, %k_PositionDestinationRow%, Prog 1
Gui, Add, Button, %k_PositionDestinationRow%, Team
Gui, Add, Button, %k_PositionDestinationRow%, Math
Gui, Add, Button, %k_PositionDestinationRow%, Prog Num Sec
Gui, Add, Button, %k_PositionDestinationRow%, Jupyter Hub
Gui, Add, Button, %k_PositionDestinationRow%, 8 
Gui, Add, Button, %k_PositionDestinationRow%, 9 
Gui, Add, Button, %k_PositionDestinationRow%, 0

;---- Show the keyboard centered but not active (to maintain the current window's focus):
Gui, Show, xCenter NoActivate, Virtual Keyboard View
 
;   Control whether the virtual keyboard is displayed on the screen or not.
k_IsVisible = y
 
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

; Show or hide the keyboard if the variable is "y" or "n".
Ctrl & `::
k_ShowHide:
    if k_IsVisible = y
    {
        ; Hide the keyboard gui, change the tray option's name,
        ; and flip visibility.
        Gui, Hide
        k_IsVisible = n
    }
    else
    {
        ; Do the opposite.
        Gui, Show
        k_IsVisible = y
    }
return