#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Infrastructure\IO\IniFileReader>


#Include <Actions\HotkeyAction>

Class Mouse extends HotkeyAction{

    autoClickerCPS := 10
    autoClickerEnabled := false
    SendClickObjectMethod := ObjBindMethod(this, "SendClick")
    IniFileReader := IniFileReader()

    destroy() {
        this.UnBlockAllMouseInput()
        this.StopAutoClicker()
    }

    __New(readSettingsFromFile := false){
        if (readSettingsFromFile){
            this.SetAutoClickerCPSFromFile()
        }
    }

    SetAutoClickerCPSFromFile(){
        try{
            autoClickerCPS := this.IniFileReader.readOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Mouse", "AutoClickerClickCps", 10)
        }
        catch{
            autoClickerCPS := 10
            MsgBox("failed to read the auto clicker cps", "Notify")
        }

        try{
            this.SetAutoClickerClickCps(autoClickerCPS)
        }
        catch ValueError{
            MsgBox("The value for the auto clicker cps is less than 1, setting it to 1", "Notify")
        }
        catch TypeError{
            MsgBox("The value for the auto clicker cps is not an integer, using default value", "Notify")
        }

    }

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
        SetTimer this.SendClickObjectMethod, clickDelay
    }

    StopAutoClicker(){
        SetTimer this.SendClickObjectMethod, 0
    }

    SetAutoClickerClickCps(Cps){
        if (isInteger(Cps)){
            if (Cps < 1){
                Cps := 1
                this.autoClickerCPS := Cps
                throw ValueError("The value for the auto clicker cps is less than 1, setting it to 1")
            }
            else{
                this.autoClickerCPS := Cps
            }
        }
        else if (isFloat(Cps)){
            Cps := Integer(Cps)
            this.autoClickerCPS := Cps
        }
        else{
            throw TypeError("The value for the auto clicker cps is not an integer")
        }
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