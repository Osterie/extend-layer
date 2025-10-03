#Requires AutoHotkey v2.0

class UnauthorizedUseDetector {

    setLockComputerOnTaskBarClick(state) {
        if (state == true) {
            this.ActivateLockComputerOnTaskBarClick()
        } else {
            this.DisableLockComputerOnTaskBarClick()
        }
    }

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
