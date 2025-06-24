#Requires AutoHotkey v2.0

#Include <Startup\HotkeyInitializer>
#Include <Startup\KeyboardOverlaysInitializer>

#Include <Util\JsonParsing\JXON>

#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileRepository>

class MainStartupConfigurator {

    KeyboardOverlayInitializerInstance := ""
    HotkeyInitializerInstance := HotkeyInitializer()

    ; TODO refactor
    
    __New() {
        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer()
    }

    initializeLayer(section, enableHotkeys := "on") {
        this.HotkeyInitializerInstance.initializeHotkeys(section . "-Hotkeys", enableHotkeys)

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
