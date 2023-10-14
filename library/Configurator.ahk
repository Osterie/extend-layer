#Requires AutoHotkey v2.0

Class Configurator{

    iniFile := ""
    defaultIniFile := ""

    __New(iniFile, defaultIniFile){
        this.iniFile := iniFile
        this.defaultIniFile := defaultIniFile
    }

    ChangeIniFile(iniFile){
        this.iniFile := iniFile
    }
    ChangeDefaultIniFile(defaultIniFile){
        this.defaultIniFile := defaultIniFile
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
            this.InitializeHotkey(section, iniFileFunction, inUseHotkey )
        }
    }

    ; iniFileFunction is the function found in the Config.ini file, whilst inUseHotkey is the hotkey that is currently in by default used in the script, which is also stored in the DefaultConfig.ini file.
    ; This function is used to initialize the hotkeys, there are default keys for hotkeys, but the user can change them.
    ; Section specifies the section in the ini file to look.
    ; inUseHotkey is the hotkey that is currently in use.
    ; iniFileFunction is the function that is in the ini file, for example EmergencyClose is a function, and its default inUseHotkey is F2
    ; Often inUseHotkey may be the same as iniFileFunction, but not always.
    InitializeHotkey(section, iniFileFunction, inUseHotkey){
        newHotkey := IniRead(this.iniFile, section, iniFileFunction)
        ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        if (newHotkey != inUseHotkey){
            Hotkey(inUseHotkey, "off")
            Hotkey(newHotkey, inUseHotkey)
        }
    }
}