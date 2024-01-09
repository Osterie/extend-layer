#Requires AutoHotkey v2.0

Class UnauthorizedUseDetector{
    ; TODO when unaturorized use is detected, store the time of the last detection, gps position, and a screenshot of the screen. Store to a file in onedrive and perhaps github, but only on github if password and such not available?

    ActivateLockComputerOnTaskBarClick(){
        Hotkey("*LButton", this.LockComputerOnTaskBarClickDown.Bind(this), "on")
        Hotkey("*LButton Up", this.SendClickUp.Bind(this), "on")
    }

    LockComputerOnTaskBarClickDown(params){
        Send("*{LButton Down}")
        try{
            WinWait("A")
            if (WinGetClass("A") == "Shell_TrayWnd"){
                Sleep(100)
                DllCall("LockWorkStation")
            }
        }
        catch{
            ToolTip "Error something wrong!"
            SetTimer () => ToolTip(), -3000
        }
    }
    SendClickUp(params){*
        Send("{blind}{*}*{LButton Up}")
    }

    DisableLockComputerOnTaskBarClick(){
        try{
            Hotkey("*LButton", , "off")
            Hotkey("*LButton Up", , "off")
        }

    }
}