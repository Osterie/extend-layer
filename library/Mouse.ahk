#Requires AutoHotkey v2.0

Class Mouse{

    MoveMouseToCenterOfScreen(){
        MouseMove((A_ScreenWidth//2), (A_ScreenHeight//2))
    }
}