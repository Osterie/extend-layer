#Requires AutoHotkey v2.0

Class ComputerInputController{

    SendKey(key){
        Send(key)
    }

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

    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    EnableKey(key){
        Hotkey key, this.DoNothing, "Off UseErrorLevel"
    }
    
    ; Takes a key or a key scan code.
    ; This key can also have modifiers such as #, !, +, ^.
    DisableKey(key){
        Hotkey key, this.DoNothing, "On UseErrorLevel"
    }

    DoNothing(){
        return
    }
}
