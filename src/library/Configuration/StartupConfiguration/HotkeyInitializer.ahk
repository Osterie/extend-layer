#Requires AutoHotkey v2.0

#Include "..\..\FoldersAndFiles\IniFileReader.ahk"

Class HotkeyInitializer{

    iniFile := ""
    ObjectRegistry := ""
    IniReader := ""

    __New(iniFile, objectRegistry){
        this.iniFile := iniFile
        this.ObjectRegistry := objectRegistry
        this.IniReader := IniFileReader()
    }
    
    ; this method is used to change a every normal keyboard key in a section, into a key which triggers a method call.
    ; Could be for example a method call which changes screen brightness
    InitializeAllDefaultKeysToFunctions(section){
        
        ; the contents of the entire section
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        ; the contents of the entire section, but split into an array, using "`n" as a delimiter, which is new line in ahk.
        iniFileSectionArray := StrSplit(iniFileSection, "`n")

        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; keyboardKey is the left side of the expression in the ini file.
            ; which is a keyboard key, for example "a, b, c, d" and so on.
            ; they can also be modified, for example "win+a, shift+b, control+c" and such
            
            keyboardKey := this.IniReader.GetKeyFromLine(iniFileSectionArray[A_Index])
            methodCall := this.IniReader.GetValueFromLine(iniFileSectionArray[A_Index])

            ; Turns the keyboard key into a hotkey, which triggers a method call.
            this.InitializeDefaultKeyToFunction(keyboardKey, methodCall)
        }
    }

    ; Used to change a single keyboard key into a key which triggers a class method call.
    InitializeDefaultKeyToFunction(keyboardKey, methodCall){
        
        ; todo create a class or method which is able to extract all these pieces of information
        
        ; Reads the Class name, which is the text before the first period
        UsedClass := SubStr(methodCall, 1, InStr(methodCall, ".")-1)
        ; Removes the class name from the expression
        methodCall := SubStr(methodCall, InStr(methodCall, ".")+1)

        UsedMethod := SubStr(methodCall, 1, InStr(methodCall, "(")-1)
        ; Removes the method name from the expression, and also the first and last character, which are "(" and ")"
        ; This leaves only the arguments remainig, which is split into an array, splitting by "," since comma seperates arguments
        methodCall := SubStr(methodCall, InStr(methodCall, "(")+1, -1)

        arguments := StrSplit(methodCall, ",")

        validatedArguments := this.ValidateArguments(arguments)

        ClassOfMethod := this.ObjectRegistry.GetObject(UsedClass)

        secondColumn := ObjBindMethod(ClassOfMethod, UsedMethod, validatedArguments*)

        HotKey keyboardKey, (ThisHotkey) => (secondColumn)()

    }

    ValidateArguments(arguments){
        validatedArguments := []
        temporaryArray := []
        inArray := false

        for argument in arguments{
            
            argument := StrReplace(argument, A_Space, "")

            ; Start of array
            if (SubStr(argument, 1, 1) == "["){
                inArray := true
                firstElement := SubStr(argument, 2)
                firstElement := this.GetStringWithoutQuotes(firstElement)
                temporaryArray.Push(firstElement)
            }
            ; End of array, push the created array to the validated arguments
            else if(SubStr(argument, -1) == "]"){
                inArray := false
                lastElement := SubStr(argument, 1, -1)
                lastElement := this.GetStringWithoutQuotes(lastElement)
                temporaryArray.Push(lastElement)
                validatedArguments.Push(temporaryArray)
            }
            else if(inArray){

                ; nthElement just means the n'th element in the array (so maybe 2nd 3rd... millionth...)
                nthElement := SubStr(argument, 1, -1)
                nthElement := this.GetStringWithoutQuotes(nthElement)
                temporaryArray.Push(nthElement)
            }
            else{
                validatedArgument := this.GetValidatedStringOrObject(argument)
                validatedArguments.Push(validatedArgument)
            }
        }
        return validatedArguments
    }

    GetValidatedStringOrObject(argument){
        validatedArgument := ""
        if(SubStr(argument, 1, 1) == "`"" && SubStr(argument, -1) == "`""){
            ; Argument is a string,
            validatedArgument := this.GetStringWithoutQuotes(argument)
        }
        else{
            ; Argument might be a string, but perhaps it is a class?
            if (this.ObjectRegistry.GetMap().Get(argument)){
                validatedArgument := this.ObjectRegistry.GetObject(argument)
            }
            else{
                validatedArgument := this.GetStringWithoutQuotes(argument)
            }
        }
        return validatedArgument
    }

    InitializeAllDefaultKeyToNewKeys(section){

        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        iniFileSectionArray := StrSplit(iniFileSection, "`n")

        ; This splits section, using "`n" as a delimiter, which is new line in ahk.
        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileDefaultKey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            iniFileNewKey := StrSplit(iniFileSectionArray[A_Index], "=")[2]
            this.InitializeDefaultKeyToNewKey(iniFileDefaultKey, iniFileNewKey)
        }
    }

    InitializeDefaultKeyToNewKey(iniFileDefaultKey, iniFileNewKey){
        KeyboardKeyAndModifers := this.IniReader.SeperateKeyboardKeyAndModifiers(iniFileNewKey)
        newKeyboardKeys := KeyboardKeyAndModifers[1]
        KeyboardModifiers := KeyboardKeyAndModifers[2]
        this.ChangeKeyToNewKeys(iniFileDefaultKey, newKeyboardKeys, KeyboardModifiers)
    }

    ; a double pipe symbol (||) can be used to separate when one key is going to be changed to multiple keys.
    ; for example original key "a" to "b||c" means that when "a" is pressed, "b" and "c" will be pressed as well.
    ChangeKeyToNewKeys(normalKey, newKeys, newKeyModifiers){
        newKeysDown := this.CreateExcecutableKeysDown(newKeys)
        newKeysUp := this.CreateExcecutableKeysUp(newKeys)

        HotKey(normalKey, (ThisHotkey) => this.SendKeysDown(newKeysDown, newKeyModifiers)) 
        HotKey(normalKey . " Up", (ThisHotkey) => this.SendKeysUp(newKeysUp, newKeyModifiers))
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

    ; |-----------DEFAULT KEYS TO NEW KEYS END-----------|


    ; |-----------GENERAL-----------|

    ; Only used one place!
    GetKeyValue(key){
        return StrSplit(key, "=")[2]
    }

    GetStringWithoutQuotes(text){
        textWithoutQutoes := StrReplace(text, "`"", "")
        textWithoutQutoes := StrReplace(textWithoutQutoes, "'", "")
        return textWithoutQutoes
    }
}