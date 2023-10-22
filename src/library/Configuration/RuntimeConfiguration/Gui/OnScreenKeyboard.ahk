#Requires AutoHotkey v2.0

class OnScreenKeyboard{

    type := "no"

    __New(languageType){
        if (languageType == "no" || languageType == "en"){
            this.type := languageType
        }
        else{
            throw Exception("Language type not supported")
        }
    }

    CreateOnScreenKeyboardGui(){

        ; TODO: there are 6 sections.
        ; Some keys have different sizes.
        
        ; FOR ENGLISH (NO KEYPAD)
         
; Section 1: Esc, F1-F12, Print Screen, Scroll Lock, Pause
; Section 2  ~` 1 2 3 4 5 6 7 8 9 0 - = Backspace Insert Home PageUp
; Section 3  Tab Q W E R T Y U I O P [ ] \ Delete End PageDown
; Section 4  CapsLock A S D F G H J K L ; ' Enter
; Section 5  Shift Z X C V B N M , . / Shift            Up
; Section 6  Ctrl Win Alt Space Alt Win Menu Ctrl Left Down Right

        ; FOR NORWEGIAN 100% (NO KEYPAD)
        ; Section 1: Esc, F1-F12, Print Screen, Scroll Lock, Pause
        ; Section 2  | 1 2 3 4 5 6 7 8 9 0 + \ Backspace Insert Home PageUp
        ; Section 3  Tab Q W E R T Y U I O P Å ¨ Delete End PageDown
        ; Section 4  CapsLock A S D F G H J K L Ø Æ ' Enter
        ; Section 5  Shift < Z X C V B N M , . - Shift         Up
        ; Section 6  Ctrl Win Alt Space Alt-gr fn Appskey Ctrl Left Down Right

        ; FOR NORWEGIAN 60% (NO KEYPAD)
        ; Section 1: Esc, F1-F12, Del
        ; Section 2  | 1 2 3 4 5 6 7 8 9 0 + \ Backspace
        ; Section 3  Tab Q W E R T Y U I O P Å ¨ Enter
        ; Section 4  CapsLock A S D F G H J K L Ø Æ '
        ; Section 5  Shift < Z X C V B N M , . - Shift         Up
        ; Section 6  Ctrl Fn Win Alt Space Alt-gr Ctrl Left Down Right
        
        


        if (type := "no"){

        } 
    }

    
}