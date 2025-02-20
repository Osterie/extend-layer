﻿#Requires Autohotkey v2.0

#SingleInstance force
ProcessSetPriority "High"
SetWorkingDir(A_ScriptDir)

; if not A_IsAdmin
; 	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; Extra layers script
^!l::Run(A_ScriptDir "\Main\Main.ahk")
; For testing
^!i::Run(A_ScriptDir "\..\tests\destroyingGusi.ahk")
; ^!u::Run(A_ScriptDir "\ExtraKeyboardsApplicationLauncher.ahk")

^!p::Run(A_ScriptDir "\library\JsonTesting\jsonTest.ahk")

^!|::Reload()
^!Esc::ExitApp()