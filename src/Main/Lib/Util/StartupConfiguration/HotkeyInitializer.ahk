#Requires AutoHotkey v2.0

#Include <Util\HotkeyFormatConverter>

Class HotkeyInitializer{

    objectRegistry := ""

    __New(){
    }
    
    InitializeHotkeys(layersInformation, objectRegistry, keyboardLayerName, enableHotkeys := true){
        this.objectRegistry := objectRegistry

        currentKeyboardLayerInformation := layersInformation.GetRegistryByLayerIdentifier(keyboardLayerName)
        currentKeyboardLayerHotkeys := currentKeyboardLayerInformation.GetHotkeys()

        For key, hotkeyInformation in currentKeyboardLayerHotkeys{
            this.InitializeHotkey(hotkeyInformation, enableHotkeys)
        }
    }

    InitializeHotkey(hotkeyInformation, enableHotkeys := true){
        if (hotkeyInformation.hotkeyIsObject()){
            this.InitializeDefaultKeyToFunction(hotkeyInformation, enableHotkeys)
        }
        else{
            this.InitializeDefaultKeyToNewKey(hotkeyInformation, enableHotkeys)
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    InitializeDefaultKeyToFunction(hotkeyInformation, enableHotkeys := true){
        
        hotkeyKey := hotkeyInformation.getHotkeyName()
        objectName := hotkeyInformation.getObjectName()
        methodName := hotkeyInformation.getMethodName()
        arguments := hotkeyInformation.getParameters()
 
        objectMethodCall := this.CreateObjectMethodCall(objectName, methodName, arguments)
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
            msgbox("error in InitializeDefaultKeyToFunction, enableHotkeys is not true or false in InitializeDefaultKeyToFunction")
        }
    }

    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    InitializeDefaultKeyToNewKey(hotkeyInformation, enableHotkeys := true){
        
        hotkeyKey := hotkeyInformation.getHotkeyName()
        newHotKey := hotkeyInformation.getNewHotkeyName()
        newHotKeyModifiers := hotkeyInformation.getNewHotkeyModifiers()
        
        this.runHotkeyForKey(hotkeyKey, newHotKey, newHotKeyModifiers, enableHotkeys)
    }

    runHotkeyForKey(hotkeyKey, newHotKey, newHotKeyModifiers, enableHotkeys := true){
        if (enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.SendKeysDown(newHotKey, newHotKeyModifiers), "On") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.SendKeysUp(newHotKey, newHotKeyModifiers), "On")
        }
        else if (!enableHotkeys){
            HotKey(hotkeyKey, (ThisHotkey) => this.SendKeysUp(newHotKey, newHotKeyModifiers), "Off") 
            HotKey(hotkeyKey . " Up", (ThisHotkey) => this.SendKeysDown(newHotKey, newHotKeyModifiers), "Off")
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
    ;         HotKey(hotkeyKey, (ThisHotkey) => this.SendKeysUp(newHotKey, newHotKeyModifiers), "Off") 
    ;         HotKey(hotkeyKey . " Up", (ThisHotkey) => this.SendKeysDown(newHotKey, newHotKeyModifiers), "Off")
    ;     }
    ; }

    ; Sends key(s) down, including possible modifiers
    SendKeysDown(keysDown, modifiers){
        keysDown := HotkeyFormatConverter.convertToKeyDownExcecutable(keysDown)
        Send("{blind}" . modifiers . keysDown)
    }
    
    ; Sends key(s) up, including possible modifiers
    SendKeysUp(keysUp, modifiers){
        keysUp := HotkeyFormatConverter.convertToKeyUpExcecutable(keysUp)
        Send("{blind}" . modifiers . keysUp)
    }

    CreateObjectMethodCall(objectName, methodName, arguments){
        objectInstance := this.objectRegistry.GetObjectInfo(objectName).GetObjectInstance()
        objectMethodCall := ObjBindMethod(objectInstance, methodName, arguments*)
        return objectMethodCall
    }
}