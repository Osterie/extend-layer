#Requires AutoHotkey v2.0

#Include "HotkeyInitializer.ahk"
#Include "KeyboardOverlaysInitializer.ahk"
#Include <Util\JsonParsing\JXON\JXON>

Class MainStartupConfigurator{

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := ""


    ; layersInformation is keyboards.json information. It has a layer, for example "Primary" 
    ; and then either "Hotkeys" or "KeyboardOverlay", and then the information for that layer 
    ; (pertaining to hokteys or overlays obviously)
    __New(layersInformation, objectRegistry){
        
        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(layersInformation, objectRegistry)
        this.HotkeyInitializerInstance := HotkeyInitializer(layersInformation, objectRegistry)
    }

    InitializeLayer(section, enableHotkeys := "on"){
        this.HotkeyInitializerInstance.InitializeHotkeys(section . "-Hotkeys", enableHotkeys)
        this.KeyboardOverlayInitializerInstance.ChangeHotkeysStateForKeyboardOverlaysByLayerSection(section . "-KeyboardOverlay", enableHotkeys)
    }

    ; Reads the ini file for keyboard overlays, and then creates them based on the information in the ini file
    ReadAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.ReadAllKeyboardOverlays()
    }

    CreateGlobalHotkeysForAllKeyboardOverlays(){
        this.KeyboardOverlayInitializerInstance.HotKeyForHidingKeyboardOverlaysUseMeGlobally()
    }
}