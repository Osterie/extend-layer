#Requires Autohotkey v2.0

#SingleInstance force
ProcessSetPriority "High"
SetWorkingDir(A_ScriptDir)

if not A_IsAdmin
	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; Extra layers script
^!l::Run("*RunAs " A_ScriptDir "\Main.ahk")
; For testing
^!i::Run(A_ScriptDir "\..\tests\removeme.ahk")
^!u::Run(A_ScriptDir "\ExtraKeyboardsApp.ahk")

^!p::Run(A_ScriptDir "\library\JsonTesting\jsonTest.ahk")

^!|::Reload()
^!Esc::ExitApp()