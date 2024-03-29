#Requires AutoHotkey v2.0

#Include "HotkeyInitializer.ahk"
#Include "KeyboardOverlaysInitializer.ahk"
#Include <Util\JsonParsing\JXON\JXON>

Class MainStartupConfigurator{

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := ""

    layersInformation := ""
    objectRegistry := ""


    
    __New(){

    }
    ; layersInformation is keyboards.json information. It has a layer, for example "Primary" 
    ; and then either "Hotkeys" or "KeyboardOverlay", and then the information for that layer 
    ; (pertaining to hokteys or overlays obviously)
    SetInformation(layersInformation, objectRegistry){
        this.layersInformation := layersInformation
        this.objectRegistry := objectRegistry
        if (Type(layersInformation) = "KeyboardLayersInfoRegistry" AND Type(objectRegistry) = "ObjectRegistry"){
            this.HotkeyInitializerInstance := HotkeyInitializer()
            ; TODO probably dont pass these arguemnts hereere...
            this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(layersInformation, objectRegistry)
        }
        else{
            throw Error("Invalid parameters passed to MainStartupConfigurator")
        }
    }

    InitializeLayer(layersInformation, objectRegistry, section, enableHotkeys := "on"){
        if (Type(layersInformation) = "KeyboardLayersInfoRegistry" AND Type(objectRegistry) = "ObjectRegistry"){
            this.HotkeyInitializerInstance.InitializeHotkeys(layersInformation, objectRegistry, section . "-Hotkeys", enableHotkeys)
        }
        else{
            throw Error("Invalid parameters passed to MainStartupConfigurator")
        }
        
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