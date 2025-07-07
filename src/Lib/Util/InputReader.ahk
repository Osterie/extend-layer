#Requires AutoHotkey v2.0

class InputReader{
    
    
    CreateInputReader(action) {
        Loop 95
        {
            k := Chr(A_Index + 31)
            k := (k = " ") ? "Space" : k
            Hotkey("~*" k, action, "on")
        }
    
        Otherkeys := "Enter|BackSpace|ø|å|æ"
        Loop Parse, Otherkeys, "|"
        {
            Hotkey("~*" A_LoopField, action, "on")
        }
    }
    
    DestroyInputReader(){
        Loop 95
        {
            k := Chr(A_Index + 31)
            k := (k = " ") ? "Space" : k
            try{
                Hotkey("~*" k , , "off")
            }
            catch Error as e {
                ; Ignore errors if the hotkey does not exist.
            }
        }
    
        Otherkeys := "Enter|BackSpace|ø|å|æ"
        Loop Parse, Otherkeys, "|"
        {
            try{
                Hotkey("~*" A_LoopField , , "off")
            }
            catch Error as e {
                ; Ignore errors if the hotkey does not exist.
            }
        }
    }
}