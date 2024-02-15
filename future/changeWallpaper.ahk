#Requires AutoHotkey v2.0

https://www.autohotkey.com/docs/v2/lib/DllCall.htm

Changes the desktop wallpaper to the specified bitmap (.bmp) file.

DllCall("SystemParametersInfo", "UInt", 0x14, "UInt", 0, "Str", A_WinDir . "\winnt.bmp", "UInt", 1)
