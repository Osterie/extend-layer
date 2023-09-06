#Requires AutoHotkey v1.1.36.02
; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1

^!l:: Run *RunAs %A_ScriptDir%\extend_extra_extreme.ahk