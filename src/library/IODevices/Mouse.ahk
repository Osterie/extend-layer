#Requires AutoHotkey v2.0

Class Mouse{

    autoClickerCPS := 1
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
            clickDelay := 10
        }
        SetTimer this.SendClickObj, clickDelay

    }
    StopAutoClicker(){
        SetTimer this.SendClickObj, 0
    }

    SetAutoClickerClickDelay(delay){
        this.autoClickerClickDelay := delay
    }

    MoveMouseTo(x, y){
        MouseMove(x, y)
    }

    SendClick(){
        Click
    }

    BlockMovementInput(){
        BlockInput("MouseMove")
    }

    UnBlockMovementInput(){
        BlockInput("MouseMoveOff")
    }

    DisableMouse(){
        ; TODO: Implement
    }
}