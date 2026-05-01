#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>
#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class GdipDrawer {

    WALeft := 0
    WATop := 0
    WARight := 0
    WABottom := 0
    WAWidth := 0
    WAHeight := 0

    hwnd1 := 0
    hdc := 0
    G := 0

    pBitmap := 0
    pixelSize := 1

    __New(pixelSize) {
        this.pixelSize := pixelSize
        this.Initialize()
    }

    setPixelSize(pixelSize) {
        this.pixelSize := pixelSize
    }

    Initialize() {
        MonitorPrimary := GetPrimaryMonitor()
        M := GetMonitorInfo(MonitorPrimary)
        this.WALeft := M.WALeft
        this.WATop := M.WATop
        this.WARight := M.WARight
        this.WABottom := M.WABottom
        this.WAWidth := M.WARight - M.WALeft
        this.WAHeight := M.WABottom - M.WATop

        this.InitializeGuiRelated()
    }

    InitializeGuiRelated() {
        if !pToken := Gdip_Startup() {
            MsgBox("Gdiplus failed to start. Please ensure you have gdiplus on your system")
        }

        ; Create a layered window (+E0x80000) that is always on top (+AlwaysOnTop), has no taskbar entry or caption
        ; Gui1 := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        Gui1 := Gui("-Caption +E0x80000 +LastFound +ToolWindow +OwnDialogs")
        Gui1.Show("NA")

        ; Get a handle to this window we have created in order to update it later
        this.hwnd1 := WinExist()

        hbm := CreateDIBSection(this.WAWidth, this.WAHeight)
        this.hdc := CreateCompatibleDC()
        obm := SelectObject(this.hdc, hbm)

        this.pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm) ; keep for GetPixel
        this.G := Gdip_GraphicsFromHDC(this.hdc)          ; draw directly to HDC
    }

    ; Clears what was drawn
    Reset() {
        Gdip_GraphicsClear(this.G)
        UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)
    }

    ; Draws a pixel at the given location with the size given when initializing screen drawer, or which was later set.
    ; Note that this method does not visually update the drawing, Update must be called for that.
    DrawPixel(x, y, pBrush, pixelSize := this.pixelSize) {
        if (!this.G) {
            throw Error("Graphics is invalid")
        }

        if (!pBrush) {
            throw Error("pBrush is invalid")
        }

        Gdip_FillRectangle(this.G, pBrush, x, y, pixelSize, pixelSize)
    }

    ; Updates the drawing with the changes that were previously made.
    ; If this method is not called then you will not see anything you have drawn.
    Update() {
        UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)
    }
}
