#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotkeyLayer>
#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayLayer>

#Include <Shared\Logger>
; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeysLayer
; KeyboardLayersInfoRegistry
class ExtendLayerProfile {

    Logger := Logger.getInstance()
    keyboardOverlayLayers := Map()
    hotkeysLayer := Map()

    __New() {
        this.keyboardOverlayLayers.Default := 0
        this.hotkeysLayer.Default := 0
    }

    AddKeyboardOverlayLayerInfo(KeyboardOverlayLayer) {
        if (Type(KeyboardOverlayLayer) != "KeyboardOverlayLayer") {
            throw Error("The KeyboardOverlayLayer must be of type KeyboardOverlayLayer")
        }
        this.keyboardOverlayLayers[KeyboardOverlayLayer.GetLayerIdentifier()] := KeyboardOverlayLayer
    }

    AddHotkeyLayer(Hotkeys) {
        if (Type(Hotkeys) != "HotkeyLayer") {
            throw Error("The Hotkeys must be of type HotkeyLayer")
        }
        this.hotkeysLayer[Hotkeys.GetLayerIdentifier()] := Hotkeys
    }

    addHotkey(layerIdentifier, hotkeyAction) {
        if (Type(hotkeyAction) != "HotkeyInfo") {
            throw Error("The hotkeyAction must be of type HotkeyInfo")
        }
        this.hotkeysLayer[layerIdentifier].addHotkey(hotkeyAction)
    }

    deleteHotkey(layerIdentifier, hotkeyName) {
        this.hotkeysLayer[layerIdentifier].deleteHotkey(hotkeyName)
    }

    ; TODO remove me perhaps, a new and better method is being developed...
    changeHotkey(layerIdentifier, hotkeyName, newHotkey) {
        this.hotkeysLayer[layerIdentifier].ChangeHotkeyKey(hotkeyName, newHotkey)
    }

    ; TODO add checks if empty string or such is given.
    ChangeAction(layerIdentifier, hotkeyName, newAction) {
        this.hotkeysLayer[layerIdentifier].ChangeHotkeyAction(hotkeyName, newAction)
    }

    ; TODO implement this and use it for creating new actions/hotkeysLayer with the gui.
    ; SetAction(layerIdentifier, hotkeyName, action){
    ;     this.hotkeysLayer[layerIdentifier].SetHotkeyAction(hotkeyName, action)
    ; }

    ; TODO refactor

    getLayerByLayerIdentifier(layerIdentifier) {
        layerToReturn := ""
        if (this.keyboardOverlayLayers.Has(layerIdentifier)) {
            layerToReturn := this.keyboardOverlayLayers[layerIdentifier]
        }
        else if (this.hotkeysLayer.Has(layerIdentifier)) {
            layerToReturn := this.hotkeysLayer[layerIdentifier]
        }
        else {
            throw ("No registry found for layer identifier: " . layerIdentifier)
        }
        return layerToReturn
    }

    getKeyboardOverlayByLayerIdentifier(layerIdentifier) {
        if (this.keyboardOverlayLayers.Has(layerIdentifier)) {
            return this.keyboardOverlayLayers[layerIdentifier]
        }
        else {
            throw ("No keyboard overlay found for layer identifier: " . layerIdentifier)
        }
    }

    getHotkeyLayerByLayerIdentifier(layerIdentifier) {
        if (this.hotkeysLayer.Has(layerIdentifier)) {
            return this.hotkeysLayer[layerIdentifier]
        }
        else {
            throw ("No hotkey layer found for layer identifier: " . layerIdentifier)
        }
    }

    GetLayerIdentifiers() {
        layerIdentifiers := Array()
        for layerIdentifier, layerInfo in this.hotkeysLayer {
            layerIdentifiers.Push(layerIdentifier)
        }
        for layerIdentifier, layerInfo in this.keyboardOverlayLayers {
            layerIdentifiers.Push(layerIdentifier)
        }
        return layerIdentifiers
    }

    GetKeyboardOverlayLayers() {
        ; TODO return array instead of map?
        return this.keyboardOverlayLayers
    }

    GetHotkeyLayer() {
        return this.hotkeysLayer
    }

    GetHotkeyInfoForLayer(layerIdentifier, hotkeyKey) {
        return this.getLayerByLayerIdentifier(layerIdentifier).GetHotkey(hotkeyKey)
    }

    toJson() {
        jsonObject := Map()

        for hotkeyLayerIdentifier, HotkeyLayer in this.hotkeysLayer {
            jsonObject[hotkeyLayerIdentifier] := HotkeyLayer.toJson()
        }

        for keyboardOverlayLayerIdentifier, KeyboardOverlayLayer in this.keyboardOverlayLayers {
            jsonObject[keyboardOverlayLayerIdentifier] := KeyboardOverlayLayer.toJson()
        }

        return jsonObject
    }

    static fromJson(jsonObject) {

        ExtendLayerProfile_ := ExtendLayerProfile()

        for layerIdentifier, layerInfoContents in jsonObject {
            if (InStr(layerIdentifier, "Hotkeys")) {
                HotkeyLayer_ := HotkeyLayer.fromJson(layerIdentifier, layerInfoContents)
                ExtendLayerProfile_.addHotkeyLayer(HotkeyLayer_)
            }
            else if (InStr(layerIdentifier, "KeyboardOverlay")) {
                try {
                    KeyboardOverlayLayer_ := KeyboardOverlayLayer.fromJson(layerIdentifier, layerInfoContents)
                    ExtendLayerProfile_.AddKeyboardOverlayLayerInfo(KeyboardOverlayLayer_)
                }
                catch Error as e {
                    Logger.getInstance().logError("Error while reading keyboard overlay information: " . e.message)
                }
            }
            else {
                throw ("Unknown layer type: " . layerIdentifier)
            }
        }

        return ExtendLayerProfile_
    }
}
