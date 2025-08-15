#Requires AutoHotkey v2.0

class GuiSizeFinder {
    static calculateGuiDimensions(guiObject) {

        WinGetPos(&x, &y, &w, &h, guiObject.hwnd)
        guiIsHidden := true
        if (w = 0 && h = 0) {
            guiIsHidden := true
        }

        if (guiIsHidden) {
            WinSetTransparent(0, guiObject)
            guiObject.show("NoActivate")
            guiObject.GetPos(&x, &y, &w, &h)
            guiObject.hide()
            WinSetTransparent(255, guiObject)
        }
        else{
            guiObject.GetPos(&x, &y, &w, &h)
        }
        guiWidth := w
        guiHeight := h
        return [guiWidth, guiHeight]
    }
}