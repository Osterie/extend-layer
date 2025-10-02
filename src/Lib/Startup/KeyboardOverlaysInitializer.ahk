#Requires AutoHotkey v2.0

#Include <Actions\KeyboardOverlay\KeyboardOverlay>

#Include <Infrastructure\Repositories\ActionGroupsRepository>
#Include <Infrastructure\CurrentExtendLayerProfileManager>

class KeyboardOverlaysInitializer {

    ; TODO refactor. make CurrentExtendLayerProfileManager have some helpful methods.

    __New() {
        this.instanceOfOverlayRegistry := ActionGroupsRepository.getInstance().getActionObjectInstance("OverlayRegistry")
        this.readAllKeyboardOverlays()
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    readAllKeyboardOverlays() {
        keyboardOverlayLayers := CurrentExtendLayerProfileManager.getInstance().GetKeyboardOverlayLayers()
        for keyboardOverlayName, keyboardOverlayLayer in keyboardOverlayLayers {

            NewKeyboardOverlay := KeyboardOverlay()
            NewKeyboardOverlay.CreateGui()
            NewKeyboardOverlay.fillKeyboardOverlayInformation(keyboardOverlayLayer)

            this.instanceOfOverlayRegistry.addKeyboardOverlay(NewKeyboardOverlay, keyboardOverlayName)
        }
    }

    fillKeyboardOverlayInformation(KeyboardOverlay, KeyboardOverlayElements) {
        for overlayElementName, overlayElementInformation in KeyboardOverlayElements {
            key := overlayElementInformation["key"]
            description := overlayElementInformation["description"]
            this.setKeyboardOverlayValues(KeyboardOverlay, key, description)
        }

    }

    setKeyboardOverlayValues(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName) {
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }

    ; FIXME does not work probably TODO
    changeHotkeysStateForKeyboardOverlaysByLayerSection(keyboardOverlayLayer, enableHotkeys := true) {
        try {
            keyboardOverlayLayers := CurrentExtendLayerProfileManager.getInstance().GetKeyboardOverlayLayers()
            for keyboardOverlayName, value in keyboardOverlayLayers {
                if (InStr(keyboardOverlayName, keyboardOverlayLayer)) {
                    ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                    ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                    showKeyboardOverlayKey := CurrentExtendLayerProfileManager.getInstance().getShowKeyboardOverlayKey(keyboardOverlayName)
                    this.changeHotkeyStateForKeyboardOverlay(keyboardOverlayName, showKeyboardOverlayKey, enableHotkeys)
                }
            }
        }
        catch Error as e {

            msgbox("error in KeyboardOverlaysInitializer: " . e.Message)
            ; overlay does not exist...
        }
    }

    changeHotkeyStateForKeyboardOverlay(sectionName, showKeyboardOverlayKey, enableHotkeys := true) {
        if (enableHotkeys) {
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfOverlayRegistry.ShowKeyboardOverlay(
                sectionName))
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers())
        }
        else if (enableHotkeys = false) {
            HotKey(showKeyboardOverlayKey, (ThisHotkey) => this.instanceOfOverlayRegistry.ShowKeyboardOverlay(
                sectionName), "off")
            HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers(),
            "off")
        }
        else {
            msgbox("error in KeyboardOverlaysInitializer, state is not on or off")
        }
    }

    hotKeyForHidingKeyboardOverlaysUseMeGlobally() {
        try {
            keyboardOverlayLayers := CurrentExtendLayerProfileManager.getInstance().GetKeyboardOverlayLayers()
            for keyboardOverlayName, keyboardOverlayLayer in keyboardOverlayLayers {
                if (InStr(keyboardOverlayName, "KeyboardOverlay")) {
                    showKeyboardOverlayKey := CurrentExtendLayerProfileManager.getInstance().getShowKeyboardOverlayKey(keyboardOverlayName)
                    HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => this.instanceOfOverlayRegistry.hideAllLayers())
                }
            }
        }
        catch Error as e {
            msgbox(e.Message)
            ; overlay does not exist...
        }
    }
}
