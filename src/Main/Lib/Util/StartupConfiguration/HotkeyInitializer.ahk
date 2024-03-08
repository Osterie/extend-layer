#Requires AutoHotkey v2.0

Class HotkeyInitializer{

    layersInformation := ""
    objectRegistry := ""

    __New(layersInformation, objectRegistry){
        this.layersInformation := layersInformation
        this.objectRegistry := objectRegistry
    }
    
    InitializeHotkeys(keyboardLayerName, enableHotkeys := true){

        currentKeyboardLayerInformation := this.layersInformation.GetRegistryByLayerIdentifier(keyboardLayerName)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()

        For hotkeyKey, hotkeyInformation in currentKeyboardLayerHotkeys{
            if (hotkeyInformation.hotkeyIsObject()){
                this.InitializeDefaultKeyToFunction(hotkeyKey, hotkeyInformation, enableHotkeys)
            }
            else{
                this.InitializeDefaultKeyToNewKey(hotkeyKey, hotkeyInformation, enableHotkeys)
            }
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    InitializeDefaultKeyToFunction(hotkeyKey, hotkeyInformation, enableHotkeys := true){
        
        objectName := hotkeyInformation.getObjectName()
        methodName := hotkeyInformation.getMethodName()
        arguments := hotkeyInformation.getParameters()
 
        objectInstance := this.objectRegistry.GetObjectInfo(objectName).GetObjectInstance()
        objectMethodCall := ObjBindMethod(objectInstance, methodName, arguments*)
        ; msgbox("creating hotkey")
        if (enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => (objectMethodCall)(), "On")
        }
        else if (!enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => (objectMethodCall)(), "Off")
        }
        else{
            msgbox("error in InitializeDefaultKeyToFunction, enableHotkeys is not true or false in InitializeDefaultKeyToFunction")
        }
    }

    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    InitializeDefaultKeyToNewKey(hotkeyKey, hotkeyInformation, enableHotkeys := true){
        newHotKey := hotkeyInformation.getNewHotkeyName()
        newHotKeyModifiers := hotkeyInformation.getNewHotkeyModifiers()
        
        newKeysDown := this.CreateExcecutableKeysDown(newHotKey)
        newKeysUp := this.CreateExcecutableKeysUp(newHotKey)

        if (enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "On") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "On")
        }
        else if (!enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers), "Off") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers), "Off")
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