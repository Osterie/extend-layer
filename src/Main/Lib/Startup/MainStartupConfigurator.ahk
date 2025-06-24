#Requires AutoHotkey v2.0

#Include <Startup\HotkeyInitializer>
#Include <Startup\KeyboardOverlaysInitializer>

#Include <Util\JsonParsing\JXON>

class MainStartupConfigurator {

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := HotkeyInitializer()

    layersInformation := ""
    
    __New() {

    }
    ; layersInformation is keyboards.json information. It has a layer, for example "Primary"
    ; and then either "Hotkeys" or "KeyboardOverlay", and then the information for that layer
    ; (pertaining to hokteys or overlays obviously)
    setInformation(layersInformation) {
        if (Type(layersInformation) != "ExtendLayerProfile") {
            throw Error("Invalid parameters passed to MainStartupConfigurator")
        }
        this.layersInformation := layersInformation
        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer(layersInformation)
    }

    initializeLayer(layersInformation, section, enableHotkeys := "on") {
        if (Type(layersInformation) != "ExtendLayerProfile") {
            throw Error("Invalid parameters passed to MainStartupConfigurator")
        }

        this.HotkeyInitializerInstance.initializeHotkeys(layersInformation, section . "-Hotkeys", enableHotkeys)

        this.KeyboardOverlayInitializerInstance.changeHotkeysStateForKeyboardOverlaysByLayerSection(
            section . "-KeyboardOverlay",
            enableHotkeys
        )
    }

    ; Reads the ini file for keyboard overlays, and then creates them based on the information in the ini file
    readAllKeyboardOverlays() {
        this.KeyboardOverlayInitializerInstance.readAllKeyboardOverlays()
    }

    createGlobalHotkeysForAllKeyboardOverlays() {
        this.KeyboardOverlayInitializerInstance.hotKeyForHidingKeyboardOverlaysUseMeGlobally()
    }
}
