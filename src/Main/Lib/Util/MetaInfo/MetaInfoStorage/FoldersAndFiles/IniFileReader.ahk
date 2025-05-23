#Requires AutoHotkey v2.0

; Is responsible for reading ini files and validating the values

Class IniFileReader{

    ; Reads and validates all the sections of the ini file, then returns the validated section names
    ReadSectionNames(iniFile){
        iniFileSectionNames := IniRead(iniFile)
        iniFileSectionNames := this.ValidateText(iniFileSectionNames)
        return iniFileSectionNames
    }

    ; Reads the values which are in a section, returns a string
    ReadSection(iniFile, section){
        readValue := IniRead(iniFile, section)
        readVAlue := this.ValidateText(readValue)
        return readValue
    }

    ReadSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section){
        readValue := this.ReadSection(iniFile, section)
        readValueSplitByNewLine := StrSplit(readValue, "`n")

        ; Create a two dimensional array with key and value
        twoDimensionalArray := []
        Loop readValueSplitByNewLine.Length{
            twoDimensionalArray.InsertAt(A_index, [])
            iniFileLine := readValueSplitByNewLine[A_index]
            iniFileKey := this.GetKeyFromLine(iniFileLine)
            iniFileValue := this.GetValueFromLine(iniFileLine)
            twoDimensionalArray[A_index] := [iniFileKey, iniFileValue]
        }
        return twoDimensionalArray
    }

    ReadSectionNamesToArray(iniFile){
        iniFileSections := this.ReadSectionNames(iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        sectionNames := Array()
        Loop iniFileSections.Length{
            sectionName := iniFileSections[A_Index]
            sectionNames.Push(sectionName)
        }
        return sectionNames
    }

    ReadLine(iniFile, section, key){
        key := this.ValidateText(key)
        readValue := IniRead(iniFile, section, key)
        readValue := this.ValidateText(readValue)
        return readValue
    }

    ReadOrCreateLine(iniFile, section, key, defaultValue){
        if (defaultValue == ""){
            MsgBox("Default value cannot be empty", "Notify")
            throw "Default value cannot be empty"
        }
        key := this.ValidateText(key)
        readValue := IniRead(iniFile, section, key, "")
        if (readValue == ""){
            readValue := defaultValue
            IniWrite(readValue, iniFile, section, key)
            msgbox("The key " . key . " was not found in the ini file, so it was created with the value " . readValue . ".")
        }
        readValue := this.ValidateText(readValue)
        return readValue
    }

    ; Given a ini file line with key and value, get the key
    GetKeyFromLine(iniFileLine){
        keyToReturn := StrSplit(iniFileLine, "=")[1]
        keyToReturn := this.ValidateText(keyToReturn)
        return keyToReturn
    }

    ; Given a ini file line with key and value, get the value
    GetValueFromLine(iniFileLine){
        firstEqualsSignPosition := InStr(iniFileLine, "=")
        return SubStr(iniFileLine, firstEqualsSignPosition+1)
    }

    ; Returns an array with key as first element (f.eks a, b, k, l), and modifiers as second element (f.eks ^+)
    ReadLineKeyAndModifier(iniFile, section, key){
        readValue := this.ReadLine(iniFile, section, key)
        keyAndModifier := this.SeperateKeyboardKeyAndModifiers(readValue)
        return keyAndModifier
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

    ValidateText(text){ 
        text := StrReplace(text, "Ã¦", "æ")
        text := StrReplace(text, "Ã¸", "ø")
        text := StrReplace(text, "Ã¥", "å")
        ; TODO improve further to handle all cases, could remove spaces and make lowercase...
        text := StrReplace(text, "win+", "#")
        text := StrReplace(text, "win +", "#")
        text := StrReplace(text, '"', "")
        return text
    }
}