#Requires AutoHotkey v2.0

#Include "IniFileReader.ahk"
#Include "KeyboardOverlaysInitializer.ahk"
#Include "HotkeyInitializer.ahk"


Class MainStartupConfigurator{

    iniFile := ""
    ObjectRegistry := ""

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := ""


    __New(iniFile, objectRegistry){
        this.iniFile := iniFile
        this.objectRegistry := objectRegistry

        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(this.iniFile, this.objectRegistry)
        this.HotkeyInitializerInstance := HotkeyInitializer(this.iniFile, this.objectRegistry)
    }

    ReadKeysToNewActionsBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeyToNewKeys(section . "-DefaultKeys")
        this.HotkeyInitializerInstance.InitializeAllDefaultKeysToFunctions(section . "-Functions")
        this.KeyboardOverlayInitializerInstance.CreateHotkeysForKeyboardOverlaysByLayerSection(section . "-KeyboardOverlay")
    }

    ; Reads the ini file for keyboard overlays, and then creates them based on the information in the ini file
    ReadAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.ReadAllKeyboardOverlays()
    }

    ; Reads the ini file to find which keys are used to show the keyboard overlays, and then creates the hotkeys for them
    ; this is its own method because it has to be called in the correct hotifs in the main script
    ReadKeysToShowKeyboardOverlaysByLayerSection(layerSection){
        this.KeyboardOverlayInitializerInstance.CreateHotkeysForKeyboardOverlaysByLayerSection(layerSection)
    }

    ; Reads all the keys in a specific section of the ini file, and then creates hotkeys for them.
    ; Onlye works for keys which are changed into new keys
    ReadKeysToNewKeysBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeyToNewKeys(section)
    }

    ; Reads all the keys in a specific section of the ini file, and then creates hotkeys for them.
    ; Onlye works for keys which are changed into functions
    ReadKeysToFunctionsBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeysToFunctions(section)
    }
}