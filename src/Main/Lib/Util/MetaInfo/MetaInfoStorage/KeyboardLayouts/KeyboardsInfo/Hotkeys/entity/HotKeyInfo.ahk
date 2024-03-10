#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

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

    __New(fromKey){
        this.fromKey := fromKey
    }

    setInfoForNormalHotKey(toKey, modifiers){
        this.isObject := false
        this.toKey := toKey
        this.modifiers := modifiers
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
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
        if(this.isObject){
            return this.objectName . "." . this.methodName . "(" . this.parametersToString(this.parameters) . ")"
        }
        else{
            return HotkeyFormatConverter.convertToFriendlyHotkeyName(this.modifiers . this.toKey)
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

    getHotkeyName(){
        return this.fromKey
    }

    getNewHotkeyName(){
        return this.toKey
    }
    getNewHotkeyModifiers(){
        return this.modifiers
    }
    
    getFriendlyHotkeyName(){
        return HotkeyFormatConverter.convertToFriendlyHotkeyName(this.fromKey)
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