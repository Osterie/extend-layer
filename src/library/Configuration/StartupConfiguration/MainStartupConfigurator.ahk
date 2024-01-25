#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"
#Include "KeyboardOverlaysInitializer.ahk"
#Include "HotkeyInitializer.ahk"

#Include "..\..\JsonParsing\JXON\JXON.ahk"



Class MainStartupConfigurator{

    profile := ""
    ObjectRegistry := ""

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := ""


    __New(profile, objectRegistry){
        this.profile := profile
        this.objectRegistry := objectRegistry

        keyboardsSettingsFileLocation := this.profile . "\Keyboards.json"

        keyboardSettingsString := FileRead(keyboardsSettingsFileLocation, "UTF-8")
        keyboardSettingsJson := jxon_load(&keyboardSettingsString)

        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(keyboardSettingsJson, this.objectRegistry)

        this.HotkeyInitializerInstance := HotkeyInitializer(keyboardSettingsJson, this.objectRegistry)
    }

    ReadKeysToNewActionsBySection(section){
        this.HotkeyInitializerInstance.InitializeHotkeys(section . "-Hotkeys")
        ; this.HotkeyInitializerInstance.InitializeAllDefaultKeysToFunctions(section . "-Functions")
        this.KeyboardOverlayInitializerInstance.CreateHotkeysForKeyboardOverlaysByLayerSection(section . "-KeyboardOverlay")
    }

    ; Reads the ini file for keyboard overlays, and then creates them based on the information in the ini file
    ReadAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.ReadAllKeyboardOverlays()
    }
}