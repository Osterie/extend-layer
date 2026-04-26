#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>

class ScreenDimensions {
    static GetWorkArea() {

        MonitorPrimary := GetPrimaryMonitor()
        M := GetMonitorInfo(MonitorPrimary)

        left := M.WALeft
        top := M.WATop
        right := M.WARight
        bottom := M.WABottom
        width := right - left
        height := bottom - top

        dims := Dimensions(width, height, left, top)

        return dims
    }
}

class Dimensions {

    __New(width, height, left, top) {
        this.width := width
        this.height := height
        this.left := left
        this.top := top
    }
}
