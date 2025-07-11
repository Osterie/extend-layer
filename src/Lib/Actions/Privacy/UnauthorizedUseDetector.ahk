#Requires AutoHotkey v2.0

class UnauthorizedUseDetector {
    ; TODO when unaturorized use is detected, store the time of the last detection, gps position, and a screenshot of the screen. Store to a file in onedrive and perhaps github, but only on github if password and such not available?

    ActivateLockComputerOnTaskBarClick() {
        Hotkey("~LButton", this.LockComputerOnTaskBarClickDown.Bind(this), "on")
    }

    LockComputerOnTaskBarClickDown(params) {
        try {
            if (WinWait("A", , 1)) {
                if (WinGetClass("A") == "Shell_TrayWnd") {
                    Sleep(100)
                    DllCall("LockWorkStation")
                }
            }
        }
        catch {
            ToolTip "Error something wrong with Lock taskbar on click functionality!"
            SetTimer () => ToolTip(), -3000
        }
    }

    DisableLockComputerOnTaskBarClick() {
        try {
            Hotkey("~LButton", this.LockComputerOnTaskBarClickDown.Bind(this), "off")
        }

    }
}
