#Requires AutoHotkey v2.0


MsgBox KeyWaitAny()

; Same again, but don't block the key.
MsgBox KeyWaitAny("V")

KeyWaitAny(Options:="")
{
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ih.Start()
    ih.Wait()
    return ih.EndKey  ; Return the key name
}