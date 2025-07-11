#Requires Autohotkey v2.0

#Include <Actions\HotkeyAction>

; TODO dont extends actin, extends overlay or something...
class KeyboardOverlayRegistry extends HotkeyAction {

    keyboardOverlays := Map()
    activeOverlay := ""

    destroy() {
        this.destroyAllLayers()
        this.activeOverlay := ""          ; Reset active overlay
    }

    destroyAllLayers() {
        for keyboardOverlayName, KeyboardOverlayObject in this.keyboardOverlays {
            KeyboardOverlayObject.destroy()
        }
        this.keyboardOverlays := Map()  ; Clear the map to free up memory
    }

    AddKeyboardOverlay(keyboardOverlay, keyboardOverlayName) {
        this.keyboardOverlays[keyboardOverlayName] := keyboardOverlay
    }

    ShowKeyboardOverlay(keyboardOverlayName) {
        this.activeOverlay := keyboardOverlayName
        this.keyboardOverlays[keyboardOverlayName].Show()
        this.HideInactiveLayers()
    }

    HideKeyboardOverlay(keyboardOverlayName) {
        this.activeOverlay := keyboardOverlayName
        this.keyboardOverlays[keyboardOverlayName].Hide()
    }

    HideInactiveLayers() {
        for keyboardOverlayName, KeyboardOverlayObject in this.keyboardOverlays {
            if (keyboardOverlayName != this.activeOverlay) {
                KeyboardOverlayObject.Hide()
            }
        }
    }

    HideAllLayers() {
        for keyboardOverlayName, KeyboardOverlayObject in this.keyboardOverlays {
            KeyboardOverlayObject.Hide()
        }
    }

    GetActiveKeyboardOverlay() {
        return this.keyboardOverlays[this.activeOverlay]
    }

    GetActiveLayer() {
        return this.activeOverlay
    }

    GetKeyboardOverlay(keyboardOverlayName) {
        return this.keyboardOverlays[keyboardOverlayName]
    }

    SetCurrentKeyboardOverlay(keyboardOverlay) {
        this.activeOverlay := keyboardOverlay
    }
}
