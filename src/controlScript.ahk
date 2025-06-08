#Requires Autohotkey v2.0

#SingleInstance force
ProcessSetPriority "High"
SetWorkingDir(A_ScriptDir)


; --------------------
; ----- NOTE ---------
; --------------------
; Do not run this script, run the exe.

; Closes this script if it is run. Run the exe instead!
ExitApp



; if not A_IsAdmin
; 	Run("*RunAs `"" A_ScriptFullPath "`"") ; (A_AhkPath is usually optional if the script has the .ahk extension.) You would typically check  first.


; Extra layers script
; Ctrl + Alt + L to run the Main script.
^!l::Run(A_ScriptDir "\Main\Main.ahk")

; Ctrl + Alt + | to reload the control script
^!|::Reload()

; Ctrl + Alt + Esc to exit the control script
^!Esc::ExitApp()