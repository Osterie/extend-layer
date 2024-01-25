#Requires AutoHotkey v2.0

#Include "KeyboardOverlaysInitializer.ahk"
#Include "HotkeyInitializer.ahk"

#Include "..\..\JsonParsing\JXON\JXON.ahk"



Class MainStartupConfigurator{

    ObjectRegistry := ""
    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := ""


    __New(keyboardSettingsJsonObject, objectRegistry){
        this.objectRegistry := objectRegistry

        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(keyboardSettingsJsonObject, this.objectRegistry)

        this.HotkeyInitializerInstance := HotkeyInitializer(keyboardSettingsJsonObject, this.objectRegistry)
    }

    ReadKeysToNewActionsBySection(section){
        this.HotkeyInitializerInstance.InitializeHotkeys(section . "-Hotkeys")
        this.KeyboardOverlayInitializerInstance.CreateHotkeysForKeyboardOverlaysByLayerSection(section . "-KeyboardOverlay")
    }

    ; Reads the ini file for keyboard overlays, and then creates them based on the information in the ini file
    ReadAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.ReadAllKeyboardOverlays()
    }

    CreateGlobalHotkeysForAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.HotKeyForHidingKeyboardOverlaysUseMeGlobally()
    }
}