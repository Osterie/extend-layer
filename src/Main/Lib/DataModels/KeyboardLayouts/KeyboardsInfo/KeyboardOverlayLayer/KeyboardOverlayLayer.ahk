#Requires AutoHotkey v2.0

; KeyboardOverlayInfo
class KeyboardOverlayLayer {

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := Map()

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier) {
        this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
        ; this.KeyboardLayerOverlayIdentifier := "SecondaryLayer-KeyboardOverlay1"
        ; TODO add type checks...
    }

    addKeyboardOverlayElement(KeyboardOverlayElement) {
        this.OverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    GetLayerIdentifier() {
        return this.KeyboardLayerOverlayIdentifier
    }

    getOverlayElements() {
        return this.OverlayElements
    }

    ; TODO renmae or remove, is this in use?
    getKeyPairValuesToString() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    getShowKeyboardOverlayKey() {
        return this.ShowKeyboardOverlayKey
    }

    ; TODO renmae or remove, is this in use?
    getFriendlyHotkeyActionPairValues() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    toJson(){
        jsonObject := Map()
        jsonObject["ShowKeyboardOverlayKey"] := this.ShowKeyboardOverlayKey
        jsonObject["overlayElements"] := Map()

        for elementName, keyboardOverlayElement in this.OverlayElements {
            jsonObject["overlayElements"][elementName] := keyboardOverlayElement.toJson()
        }

        return jsonObject
    }

    static fromJson(layerIdentifier, jsonObject){
        if (!jsonObject.Has("ShowKeyboardOverlayKey")){
            throw ValueError("Keyboard verlay json object missing 'ShowKeyboardOverlayKey'")
        }
        if (!jsonObject.Has("overlayElements")) {
            throw ValueError("Keyboard verlay json object missing 'overlayElements'")
        }

        layer := KeyboardOverlayLayer(jsonObject["ShowKeyboardOverlayKey"], layerIdentifier)

        for name, info in jsonObject["overlayElements"] {
            KeyboardOverlayElement_ := KeyboardOverlayElement.fromJson(info)
            layer.addKeyboardOverlayElement(KeyboardOverlayElement_)
        }
        return layer
    }
}