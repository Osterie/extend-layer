#Requires AutoHotkey v2.0

#Include <Actions\KeyboardOverlay\KeyboardOverlay>

class KeyboardOverlaysInitializer {

    layersInformation := ""
    objectRegistry := ""

    __New(layersInformation, objectRegistry) {
        this.layersInformation := layersInformation
        this.objectRegistry := objectRegistry
        this.instanceOfOverlayRegistry := this.objectRegistry.GetObjectInfo("OverlayRegistry").GetObjectInstance()
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    readAllKeyboardOverlays() {
        for key, value in this.layersInformation.GetKeyboardOverlaysRegistry() {

            NewKeyboardOverlay := KeyboardOverlay()
            NewKeyboardOverlay.CreateGui()

            NewKeyboardOverlay.fillKeyboardOverlayInformation(value)

            this.instanceOfOverlayRegistry.addKeyboardOverlay(NewKeyboardOverlay, key)
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
    changeHotkeysStateForKeyboardOverlaysByLayerSection(layerSection, enableHotkeys := true) {
        try {

            for key, value in this.layersInformation.GetKeyboardOverlaysRegistry() {
                if (InStr(key, layerSection)) {
                    ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                    ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
                    showKeyboardOverlayKey := this.layersInformation.GetRegistryByLayerIdentifier(key).getShowKeyboardOverlayKey()
                    this.changeHotkeyStateForKeyboardOverlay(key, showKeyboardOverlayKey, enableHotkeys)

                }
            }
        }
        catch {
            msgbox("error in KeyboardOverlaysInitializer, layer section does not exist")
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
            for key, value in this.layersInformation.GetKeyboardOverlaysRegistry() {
                if (InStr(key, "KeyboardOverlay")) {
                    showKeyboardOverlayKey := this.layersInformation.GetRegistryByLayerIdentifier(key).getShowKeyboardOverlayKey()
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
