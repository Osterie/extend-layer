#Requires AutoHotkey v2.0

; Is responsible for reading ini files and validating the values

class IniFileReader {

    ; Reads and validates all the sections of the ini file, then returns the validated section names
    readSectionNames(iniFile) {
        iniFileSectionNames := IniRead(iniFile)
        iniFileSectionNames := this.validateText(iniFileSectionNames)
        return iniFileSectionNames
    }

    ; Reads the values which are in a section, returns a string
    readSection(iniFile, section) {
        readValue := IniRead(iniFile, section)
        readVAlue := this.validateText(readValue)
        return readValue
    }

    readSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section) {
        readValue := this.readSection(iniFile, section)
        readValueSplitByNewLine := StrSplit(readValue, "`n")

        ; Create a two dimensional array with key and value
        twoDimensionalArray := []
        loop readValueSplitByNewLine.Length {
            twoDimensionalArray.InsertAt(A_index, [])
            iniFileLine := readValueSplitByNewLine[A_index]
            iniFileKey := this.getKeyFromLine(iniFileLine)
            iniFileValue := this.getValueFromLine(iniFileLine)
            twoDimensionalArray[A_index] := [iniFileKey, iniFileValue]
        }
        return twoDimensionalArray
    }

    readSectionNamesToArray(iniFile) {
        iniFileSections := this.readSectionNames(iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        sectionNames := Array()
        loop iniFileSections.Length {
            sectionName := iniFileSections[A_Index]
            sectionNames.Push(sectionName)
        }
        return sectionNames
    }

    readLine(iniFile, section, key) {
        key := this.validateText(key)
        readValue := IniRead(iniFile, section, key)
        readValue := this.validateText(readValue)
        return readValue
    }

    readOrCreateLine(iniFile, section, key, defaultValue) {
        if (defaultValue == "") {
            MsgBox("Default value cannot be empty", "Notify")
            throw "Default value cannot be empty"
        }
        key := this.validateText(key)
        readValue := IniRead(iniFile, section, key, "")
        if (readValue == "") {
            readValue := defaultValue
            IniWrite(readValue, iniFile, section, key)
            msgbox("The key " . key . " was not found in the ini file, so it was created with the value " . readValue .
                ".")
        }
        readValue := this.validateText(readValue)
        return readValue
    }

    ; Given a ini file line with key and value, get the key
    getKeyFromLine(iniFileLine) {
        keyToReturn := StrSplit(iniFileLine, "=")[1]
        keyToReturn := this.validateText(keyToReturn)
        return keyToReturn
    }

    ; Given a ini file line with key and value, get the value
    getValueFromLine(iniFileLine) {
        firstEqualsSignPosition := InStr(iniFileLine, "=")
        return SubStr(iniFileLine, firstEqualsSignPosition + 1)
    }

    ; Returns an array with key as first element (f.eks a, b, k, l), and modifiers as second element (f.eks ^+)
    readLineKeyAndModifier(iniFile, section, key) {
        readValue := this.readLine(iniFile, section, key)
        keyAndModifier := this.seperateKeyboardKeyAndModifiers(readValue)
        return keyAndModifier
    }

    seperateKeyboardKeyAndModifiers(givenKeyboradKeyWithModifier) {
        possibleModifiers := "^+#!"
        modifiers := ""
        keyboardKey := ""

        loop parse, givenKeyboradKeyWithModifier, "" {
            if (InStr(possibleModifiers, A_LoopField)) {
                modifiers .= A_LoopField
            }
            else
                keyboardKey .= A_LoopField
        }
        return [keyboardKey, modifiers]
    }

    ; TODO is this needed?
    validateText(text) {
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
