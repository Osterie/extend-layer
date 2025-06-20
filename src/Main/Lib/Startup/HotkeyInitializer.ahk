#Requires AutoHotkey v2.0

#Include <Util\Formaters\HotkeyFormatter>

Class HotkeyInitializer {

    objectRegistry := ""

    __New(){
    }
    
    initializeHotkeys(layersInformation, objectRegistry, keyboardLayerName, enableHotkeys := true){
        this.objectRegistry := objectRegistry

        currentKeyboardLayerInformation := layersInformation.GetRegistryByLayerIdentifier(keyboardLayerName)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()

        For key, hotkeyInformation in currentKeyboardLayerHotkeys{
            this.initializeHotkey(hotkeyInformation, enableHotkeys)
        }
    }

    initializeHotkey(hotkeyInformation, enableHotkeys := true){
        if (hotkeyInformation.hotkeyIsObject()){
            this.initializeDefaultKeyToFunction(hotkeyInformation, enableHotkeys)
        }
        else{
            this.initializeDefaultKeyToNewKey(hotkeyInformation, enableHotkeys)
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    initializeDefaultKeyToFunction(hotkeyInformation, enableHotkeys := true){
        
        hotkeyKey := hotkeyInformation.getHotkeyName()
        objectName := hotkeyInformation.getObjectName()
        methodName := hotkeyInformation.getMethodName()
        arguments := hotkeyInformation.getParameters()
 
        objectMethodCall := this.createObjectMethodCall(objectName, methodName, arguments)
        this.runHotkeyForFunction(hotkeyKey, objectMethodCall, enableHotkeys)
    }

    runHotkeyForFunction(hotkeyKey, objectMethodCall, enableHotkeys := true){
        if (enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => (objectMethodCall)(), "On")
        }
        else if (!enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => (objectMethodCall)(), "Off")
        }
        else{
            msgbox("error in initializeDefaultKeyToFunction, enableHotkeys is not true or false in initializeDefaultKeyToFunction")
        }
    }

    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    initializeDefaultKeyToNewKey(hotkeyInformation, enableHotkeys := true){
        
        hotkeyKey := hotkeyInformation.getHotkeyName()
        newHotKey := hotkeyInformation.getNewHotkeyName()
        newHotKeyModifiers := hotkeyInformation.getNewHotkeyModifiers()

        this.runHotkeyForKey(hotkeyKey, newHotKey, newHotKeyModifiers, enableHotkeys)
    }

    runHotkeyForKey(hotkeyKey, newHotKey, newHotKeyModifiers, enableHotkeys := true){
        if (enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.sendKeysDown(newHotKey, newHotKeyModifiers), "On") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.sendKeysUp(newHotKey, newHotKeyModifiers), "On")
        }
        else if (!enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.sendKeysUp(newHotKey, newHotKeyModifiers), "Off") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.sendKeysDown(newHotKey, newHotKeyModifiers), "Off")
        } 
        else {
            msgbox("error in runHotkeyForKey, state is not on or off")
        }
    }

    ; DisableHotkey(hotkeyInformation){
    ;     hotkeyKey := hotkeyInformation.getHotkeyName()
    ;     if (hotkeyInformation.hotkeyIsObject()){

    ;     }
    ;     else{
    ;         HotKey(hotkeyKey, (ThisHotkey) => this.sendKeysUp(newHotKey, newHotKeyModifiers), "Off") 
    ;         HotKey(hotkeyKey . " Up", (ThisHotkey) => this.sendKeysDown(newHotKey, newHotKeyModifiers), "Off")
    ;     }
    ; }

    ; Sends key(s) down, including possible modifiers
    sendKeysDown(keysDown, modifiers){
        keysDown := HotkeyFormatter.convertToKeyDownExcecutable(keysDown)
        Send("{blind}" . modifiers . keysDown)
    }
    
    ; Sends key(s) up, including possible modifiers
    sendKeysUp(keysUp, modifiers){
        keysUp := HotkeyFormatter.convertToKeyUpExcecutable(keysUp)
        Send("{blind}" . modifiers . keysUp)
    }

    createObjectMethodCall(objectName, methodName, arguments){
        objectInstance := this.objectRegistry.GetObjectInfo(objectName).GetObjectInstance()
        objectMethodCall := ObjBindMethod(objectInstance, methodName, arguments*)
        return objectMethodCall
    }
}