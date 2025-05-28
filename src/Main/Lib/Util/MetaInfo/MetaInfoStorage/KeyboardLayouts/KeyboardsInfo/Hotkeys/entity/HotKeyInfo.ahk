#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

; TODO perhaps this should work together with the main startupr configurator which creates all the hotkeys
class HotKeyInfo{

    ; The key to press to trigger the "toKey" or the "objectName.methodName(parameters)" action.
    fromKey := ""
    isObject := ""
    objectName := ""
    methodName := ""
    parameters := []
    
    ; The key triggered by fromKey. For example, if fromKey is "a", and toKey is "b". Pressing "a" would result in "b" being sent.
    toKey := ""
    modifiers := ""

    actionSet := false

    __New(fromKey := ""){
        this.fromKey := fromKey
        this.actionSet := false
    }

    setInfoForNormalHotKey(toKey, modifiers?){
        this.actionSet := true
        this.isObject := false

        if (IsSet(modifiers)){
            this.setNewHotkeyModifiers(modifiers)
            this.toKey := toKey
        }
        else{
            this.setNormalHotkeySingle(toKey)
        }
    }

    setNormalHotkeySingle(toKeyWithModifiers){
        modifiersAndHotkey := HotkeyFormatConverter.splitModifiersAndHotkey(toKeyWithModifiers)
        this.setNewHotkeyModifiers(modifiersAndHotkey[1])
        this.toKey := modifiersAndHotkey[2]
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
        this.actionSet := true
        this.isObject := true
        this.objectName := objectName
        this.methodName := methodName
        this.parameters := parameters
    }

    changeHotkey(newHotKeyName){
        this.fromKey := newHotKeyName
    }

    hotkeyIsObject(){
        return this.isObject
    }

    toString(){
        if (this.actionSet){
            if(this.hotkeyIsObject()){
                return this.objectName . "." . this.methodName . "(" . this.parametersToString(this.parameters) . ")"
            }
            else{
                return HotkeyFormatConverter.convertToFriendlyHotkeyName(this.modifiers . this.toKey)
            }
        }
        else{
            return ""
        }
    }

    parametersToString(parameters){
        if (this.parameters.length == 0){
            return ""
        }

        stringToReturn := ""

        for argument in this.parameters{
            if (Type(argument) == "Array"){
                For subArgument in argument{
                    stringToReturn .= subArgument . ","
                }
            }
            else{
                stringToReturn .= argument . ","
            }
        }

        ; Remove the last comma, which should not be there yaknow
        stringToReturn := RegExReplace(stringToReturn, "," , "",,  1, -1)


        return stringToReturn
    }

    actionIsSet(){
        return this.actionSet
    }

    getHotkeyName(){
        return this.fromKey
    }

    getNewHotkeyName(){
        return this.toKey
    }

    setNewHotkeyModifiers(newModifiers){
        newModifiers := StrReplace(newModifiers, "*", "")
        newModifiers := StrReplace(newModifiers, " Up", "")
        this.modifiers := newModifiers
    }

    getNewHotkeyModifiers(){
        return this.modifiers
    }
    
    getFriendlyHotkeyName(){
        friendlyNameToReturn := ""
        if (this.fromKey != ""){
            friendlyNameToReturn := HotkeyFormatConverter.convertToFriendlyHotkeyName(this.fromKey)
        }
        return friendlyNameToReturn
    }

    getObjectName(){
        return this.objectName
    }

    getMethodName(){
        return this.methodName
    }

    getParameters(){
        return this.parameters
    }
}