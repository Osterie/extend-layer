#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>
#Include <Infrastructure\Repositories\ExtendLayerProfile\HotkeyLayerMapper>
#Include <Infrastructure\Repositories\ExtendLayerProfile\KeyboardOverlayMapper>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class ExtendLayerProfileMapper {

    Logger := Logger.getInstance()

    MapToDomainClass(jsonObject) {

        ExtendLayerProfile_ := ExtendLayerProfile()

        HotkeyLayerMapper_ := HotkeyLayerMapper()
        KeyboardOverlayMapper_ := KeyboardOverlayMapper()

        for layerIdentifier, layerInfoContents in jsonObject {
            if (InStr(layerIdentifier, "Hotkeys")) {
                HotkeyLayer_ := HotkeyLayerMapper_.MapToDomainClass(layerIdentifier, layerInfoContents)
                ExtendLayerProfile_.addHotkeyLayer(HotkeyLayer_)
            }
            else if (InStr(layerIdentifier, "KeyboardOverlay")) {
                try {
                    KeyboardOverlayLayer_ := KeyboardOverlayMapper_.MapToDomainClass(layerIdentifier, layerInfoContents
                    )
                    ExtendLayerProfile_.AddKeyboardOverlayLayerInfo(KeyboardOverlayLayer_)
                }
                catch Error as e {
                    this.Logger.logError("Error while reading keyboard overlay information: " . e.message)
                }
            }
            else {
                throw ("Unknown layer type: " . layerIdentifier)
            }
        }

        return ExtendLayerProfile_
    }

    MapToJsonObject(ExtendLayerProfile) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }

        jsonObject := {}

        for layerIdentifier, hotkeyLayer in ExtendLayerProfile.getHotkeyLayers() {
            jsonObject[layerIdentifier] := hotkeyLayer.toJson()
        }

        for layerIdentifier, keyboardOverlayLayer in ExtendLayerProfile.getKeyboardOverlays() {
            jsonObject[layerIdentifier] := keyboardOverlayLayer.toJson()
        }

        return jsonObject
    }
}
