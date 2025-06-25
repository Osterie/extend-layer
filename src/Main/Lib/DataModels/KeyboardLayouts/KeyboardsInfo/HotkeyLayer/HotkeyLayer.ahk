#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>

#Include <Util\Formaters\HotkeyFormatter>

; HotkeysRegistry
class HotkeyLayer {

    hotkeys := Map()
    layerIdentifier := ""

    __New(layerIdentifier) {
        this.layerIdentifier := layerIdentifier
        this.hotkeys.Default := ""
    }

    addHotkey(HotkeyInfo) {
        this.hotkeys[HotkeyInfo.getHotkeyName()] := HotkeyInfo
    }

    deleteHotkey(hotkeyName) {
        this.hotkeys.Delete(hotkeyName)
    }

    GetLayerIdentifier() {
        return this.layerIdentifier
    }

    GetHotkey(hotkeyName) {
        hotkeyInfoToReturn := this.hotkeys.get(hotkeyName)
        if (hotkeyInfoToReturn = "") {
            hotkeyInfoToReturn := this.hotkeys.get(HotkeyFormatter.convertFromFriendlyName(hotkeyName))
        }
        return hotkeyInfoToReturn
    }

    ; TODO instead of reading the entire profile for keyboard again, perhaps i can just change the hotkey with this...
    ChangeHotkeyKey(hotkeyName, newHotkey) {
        if (hotkeyName != newHotkey) {
            if (StrLen(newHotKey) != 0) {
                ; Replaces the old hotkey with the new one
                ; TODO this method is not complete, it should have a parameter for hotkeyInfo, which is the hotkey that will be replaced and such...
                this.hotkeys[hotkeyName].changeHotkey(newHotkey)
                this.hotkeys[newHotKey] := this.hotkeys[hotkeyName]
            }
            this.hotkeys.Delete(hotkeyName)
        }
    }

    ChangeHotkeyAction(hotkeyName, newHotkeyAction) {
        this.hotkeys[hotkeyName] := newHotkeyAction
    }

    GetHotkeys() {
        allHotkeys := []
        for key, hotkey in this.hotkeys {
            allHotkeys.push(hotkey)
        }
        return allHotkeys
    }

    getKeyPairValuesToString() {
        elements := []
        for key, value in this.hotkeys
            elements.push([key, value.ToString()])

        return elements
    }

    getFriendlyHotkeyActionPairValues() {
        elements := []
        for key, value in this.hotkeys
            elements.push([value.getFriendlyHotkeyName(), value.ToString()])

        return elements
    }

    toJson() {
        jsonObject := Map()
        for hotkeyName, hotkeyInfo in this.hotkeys {
            jsonObject[hotkeyName] := hotkeyInfo.toJson()
        }
        return jsonObject
    }

    static fromJson(layerIdentifier, jsonObject) {

        HotkeyLayer_ := HotkeyLayer(layerIdentifier)

        for hotkeyName, info in jsonObject {
            hotkey := HotKeyInfo.fromJson(hotkeyName, info)
            HotkeyLayer_.addHotkey(hotkey)
        }
        return HotkeyLayer_
    }
}
