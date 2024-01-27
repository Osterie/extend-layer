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
        this.hotkeyName = hotkeyName
    }

    setInfoForNormalHotKey(key, modifiers){
        this.isObject := false
        this.key := key
        this.modifiers := modifiers
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
        this.isObject := true
        this.objectName := objectName
        this.methodName := methodName
        this.parameters := parameters
    }

    toString(){
        if(this.isObject){
            return this.objectName + "." + this.methodName + "(" + this.parameters.join(", ") + ")"
        }
        else{
            return this.modifiers + " + " + this.key
        }
    }

    getHotkeyName(){
        return this.hotkeyName
    }
}