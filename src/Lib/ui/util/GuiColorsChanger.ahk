#Requires AutoHotkey v2.0

class GuiColorsChanger {

    ; colorHex is on the format RRGGBB, or cRRGGBB
    static setControlsColor(guiObject, colorHex) {
        for Hwnd, Ctrl in guiObject {
            Ctrl.Opt("+Background" . colorHex)
            Ctrl.BackColor := colorHex
        }
    }

    static setControlColor(control, colorHex) {
        try {
            control.Opt("+Background" . colorHex)
        }
        control.BackColor := colorHex
    }

    ; colorHex is on the format RRGGBB, or cRRGGBB
    static setControlsTextColor(guiObject, colorHex) {
        for Hwnd, Ctrl in guiObject {
            Ctrl.SetFont("c" . colorHex)
        }
    }

    static setControlTextColor(control, colorHex) {
        try{
            control.SetFont("c" . colorHex)
        } catch Error as e{
            if (InStr(e.Message, "Not supported for this control type")){
                throw ValueError("Control type does not support setting text color")
            }
            else {
                throw e
            }
        }
    }

    static SetDarkWindowFrame(guiObject, boolEnable := 1) {
        hwnd := guiObject.Hwnd
        hwnd := WinExist(hwnd)
        if VerCompare(A_OSVersion, "10.0.17763") >= 0
            attr := 19
        if VerCompare(A_OSVersion, "10.0.18985") >= 0
            attr := 20
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", attr, "int*", boolEnable, "int", 4)
    }

    ; set caption color for windows 11 only
    ; coloreHex is on the format 0xRRGGBB
    static DwmSetCaptionColor(guiObject?, colorHex?) {
        hwnd := guiObject.Hwnd
        hwnd := WinExist(hwnd)
        static DWMWA_CAPTION_COLOR := 35
        colorHex := IsSet(colorHex) ? (colorHex & 0xFF0000) >> 16 | (colorHex & 0xFF00) | (colorHex & 0xFF) << 16 :
            0xFFFFFFFF
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", WinExist(hwnd ?? "A"), "int", DWMWA_CAPTION_COLOR, "int*",
        colorHex, "int", 4)
    }

    ; set caption text color for windows 11 only
    ; coloreHex is on the format 0xRRGGBB
    static DwmSetTextColor(guiObject?, colorHex?) {
        hwnd := guiObject.Hwnd
        hwnd := WinExist(hwnd)
        static DWMWA_TEXT_COLOR := 36
        colorHex := IsSet(colorHex) ? (colorHex & 0xFF0000) >> 16 | (colorHex & 0xFF00) | (colorHex & 0xFF) << 16 :
            0xFFFFFFFF
        DllCall("dwmapi\DwmSetWindowAttribute", "ptr", WinExist(hwnd ?? "A"), "int", DWMWA_TEXT_COLOR, "int*", colorHex,
        "int", 4)
    }
}
