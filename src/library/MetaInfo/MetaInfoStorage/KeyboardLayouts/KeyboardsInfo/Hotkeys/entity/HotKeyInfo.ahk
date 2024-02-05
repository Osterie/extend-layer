#Requires AutoHotkey v2.0

#Include "..\..\..\..\..\..\HotkeyFormatConverter.ahk"

class HotKeyInfo{

    hotkeyName := ""
    friendlyHotkeyName := ""
    isObject := ""
    objectName := ""
    methodName := ""
    parameters := []
    
    newHotKey := ""
    newHotKeyFriendlyName := ""
    modifiers := ""

    __New(hotkeyName){
        this.hotkeyName := hotkeyName
        this.friendlyHotkeyName := HotkeyFormatConverter.convertToFriendlyHotkeyName(hotkeyName)
    }

    setInfoForNormalHotKey(newHotKey, modifiers){
        this.isObject := false
        this.newHotKey := newHotKey
        this.modifiers := modifiers
        this.newHotKeyFriendlyName := HotkeyFormatConverter.convertToFriendlyHotkeyName(this.modifiers . this.newHotKey)
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
        this.isObject := true
        this.objectName := objectName
        this.methodName := methodName
        this.parameters := parameters
    }

    changeHotkey(newHotKeyName){
        this.hotkeyName := newHotKeyName
        this.friendlyHotkeyName := HotkeyFormatConverter.convertToFriendlyHotkeyName(newHotKeyName)
    }
    
    hotkeyIsObject(){
        return this.isObject
    }

    toString(){
        if(this.isObject){
            return this.objectName . "." . this.methodName . "(" . this.parametersToString(this.parameters) . ")"
        }
        else{
            return this.newHotKeyFriendlyName
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
        return stringToReturn
    }

    getHotkeyName(){
        return this.hotkeyName
    }

    getNewHotkeyName(){
        return this.newHotKey
    }
    getNewHotkeyModifiers(){
        return this.modifiers
    }
    getFriendlyHotkeyName(){
        return this.friendlyHotkeyName
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