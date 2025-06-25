#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotkeyLayer>
#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>

class HotkeyLayerMapper {
    MapToDomainClass(layerIdentifier, layerInfoContents) {
        layer := HotkeyLayer(layerIdentifier)
        for hotkeyName, info in layerInfoContents {
            hotkey := HotKeyInfo(hotkeyName)
            if (info["isObject"]) {
                hotkey.setInfoForSpecialHotKey(info["ObjectName"], info["MethodName"], info["Parameters"])
            } 
            else if (info["isObject"] = false) {
                hotkey.setInfoForNormalHotKey(info["key"], info["modifiers"])
            }
            else{
                throw ValueError("Unknown hotkey type: " . info)
            }
            layer.addHotkey(hotkey)
        }
        return layer
    }
}
