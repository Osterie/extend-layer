#Requires AutoHotkey v2.0

Class ComputerInputController{

    BlockAllInput(){
        this.BlockKeyboard()
        this.BlockMouse()
    }

    UnBlockAllInput(){
        this.UnBlockKeyboard()
        this.UnBlockMouse()
    }

    BlockMouse(){
        BlockInput("MouseMove")
    }

    UnBlockMouse(){
        BlockInput("MouseMoveOff")
    }

    BlockKeyboard(){
        Loop 512{
            Key := Format("SC{:X}",A_Index)
            Hotkey Key, this.DoNothing, "On UseErrorLevel"
        }
    }

    UnBlockKeyboard(){
        Loop 512{
            Key := Format("SC{:X}",A_Index)
            Hotkey Key, this.DoNothing, "Off UseErrorLevel"
        }
    }

    DisableKey(KeyScanCode){
        Hotkey KeyScanCode, this.DoNothing, "On UseErrorLevel"
    }
    EnableKey(KeyScanCode){
        Hotkey KeyScanCode, this.DoNothing, "Off UseErrorLevel"
    }

    DoNothing(){
        return
    }
}
