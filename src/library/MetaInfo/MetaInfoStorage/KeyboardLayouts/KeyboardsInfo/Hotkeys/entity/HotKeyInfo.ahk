#Requires AutoHotkey v2.0

class HotKeyInfo{

    hotkeyName := ""
    isObject := ""
    objectName := ""
    methodName := ""
    parameters := []
    
    key := ""
    modifiers := ""

    __New(hotkeyName){
        this.hotkeyName := hotkeyName
    }

    setInfoForNormalHotKey(key, modifiers){
        this.isObject := false
        this.key := key
        this.modifiers := modifiers
    }
    
    hotkeyIsObject(){
        return this.isObject
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
        this.isObject := true
        this.objectName := objectName
        this.methodName := methodName
        this.parameters := parameters
    }

    toString(){
        if(this.isObject){
            return this.objectName . "." . this.methodName . "(" . this.parametersToString(this.parameters) . ")"
        }
        else{
            return this.modifiers . " + " . this.key
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
}