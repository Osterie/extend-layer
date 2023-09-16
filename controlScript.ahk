#Requires AutoHotkey v1.1.36.02
; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]

#NoEnv
#SingleInstance force
#MaxHotkeysPerInterval 200
#KeyHistory 0
ListLines, Off
SetBatchLines, -1


SetWorkingDir %A_ScriptDir%
if not A_IsAdmin
	Run *RunAs "%A_ScriptFullPath%" ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.

^!l:: Run *RunAs %A_ScriptDir%\extendLayer.ahk

^!Esc::ExitApp