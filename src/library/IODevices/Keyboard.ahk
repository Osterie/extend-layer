#Requires AutoHotkey v2.0

class Keyboard{

    BlockKeyInput(){
        Loop 512{
            Key := Format("SC{:X}",A_Index)
            Hotkey Key, this.DoNothing, "On UseErrorLevel"
        }
    }

    UnBlockKeyInput(){
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