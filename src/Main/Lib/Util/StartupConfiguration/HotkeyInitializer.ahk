#Requires AutoHotkey v2.0

Class HotkeyInitializer{

    jsonFile := ""
    ObjectRegistry := ""

    __New(jsonFile, objectRegistry){
        this.jsonFile := jsonFile
        this.ObjectRegistry := objectRegistry
    }
    
    InitializeHotkeys(keyboardLayerName, enableHotkeys := true){
        currentKeyboardLayerInformation := this.jsonFile[keyboardLayerName]
        For OriginalKeybind, newKeyBindInformation in currentKeyboardLayerInformation{
            if (newKeyBindInformation["isObject"] == true){
                this.InitializeDefaultKeyToFunction(OriginalKeybind, newKeyBindInformation, enableHotkeys)
            }
            else{
                this.InitializeDefaultKeyToNewKey(OriginalKeybind, newKeyBindInformation, enableHotkeys)
            }
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    InitializeDefaultKeyToFunction(oldHotKey, functionInformation, enableHotkeys := true){
        
        objectName := functionInformation["ObjectName"]
        methodName := functionInformation["MethodName"]
        arguments := functionInformation["Parameters"]
 
        objectInstance := this.ObjectRegistry.GetObjectInfo(objectName).GetObjectInstance()
        objectMethodCall := ObjBindMethod(objectInstance, methodName, arguments*)
        ; msgbox("creating hotkey")
        if (enableHotkeys){
            HotKey(oldHotKey, (ThisHotkey) => (objectMethodCall)(), "On")
        }
        else if (enableHotkeys = false){
            HotKey(oldHotKey, (ThisHotkey) => (objectMethodCall)(), "Off")
        }
        else{
            msgbox("error in InitializeDefaultKeyToFunction, enableHotkeys is not true or false in InitializeDefaultKeyToFunction")
        }
    }

    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    InitializeDefaultKeyToNewKey(oldHotKey, newKeyInformation, enableHotkeys := true){
        newHotKey := newKeyInformation["key"]
        newHotKeyModifiers := newKeyInformation["modifiers"]
        
        newKeysDown := this.CreateExcecutableKeysDown(newHotKey)
        newKeysUp := this.CreateExcecutableKeysUp(newHotKey)

        if (enableHotkeys){
            HotKey(oldHotKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "On") 
            HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "On")
        }
        else if (enableHotkeys = false){
            HotKey(oldHotKey, (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "Off") 
            HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "Off")
        } 
        else {
            msgbox("error in InitializeDefaultKeyToNewKey, state is not on or off")
        }
    }

    ; Sends key(s) down, including possible modifiers
    SendKeysDown(keysDown, modifiers){
        Send("{blind}" . modifiers . keysDown)
    }
    
    ; Sends key(s) up, including possible modifiers
    SendKeysUp(keysUp, modifiers){
        Send("{blind}" . modifiers . keysUp)
    }

    CreateExcecutableKeysDown(keys){
        keysList := StrSplit(keys, "||")
        excecutableKeysDown := ""
        for key in keysList{
            excecutableKeysDown .= "{" . key . " Down}"
        }
        return excecutableKeysDown
    }

    CreateExcecutableKeysUp(keys){
        keysList := StrSplit(keys, "||")
        excecutableKeysUp := ""
        for key in keysList{
            excecutableKeysUp .= "{" . key . " Up}"
        }
        return excecutableKeysUp
    }
}