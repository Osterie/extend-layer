#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayElement>

; KeyboardOverlayInfo
class KeyboardOverlayLayer {

    KeyboardLayerOverlayIdentifier := ""
    ShowKeyboardOverlayKey := ""
    OverlayElements := Map()

    __New(ShowKeyboardOverlayKey, KeyboardLayerOverlayIdentifier) {
        this.ShowKeyboardOverlayKey := ShowKeyboardOverlayKey
        this.KeyboardLayerOverlayIdentifier := KeyboardLayerOverlayIdentifier
    }

    addKeyboardOverlayElement(KeyboardOverlayElement) {
        if (Type(KeyboardOverlayElement) != "KeyboardOverlayElement") {
            throw TypeError("KeyboardOverlayElement must be of type KeyboardOverlayElement, got: " . Type(KeyboardOverlayElement))
        }
        this.OverlayElements.Set(KeyboardOverlayElement.getElementName(), KeyboardOverlayElement)
    }

    GetLayerIdentifier() {
        return this.KeyboardLayerOverlayIdentifier
    }

    getOverlayElements() {
        return this.OverlayElements
    }

    ; TODO these are named this way since they are like HotkeyLayer is used. But instead HotkeyLayer and KeyboardOverlayLayer should inherit from a common base class.
    getKeyPairValuesToString() {
        elements := []
        for elementNames, KeyboardOverlayElement in this.OverlayElements
            elements.push([KeyboardOverlayElement.getKey(), KeyboardOverlayElement.getDescription()])
        return elements
    }

    getShowKeyboardOverlayKey() {
        return this.ShowKeyboardOverlayKey
    }

    ; TODO these are named this way since they are like HotkeyLayer is used. But instead HotkeyLayer and KeyboardOverlayLayer should inherit from a common base class.
    ; TODO change! return the class isntead of this array of pairs.
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