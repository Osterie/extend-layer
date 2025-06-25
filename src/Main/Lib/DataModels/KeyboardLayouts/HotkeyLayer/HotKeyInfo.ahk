#Requires AutoHotkey v2.0

#Include <Util\Formaters\HotkeyFormatter>

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
; HotKeyInfo
class HotKeyInfo {

    ; The key to press to trigger the "toKey" or the "objectName.methodName(parameters)" action.
    fromKey := ""
    isObject := ""
    objectName := ""
    actionName := ""
    parameters := []

    ; The key triggered by fromKey. For example, if fromKey is "a", and toKey is "b". Pressing "a" would result in "b" being sent.
    toKey := ""
    modifiers := ""

    actionSet := false

    __New(fromKey := "") {
        this.fromKey := fromKey
        this.actionSet := false
    }

    setInfoForNormalHotKey(toKey, modifiers?) {
        this.actionSet := true
        this.isObject := false

        if (IsSet(modifiers)) {
            this.setNewHotkeyModifiers(modifiers)
            this.toKey := toKey
        }
        else {
            this.setNormalHotkeySingle(toKey)
        }
    }

    setNormalHotkeySingle(toKeyWithModifiers) {
        modifiersAndHotkey := HotkeyFormatter.splitModifiersAndHotkey(toKeyWithModifiers)
        this.setNewHotkeyModifiers(modifiersAndHotkey[1])
        this.toKey := modifiersAndHotkey[2]
    }

    setInfoForSpecialHotKey(objectName, actionName, parameters) {
        this.actionSet := true
        this.isObject := true
        this.objectName := objectName
        this.actionName := actionName
        this.parameters := parameters
    }

    changeHotkey(newHotKeyName) {
        this.fromKey := newHotKeyName
    }

    hotkeyIsObject() {
        return this.isObject
    }

    toString() {
        if (this.actionSet) {
            if (this.hotkeyIsObject()) {
                return this.objectName . "." . this.actionName . "(" . this.parametersToString(this.parameters) . ")"
            }
            else {
                return HotkeyFormatter.convertToFriendlyHotkeyName(this.modifiers . this.toKey)
            }
        }
        else {
            return ""
        }
    }

    parametersToString(parameters) {
        if (this.parameters.length == 0) {
            return ""
        }

        stringToReturn := ""

        for argument in this.parameters {
            if (Type(argument) == "Array") {
                for subArgument in argument {
                    stringToReturn .= subArgument . ","
                }
            }
            else {
                stringToReturn .= argument . ","
            }
        }

        ; Remove the last comma, which should not be there yaknow
        stringToReturn := RegExReplace(stringToReturn, ",", "", , 1, -1)

        return stringToReturn
    }

    actionIsSet() {
        return this.actionSet
    }

    getHotkeyName() {
        return this.fromKey
    }

    getNewHotkeyName() {
        return this.toKey
    }

    setNewHotkeyModifiers(newModifiers) {
        this.modifiers := newModifiers
    }

    getNewHotkeyModifiers() {
        return this.modifiers
    }

    getFriendlyHotkeyName() {
        friendlyNameToReturn := ""
        if (this.fromKey != "") {
            friendlyNameToReturn := HotkeyFormatter.convertToFriendlyHotkeyName(this.fromKey)
        }
        return friendlyNameToReturn
    }

    getObjectName() {
        return this.objectName
    }

    getActionName() {
        return this.actionName
    }

    getParameters() {
        return this.parameters
    }

    toJson() {
        jsonObject := Map()
        if (this.hotkeyIsObject()) {
            jsonObject["isObject"] := true
            jsonObject["ObjectName"] := this.getObjectName()
            jsonObject["MethodName"] := this.getActionName()
            jsonObject["Parameters"] := this.getParameters()
        } else {
            jsonObject["isObject"] := false
            jsonObject["key"] := this.getNewHotkeyName()
            jsonObject["modifiers"] := this.getNewHotkeyModifiers()
        }
        return jsonObject
    }

    static fromJson(hotkeyName, jsonObject) {
        hotkey := HotKeyInfo(hotkeyName)
        if (jsonObject["isObject"]) {
            hotkey.setInfoForSpecialHotKey(jsonObject["ObjectName"], jsonObject["MethodName"], jsonObject["Parameters"])
        } 
        else if (jsonObject["isObject"] = false) {
            hotkey.setInfoForNormalHotKey(jsonObject["key"], jsonObject["modifiers"])
        }
        else {
            throw ValueError("Unknown hotkey type: " . jsonObject)
        }
        return hotkey
    }
}
