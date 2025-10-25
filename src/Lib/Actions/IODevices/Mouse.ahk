#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Infrastructure\IO\IniFileReader>

#Include <Actions\HotkeyAction>

Class Mouse extends HotkeyAction{

    autoClickerCps := 30
    autoClickerEnabled := false
    SendClickObjectMethod := ObjBindMethod(this, "SendClick")
    IniFileReader := IniFileReader()

    destroy() {
        this.UnBlockAllMouseInput()
        this.StopAutoClicker()
    }

    __New(readSettingsFromFile := false){
        if (readSettingsFromFile){
            this.SetAutoClickerCpsFromFile()
        }
    }

    SetAutoClickerCpsFromFile(){

        try{
            autoClickerCps := this.IniFileReader.deleteLine(FilePaths.GetPathToCurrentSettings(), "Mouse", "AutoClickerClickCps")
        }
        catch{
            ; Do nothing.
        }

        try{
            autoClickerCps := this.IniFileReader.readOrCreateLine(FilePaths.GetPathToCurrentSettings(), "Mouse", "AutoClickerCps", 30)
        }
        catch{
            autoClickerCps := 30
            MsgBox("failed to read the auto clicker cps", "Notify")
        }

        try{
            this.setAutoClickerCps(autoClickerCps)
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
        clickDelay := 1000/this.autoClickerCps
        if (clickDelay < 10){
            clickDelay := 0
        }
        SetTimer this.SendClickObjectMethod, clickDelay
    }

    StopAutoClicker(){
        SetTimer this.SendClickObjectMethod, 0
    }

    setAutoClickerCps(Cps){
        if (isInteger(Cps)){
            if (Cps < 1){
                Cps := 1
                this.autoClickerCps := Cps
                throw ValueError("The value for the auto clicker cps is less than 1, setting it to 1")
            }
            else{
                this.autoClickerCps := Cps
            }
        }
        else if (isFloat(Cps)){
            Cps := Integer(Cps)
            this.autoClickerCps := Cps
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
        Hotkey("LButton", this.DoNothing, "On")
        Hotkey("*LButton", this.DoNothing, "On")
    }

    UnBlockMouseClicks(){
        Hotkey("LButton", this.DoNothing, "Off")
        Hotkey("*LButton", this.DoNothing, "Off")
    }

    ; Run a powershell exe to disable mouse
    DisableMouse(){
        ; TODO: Implement
    }

    DoNothing(){
        return
    }
}