#Requires AutoHotkey v2.0

; https://www.autohotkey.com/docs/v2/lib/ProcessSetPriority.htm
; #z:: {
;     active_pid := WinGetPID("A")
;     active_title := WinGetTitle("A")
;     MyGui := Gui(, "Set Priority")
;     MyGui.Add("Text",, "
;     (
;         Press ESCAPE to cancel, or double-click a new
;         priority level for the following window:
;     )")
;     MyGui.Add("Text", "wp", active_title)
;     LB := MyGui.Add("ListBox", "r5 Choose1", ["Normal","High","Low","BelowNormal","AboveNormal"])
;     LB.OnEvent("DoubleClick", SetPriority)
;     MyGui.Add("Button", "default", "OK").OnEvent("Click", SetPriority)
;     MyGui.OnEvent("Escape", (*) => MyGui.Destroy())
;     MyGui.OnEvent("Close", (*) => MyGui.Destroy())
;     MyGui.Show()

;     SetPriority(*)
;     {
;         MyGui.Destroy()
;         if ProcessSetPriority(LB.Text, active_pid)
;             MsgBox "Success: Its priority was changed to " LB.Text
;         else
;             MsgBox "Error: Its priority could not be changed to " LB.Text
;     }
; }