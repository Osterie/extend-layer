#Requires AutoHotkey v2.0
#Include "iniFileReader.ahk"

; TODO the ini file reader class, which is currently empty i believe, should read ini files.
; "æ ø å" and such are replaced with other values, since the ini file cant be utf-8 with bom encoding, therefore the result should replace these wrong characters with "æøå" respectively.

Class Configurator{

    iniFile := ""
    defaultIniFile := ""
    ObjectRegistry := ""
    IniReader := ""

    __New(iniFile, defaultIniFile, ObjectRegistry){
        this.iniFile := iniFile
        this.defaultIniFile := defaultIniFile
        this.ObjectRegistry := ObjectRegistry
        this.IniReader := IniFileReader()
    }

    ChangeIniFile(iniFile){
        this.iniFile := iniFile
    }
    
    ChangeDefaultIniFile(defaultIniFile){
        this.defaultIniFile := defaultIniFile
    }

    ReadKeyboardOverlaySection(KeyboardOverlay, section){
        
        modifierKey := this.IniReader.ReadLine(this.iniFile, section, "LayerModifier")
        
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)

        ; Reads where the columns start, and deletes everything before that.
        startOfColumns := InStr(iniFileSection,"Column1")
        iniFileSection := SubStr(iniFileSection,startOfColumns)

        KeyboardOverlayColumns := StrSplit(iniFileSection, "`n")
        
        ; A_LoopField is the current item in the loop.
        Loop KeyboardOverlayColumns.Length{
            ColumnValues := this.GetKeyValue(KeyboardOverlayColumns[A_Index])
            KeyboardOverlayColumnHelperKey := StrSplit(ColumnValues, ",")[1]
            KeyboardOverlayColumnFriendlyName := StrSplit(ColumnValues, ",")[2]
            this.SetKeyboardOverlayColumn(KeyboardOverlay, KeyboardOverlayColumnHelperKey, KeyboardOverlayColumnFriendlyName )
        }
    }

    SetKeyboardOverlayColumn(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName){
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }


    InitializeAllDefaultKeysToFunctions(section){
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)

        iniFileSectionArray := StrSplit(iniFileSection, "`n")

        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{

            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileKey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            ; This is the hotkey that is currently in use (found in the DefaultConfig.ini file)
            ; inUseHotkey := StrSplit(defaultIniFileSectionArray[A_Index], "=")[2]
            this.InitializeDefaultKeyToFunction(section, iniFileKey)

        }
    }

    InitializeDefaultKeyToFunction(section, key){
        readLine := this.IniReader.readLine(this.iniFile, section, key)
        
        ; TODO add method for key validation
        key := StrReplace(key, "win+", "#")

        ; Reads the Class name, which is the text before the first period
        UsedClass := SubStr(readLine, 1, InStr(readLine, ".")-1)
        ; Removes the class name from the expression
        readLine := SubStr(readLine, InStr(readLine, ".")+1)

        UsedMethod := SubStr(readLine, 1, InStr(readLine, "(")-1)
        ; Removes the method name from the expression, and also the first and last character, which are "(" and ")"
        ; This leaves only the arguments remainig, which is split into an array, splitting by "," since comma seperates arguments
        readLine := SubStr(readLine, InStr(readLine, "(")+1, -1)

        Arguments := StrSplit(readLine, ",")
        ; msgbox(UsedClass . " " . UsedMethod . " " . Arguments) 
        validatedArguments := []
        temporaryArray := []
        inArray := false

        for argument in Arguments{
            
            argument := StrReplace(argument, A_Space, "")

            if (SubStr(argument, 1, 1) == "["){
                inArray := true
                temporaryArray.Push(SubStr(argument, 1,))
            }
            else if(SubStr(argument, -1) == "]"){
                inArray := false
                temporaryArray.Push(SubStr(argument, 1, -1))
                validatedArguments.Push(temporaryArray)
            }
            else if(inArray){
                temporaryArray.Push(argument)
            }
            else{
                validatedArguments.Push(argument)
            }
        }

        methodClass := this.ObjectRegistry.GetObject(UsedClass)

        secondColumn := ObjBindMethod(methodClass, UsedMethod, validatedArguments*)
        HotKey key, (ThisHotkey) => (secondColumn)()

    }


    InitializeAllDefaultKeyToNewKeys(section){

        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        iniFileSectionArray := StrSplit(iniFileSection, "`n")

        ; This splits section, using "`n" as a delimiter, which is new line in ahk.
        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileDefaultKey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            iniFileNewKey := StrSplit(iniFileSectionArray[A_Index], "=")[2]
            this.InitializeDefaultKeyToNewKey(iniFileDefaultKey, iniFileNewKey)
        }
    }

    InitializeDefaultKeyToNewKey(iniFileDefaultKey, iniFileNewKey){
        KeyboardKeyAndModifers := this.IniReader.SeperateKeyboardKeyAndModifiers(iniFileNewKey)
        KeyboardKey := KeyboardKeyAndModifers[1]
        KeyboardModifiers := KeyboardKeyAndModifers[2]
        this.ChangeKeyToNewKey(iniFileDefaultKey, KeyboardKey, KeyboardModifiers)
    }

    ChangeKeyToNewKey(normalKey, newKey, newKeyModifiers){
        ; *a = normalKey
        ; Left = newKey
        HotKey(normalKey, (ThisHotkey) => this.SendKeyDown(newKey, newKeyModifiers)) 
        HotKey(normalKey . " Up", (ThisHotkey) => this.SendKeyUp(newKey, newKeyModifiers))

    }

    SendKeyDown(key, modifiers){
        Send("{blind}" . modifiers . "{" . key . " Down}")
    }
    
    SendKeyUp(key, modifiers){
        Send("{blind}{" . key . " Up}")                                                           
    }

    GetKeyValue(key){
        return StrSplit(key, "=")[2]
    }

    ReadArray(section, key){
        values := this.IniReader.ReadLine(this.iniFile, section, key)
        valueArray := values.StrSplit(values, ",")
        return valueArray
    }
}