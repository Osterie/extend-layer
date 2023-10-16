#Requires AutoHotkey v2.0

Class IniFileReader{

    ; Returns an array with key as first element (f.eks a, b, k, l), and modifiers as second element (f.eks ^+)
    ReadLineKeyAndModifier(iniFile, section, key){
        readValue := this.ReadLine(iniFile, section, key)
        keyAndModifier := this.SeperateKeyboardKeyAndModifiers(readValue)
        return keyAndModifier
    }

    ReadLine(iniFile, section, key){
        key := this.ValidateKey(key)
        readValue := IniRead(iniFile, section, key)
        readValue := this.ValidateValue(readValue)
        return readValue
    }

    ReadSection(iniFile, section){
        readValue := IniRead(iniFile, section)
        readValue := StrReplace(readValue, "Ã¦", "æ")
        readValue := StrReplace(readValue, "Ã¸", "ø")
        readValue := StrReplace(readValue, "Ã¥", "å")
        return readValue
    }

    ValidateKey(key){
        key := StrReplace(key, "æ", "Ã¦")
        key := StrReplace(key, "ø", "Ã¸")
        key := StrReplace(key, "å", "Ã¥")
        return key
    }

    ValidateValue(pairValue){
        pairValue := StrReplace(pairValue, "Ã¦", "æ")
        pairValue := StrReplace(pairValue, "Ã¸", "ø")
        pairValue := StrReplace(pairValue, "Ã¥", "å")
        return pairValue
    }

    SeperateKeyboardKeyAndModifiers(givenKeyboradKeyWithModifier){
        possibleModifiers := "^+#!"
        modifiers := ""
        keyboardKey := ""

        Loop Parse, givenKeyboradKeyWithModifier, ""{
            if (InStr(possibleModifiers, A_LoopField)){
                modifiers .= A_LoopField
            }
            else
                keyboardKey .= A_LoopField
        }
        return [keyboardKey, modifiers]
    }
}