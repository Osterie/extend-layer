#Requires AutoHotkey v2.0
https://www.autohotkey.com/docs/v2/lib/DllCall.htm 
F1::
F1 up::
{
    static SPI_GETMOUSESPEED := 0x70
    static SPI_SETMOUSESPEED := 0x71
    static OrigMouseSpeed := 0
    
    switch ThisHotkey
    {
    case "F1":
        ; Retrieve the current speed so that it can be restored later:
        DllCall("SystemParametersInfo", "UInt", SPI_GETMOUSESPEED, "UInt", 0, "Ptr*", &OrigMouseSpeed, "UInt", 0)
        ; Now set the mouse to the slower speed specified in the next-to-last parameter (the range is 1-20, 10 is default):
        DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", 3, "UInt", 0)
        KeyWait "F1"  ; This prevents keyboard auto-repeat from doing the DllCall repeatedly.
        
    case "F1 up":
        DllCall("SystemParametersInfo", "UInt", SPI_SETMOUSESPEED, "UInt", 0, "Ptr", OrigMouseSpeed, "UInt", 0)  ; Restore the original speed.
    }
}