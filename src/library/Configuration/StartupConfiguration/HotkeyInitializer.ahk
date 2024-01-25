#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"

Class HotkeyInitializer{

    jsonFile := ""
    ObjectRegistry := ""
    IniReader := ""

    __New(jsonFile, objectRegistry){
        this.jsonFile := jsonFile
        this.ObjectRegistry := objectRegistry
        this.IniReader := IniFileReader()
    }
    
    InitializeHotkeys(keyboardLayerName){
        currentKeyboardLayerInformation := this.jsonFile[section]
        For OriginalKeybind, newKeyBindInformation in currentKeyboardLayerInformation{
            newKeyBind := newKeyBindInformation["key"]
            newKeyBindModifiers := newKeyBindInformation["modifiers"]

            if (newKeyBindInformation["isObject"] == true){
                this.InitializeDefaultKeyToFunction(OriginalKeybind, newKeyBindInformation)
            }
            else{
                oldHotKey, newHotKey, newHotKeyModifiers := ""
                this.InitializeDefaultKeyToNewKey(OriginalKeybind, newKeyBind, newKeyBindModifiers)
            }
        }


    }

    ; this method is used to change a every normal keyboard key in a section, into a key which triggers a method call.
    ; Could be for example a method call which changes screen brightness
    InitializeAllDefaultKeysToFunctions(section){

        hotkeysToFunctions := this.jsonFile[section]

        For hotKeyStated , functionInformation in hotkeysToFunctions{

            ; Turns the keyboard key into a hotkey, which triggers a method call.
            this.InitializeDefaultKeyToFunction(hotKeyStated, functionInformation)
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    InitializeDefaultKeyToFunction(keyboardKey, functionInformation){
        
        objectName := functionInformation["ObjectName"]

        methodName := functionInformation["MethodName"]

        arguments := functionInformation["Parameters"]

        objectInstance := this.ObjectRegistry.GetObjectInfo(objectName).GetObjectInstance()

        objectMethodCall := ObjBindMethod(objectInstance, methodName, arguments*)

        HotKey keyboardKey, (ThisHotkey) => (objectMethodCall)()
    }

    InitializeAllDefaultKeyToNewKeys(section){

        hotKeyToNewHotKey := this.jsonFile[section]


        For hotKeyStated , newHotKeyInformation in hotKeyToNewHotKey{

            newHotKey := newHotKeyInformation["key"]
            newHotKeyModifiers := newHotKeyInformation["modifiers"]

            ; Turns the keyboard key into a hotkey, which triggers a method call.
            this.InitializeDefaultKeyToNewKey(hotKeyStated, newHotKey, newHotKeyModifiers)
        }

    }

    ; !i am not sure if the below comments are true..
    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    InitializeDefaultKeyToNewKey(oldHotKey, newKeyInformation){
        newHotKey := newKeyInformation["key"]
        newHotKeyModifiers := newKeyInformation["modifiers"]
        newKeysDown := this.CreateExcecutableKeysDown(newHotKey)
        newKeysUp := this.CreateExcecutableKeysUp(newHotKey)

        HotKey(oldHotKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newHotKeyModifiers)) 

        HotKey(oldHotKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newHotKeyModifiers))
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

    ; Sends key(s) down, including possible modifiers
    SendKeysDown(keysDown, modifiers){
        Send("{blind}" . modifiers . keysDown)
    }
    
    ; Sends key(s) up, including possible modifiers
    SendKeysUp(keysUp, modifiers){
        Send("{blind}" . modifiers . keysUp)
    }

}