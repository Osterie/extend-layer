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
            Hotkey("~*" k , , "off")
        }
    
        Otherkeys := "Enter|BackSpace|ø|å|æ"
        Loop Parse, Otherkeys, "|"
        {
            Hotkey("~*" A_LoopField , , "off")
        }
    }
}