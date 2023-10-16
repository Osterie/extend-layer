#Requires AutoHotkey v2.0
#Include "iniFileReader.ahk"

; TODO the ini file reader class, which is currently empty i believe, should read ini files.
; "æ ø å" and such are replaced with other values, since the ini file cant be utf-8 with bom encoding, therefore the result should replace these wrong characters with "æøå" respectively.

Class Configurator{

    iniFile := ""
    defaultIniFile := ""
    methodsWithCorrespondingClasses := ""
    IniReader := ""

    __New(iniFile, defaultIniFile, methodsWithCorrespondingClasses){
        this.iniFile := iniFile
        this.defaultIniFile := defaultIniFile
        this.methodsWithCorrespondingClasses := methodsWithCorrespondingClasses
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

    GetKeyValue(key){
        return StrSplit(key, "=")[2]
    }

    ReadArray(section, key){
        values := this.IniReader.ReadLine(this.iniFile, section, key)
        valueArray := values.StrSplit(values, ",")
        return valueArray
    }

    InitializeAllDefaultKeyToFunctions(section){

        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        defaultIniFileSection := this.IniReader.ReadSection(this.defaultIniFile, section)

        iniFileSectionArray := StrSplit(iniFileSection, "`n")
        defaultIniFileSectionArray := StrSplit(defaultIniFileSection, "`n")

        ; This splits section, using "`n" as a delimiter, which is new line in ahk.
        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileFunction := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            ; This is the hotkey that is currently in use (found in the DefaultConfig.ini file)
            inUseHotkey := StrSplit(defaultIniFileSectionArray[A_Index], "=")[2]
            this.InitializeDefaultKeyToFunction2(section, iniFileFunction)
        }
    }

    InitializeAllDefaultKeyToFunctions1(section){

        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        defaultIniFileSection := this.IniReader.ReadSection(this.defaultIniFile, section)

        iniFileSectionArray := StrSplit(iniFileSection, "`n")
        defaultIniFileSectionArray := StrSplit(defaultIniFileSection, "`n")

        ; This splits section, using "`n" as a delimiter, which is new line in ahk.
        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            newHotkey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            ; This is the hotkey that is currently in use (found in the DefaultConfig.ini file)
            inUseHotkey := StrSplit(defaultIniFileSectionArray[A_Index], "=")[1]
            this.InitializeDefaultKeyToFunction1(section, newHotkey, inUseHotkey)
        }
    }

    ; iniFileFunction is the function found in the Config.ini file, whilst inUseHotkey is the hotkey that is currently in by default used in the script, which is also stored in the DefaultConfig.ini file.
    ; This function is used to initialize the hotkeys, there are default keys for hotkeys, but the user can change them.
    ; Section specifies the section in the ini file to look.
    ; inUseHotkey is the hotkey that is currently in use.
    ; iniFileFunction is the function that is in the ini file, for example EmergencyClose is a function, and its default inUseHotkey is F2
    ; Often inUseHotkey may be the same as iniFileFunction, but not always.
    InitializeDefaultKeyToFunction1(section, newHotkey, inUseHotkey){
        ; newHotkey := this.IniReader.ReadLine(this.iniFile, section, newHotkey)
        ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        ; msgbox(newHotkey . " " . inUseHotkey)
        ; msgbox(newHotkey . " " . inUseHotkey)
        ; msgbox(newHotKey)
        
        if (newHotkey != inUseHotkey){
            ; msgbox(newHotkey . " " . inUseHotkey)
            Hotkey(newHotkey, inUseHotkey)
            Hotkey(inUseHotkey, "off")
        }
    }

    InitializeDefaultKeyToFunction2(section, iniFileMethod){

        methodClass := this.methodsWithCorrespondingClasses[iniFileMethod]

        ; way1 := OnScreenWriter.ToggleShowKeysPressed.Bind(OnScreenWriter)
        ; way2 := ObjBindMethod(OnScreenWriter, "ToggleShowKeysPressed")
        classMethodCall := ObjBindMethod(methodClass, iniFileMethod)
        newHotkey := this.IniReader.ReadLine(this.iniFile, section, iniFileMethod)
        ; OnScreenWriterHotkey := this.IniReader.ReadLine("Config.ini", "Hotkeys", iniFileMethod)
        HotKey newHotkey, (ThisHotkey) => classMethodCall()

        ; newHotkey := this.IniReader.ReadLine(this.iniFile, section, iniFileFunction)
        ; ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        ; if (newHotkey != inUseHotkey){
        ;     Hotkey(inUseHotkey, "off")
        ;     Hotkey(newHotkey, inUseHotkey)
        ; }
    }

    ; InitializeAllDefaultKeyToKeys(section){

    ;     iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
    ;     iniFileSectionArray := StrSplit(iniFileSection, "`n")

    ;     ; This splits section, using "`n" as a delimiter, which is new line in ahk.
    ;     ; A_LoopField is the current item in the loop.
    ;     Loop iniFileSectionArray.Length{
    ;         ; This is the function that is in the ini file, for example EmergencyClose is a function.
    ;         iniFileDefaultKey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
    ;         this.InitializeDefaultKeyToKey(section, iniFileDefaultKey)
    ;     }
    ; }

    ; InitializeDefaultKeyToKey(section, defaultKey){
    ;     newKey := this.IniReader.ReadLine(this.iniFile, section, defaultKey)
    ;     HotKey(defaultKey, (ThisHotkey) => SendKey(newKey)) ; SendKey.Bind("Up"))
    ; }

    SendKey(key){
        Send("{" . key . "}")
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
            this.InitializeDefaultKeyToKey(iniFileDefaultKey, iniFileNewKey)
        }
    }

    InitializeDefaultKeyToKey(iniFileDefaultKey, iniFileNewKey){
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
}