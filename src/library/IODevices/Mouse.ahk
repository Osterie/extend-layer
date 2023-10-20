#Requires AutoHotkey v2.0

Class Mouse{

    MoveMouseToCenterOfScreen(){
        this.MoveMouseTo((A_ScreenWidth//2), (A_ScreenHeight//2))
    }

    MoveMouseTo(x, y){
        MouseMove(x, y)
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