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

    InitializeAllHotkeys(){
        
    }

    ; This function is used to initialize the hotkeys, there are default keys for hotkeys, but the user can change them.
    ; Section specifies the section in the ini file to look.
    ; inUseHotkey is the hotkey that is currently in use.
    ; iniFileHotkey is the hotkey that is in the ini file.
    ; Often inUseHotkey may be the same as iniFileHotkey, but not always.
    InitializeHotkey(section, iniFileHotkey, inUseHotkey){
        
        ; read the ini file for the hotkey
        newHotkey := IniRead(this.iniFile, section, iniFileHotkey)
        
        ; if the new hotkey is different from the new one, then the in use hotkey is replaced with the new hotkey
        if (newHotkey != inUseHotkey){
            Hotkey(inUseHotkey, "off")
            Hotkey(newHotkey, inUseHotkey)
        }
    }
}