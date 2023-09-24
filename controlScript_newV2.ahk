#Requires Autohotkey v2.0
; [^ = Ctrl] [+ = Shift] [! = Alt] [# = WinK]

; REMOVED: #NoEnv
#SingleInstance force
A_MaxHotkeysPerInterval := 200
KeyHistory(0)
ListLines(false)
; REMOVED: SetBatchLines, -1


SetWorkingDir(A_ScriptDir)
if not A_IsAdmin
	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


^!l::Run("*RunAs " A_ScriptDir "\extendLayer_newV2.ahk")
^!i::Run(A_ScriptDir "\test.ahk")

^!|::Reload()
^!Esc::ExitApp()