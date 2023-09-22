#Requires AutoHotkey v2.0
; #Requires AutoHotkey v1.1.36.02
; #Include .\library\CountDownGUI.ahk
; #Include .\library\library.ahk
; #Include .\library\Monitor.ahk
; #Include .\library\LayerIndicatorController.ahk

A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 0
ListLines False
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1

; a:: j
; s:: k
; d:: l
; w:: i

Esc::ExitApp
