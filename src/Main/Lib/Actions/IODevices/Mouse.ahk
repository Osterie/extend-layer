#Requires AutoHotkey v2.0

Class Mouse{

    autoClickerCPS := 10
    autoClickerEnabled := false
    SendClickObj := ObjBindMethod(this, "SendClick")


    MoveMouseToCenterOfScreen(){
        this.MoveMouseTo((A_ScreenWidth//2), (A_ScreenHeight//2))
    }

    ToggleAutoClicker(){
        this.autoClickerEnabled := !this.autoClickerEnabled

        if (this.autoClickerEnabled){
            this.StartAutoClicker()
        } else {
            this.StopAutoClicker()
        }
    }

    StartAutoClicker(){
        clickDelay := 1000/this.autoClickerCPS
        if (clickDelay < 10){
            clickDelay := 0
        }
        SetTimer this.SendClickObj, clickDelay
    }

    StopAutoClicker(){
        SetTimer this.SendClickObj, 0
    }

    SetAutoClickerClickCps(Cps){
        this.autoClickerCPS := Cps
    }

    SendClick(){
        Click
    }

    MoveMouseTo(x, y){
        MouseMove(x, y)
    }

    BlockAllMouseInput(){
        this.BlockMovementInput()
        this.BlockMouseClicks()
    }
    
    UnBlockAllMouseInput(){
        this.UnBlockMovementInput()
        this.UnBlockMouseClicks()
    }

    BlockMovementInput(){
        BlockInput("MouseMove")
    }

    UnBlockMovementInput(){
        BlockInput("MouseMoveOff")
    }

    BlockMouseClicks(){
        Hotkey("LButton", this.DoNothing, "On UseErrorLevel")
        Hotkey("*LButton", this.DoNothing, "On UseErrorLevel")
    }

    UnBlockMouseClicks(){
        Hotkey("LButton", this.DoNothing, "Off UseErrorLevel")
        Hotkey("*LButton", this.DoNothing, "Off UseErrorLevel")
    }

    ; Run a powershell exe to disable mouse
    DisableMouse(){
        ; TODO: Implement
    }

    DoNothing(){
        return
    }
}