#Requires AutoHotkey v2.0

; TODO the ini file reader class, which is currently empty i believe, should read ini files.
; "æ ø å" and such are replaced with other values, since the ini file cant be utf-8 with bom encoding, therefore the result should replace these wrong characters with "æøå" respectively.

Class Configurator{

    iniFile := ""
    defaultIniFile := ""
    methodsWithCorrespondingClasses := ""

    __New(iniFile, defaultIniFile, methodsWithCorrespondingClasses){
        this.iniFile := iniFile
        this.defaultIniFile := defaultIniFile
        this.methodsWithCorrespondingClasses := methodsWithCorrespondingClasses
    }

    ChangeIniFile(iniFile){
        this.iniFile := iniFile
    }
    ChangeDefaultIniFile(defaultIniFile){
        this.defaultIniFile := defaultIniFile
    }


    ReadKeyboardOverlaySection(KeyboardOverlay, section){
        
        modifierKey := IniRead(this.iniFile, section, "LayerModifier")
        
        iniFileSection := IniRead(this.iniFile, section)

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
        values := IniRead(this.iniFile, section, key)
        valueArray := values.StrSplit(values, ",")
        return valueArray
    }

    InitializeAllHotkeys(section){

        iniFileSection := IniRead(this.iniFile, "Hotkeys")
        defaultIniFileSection := IniRead(this.defaultIniFile, "Hotkeys")

        iniFileSectionArray := StrSplit(iniFileSection, "`n")
        defaultIniFileSectionArray := StrSplit(defaultIniFileSection, "`n")

        ; This splits section, using "`n" as a delimiter, which is new line in ahk.
        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileFunction := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            ; This is the hotkey that is currently in use (found in the DefaultConfig.ini file)
            inUseHotkey := StrSplit(defaultIniFileSectionArray[A_Index], "=")[2]
            this.InitializeHotkey2(section, iniFileFunction, inUseHotkey )
        }
    }

    ; iniFileFunction is the function found in the Config.ini file, whilst inUseHotkey is the hotkey that is currently in by default used in the script, which is also stored in the DefaultConfig.ini file.
    ; This function is used to initialize the hotkeys, there are default keys for hotkeys, but the user can change them.
    ; Section specifies the section in the ini file to look.
    ; inUseHotkey is the hotkey that is currently in use.
    ; iniFileFunction is the function that is in the ini file, for example EmergencyClose is a function, and its default inUseHotkey is F2
    ; Often inUseHotkey may be the same as iniFileFunction, but not always.
    InitializeHotkey1(section, iniFileFunction, inUseHotkey){
        newHotkey := IniRead(this.iniFile, section, iniFileFunction)
        ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        if (newHotkey != inUseHotkey){
            Hotkey(inUseHotkey, "off")
            Hotkey(newHotkey, inUseHotkey)
        }
    }

    InitializeHotkey2(section, iniFileMethod, inUseHotkey){

        methodClass := this.methodsWithCorrespondingClasses[iniFileMethod]

        ; way1 := OnScreenWriter.ToggleShowKeysPressed.Bind(OnScreenWriter)
        ; way2 := ObjBindMethod(OnScreenWriter, "ToggleShowKeysPressed")
        classMethodCall := ObjBindMethod(methodClass, iniFileMethod)
        newHotkey := IniRead(this.iniFile, section, iniFileMethod)
        ; OnScreenWriterHotkey := IniRead("Config.ini", "Hotkeys", iniFileMethod)
        HotKey newHotkey, (ThisHotkey) => classMethodCall()

        ; newHotkey := IniRead(this.iniFile, section, iniFileFunction)
        ; ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        ; if (newHotkey != inUseHotkey){
        ;     Hotkey(inUseHotkey, "off")
        ;     Hotkey(newHotkey, inUseHotkey)
        ; }
    }
}