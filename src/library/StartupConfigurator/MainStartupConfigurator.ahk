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

    ReadAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.ReadAllKeyboardOverlays()
    }

    ReadKeysToShowKeyboardOverlaysByLayerSection(layerSection){
        this.KeyboardOverlayInitializerInstance.CreateHotkeyForKeyboardOverlayByLayerSection(layerSection)
    }

    ReadKeysToNewActionsBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeyToNewKeys(section . "-DefaultKeys")
        this.HotkeyInitializerInstance.InitializeAllDefaultKeysToFunctions(section . "-Functions")
    }

    ReadKeysToNewKeysBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeyToNewKeys(section)
    }

    ReadKeysToFunctionsBySection(section){
        this.HotkeyInitializerInstance.InitializeAllDefaultKeysToFunctions(section)
    }
}