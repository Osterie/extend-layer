#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayLayer>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\KeyboardOverlayLayer\KeyboardOverlayElement>

class KeyboardOverlayMapper {
    Map(layerIdentifier, layerInfoContents) {
        if !layerInfoContents.Has("ShowKeyboardOverlayKey")
            throw "Missing 'ShowKeyboardOverlayKey'"

        layer := KeyboardOverlayLayer(layerInfoContents["ShowKeyboardOverlayKey"], layerIdentifier)

        if layerInfoContents.Has("overlayElements") {
            for name, info in layerInfoContents["overlayElements"] {
                element := KeyboardOverlayElement(name, info["key"], info["description"])
                layer.addKeyboardOverlayElement(element)
            }
        }
        return layer
    }
}
