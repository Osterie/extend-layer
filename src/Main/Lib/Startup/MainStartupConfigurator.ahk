#Requires AutoHotkey v2.0

#Include <Startup\HotkeyInitializer>
#Include <Startup\KeyboardOverlaysInitializer>

#Include <Util\JsonParsing\JXON>

class MainStartupConfigurator {

    KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer()
    HotkeyInitializerInstance := HotkeyInitializer()

    ; TODO refactor
    
    __New() {
        this.HotkeyInitializerInstance := HotkeyInitializer()
        this.KeyboardOverlayInitializerInstance := KeyboardOverlaysInitializer()
    }

    initializeLayer(section, enableHotkeys := true) {
        this.HotkeyInitializerInstance.initializeHotkeys(section . "-Hotkeys", enableHotkeys)

        this.KeyboardOverlayInitializerInstance.changeHotkeysStateForKeyboardOverlaysByLayerSection(
            section . "-KeyboardOverlay",
            enableHotkeys
        )
    }

    createGlobalHotkeysForAllKeyboardOverlays() {
        this.KeyboardOverlayInitializerInstance.hotKeyForHidingKeyboardOverlaysUseMeGlobally()
    }
}
