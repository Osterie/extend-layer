#Requires AutoHotkey v2.0

#Include "IniFileReader.ahk"

Class HotkeyInitializer{

    iniFile := ""
    ObjectRegistry := ""
    IniReader := ""


    __New(iniFile, objectRegistry){
        this.iniFile := iniFile
        this.ObjectRegistry := objectRegistry
        this.IniReader := IniFileReader()

    }

    
    InitializeAllDefaultKeysToFunctions(section){
        
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)
        iniFileSectionArray := StrSplit(iniFileSection, "`n")

        ; A_LoopField is the current item in the loop.
        Loop iniFileSectionArray.Length{
            ; This is the function that is in the ini file, for example EmergencyClose is a function.
            iniFileKey := StrSplit(iniFileSectionArray[A_Index], "=")[1]
            this.InitializeDefaultKeyToFunction(section, iniFileKey)
        }
    }

    InitializeDefaultKeyToFunction(section, key){
        readLine := this.IniReader.readLine(this.iniFile, section, key)
        
        ; TODO add method for key validation
        key := StrReplace(key, "win+", "#")

        ; Reads the Class name, which is the text before the first period
        UsedClass := SubStr(readLine, 1, InStr(readLine, ".")-1)
        ; Removes the class name from the expression
        readLine := SubStr(readLine, InStr(readLine, ".")+1)

        UsedMethod := SubStr(readLine, 1, InStr(readLine, "(")-1)
        ; Removes the method name from the expression, and also the first and last character, which are "(" and ")"
        ; This leaves only the arguments remainig, which is split into an array, splitting by "," since comma seperates arguments
        readLine := SubStr(readLine, InStr(readLine, "(")+1, -1)

        arguments := StrSplit(readLine, ",")

        validatedArguments := this.ValidateArguments(arguments)


        methodClass := this.ObjectRegistry.GetObject(UsedClass)

        secondColumn := ObjBindMethod(methodClass, UsedMethod, validatedArguments*)
        HotKey key, (ThisHotkey) => (secondColumn)()

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
                firstElement := SubStr(argument, 1,)
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

    ; |-----------DEFAULT KEYS TO FUNCTIONS SECTIONS END-----------|

    ; |-----------DEFAULT KEYS TO NEW KEYS SECTIONS-----------|

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
        KeyboardKey := KeyboardKeyAndModifers[1]
        KeyboardModifiers := KeyboardKeyAndModifers[2]
        this.ChangeKeyToNewKey(iniFileDefaultKey, KeyboardKey, KeyboardModifiers)
    }

    ChangeKeyToNewKey(normalKey, newKey, newKeyModifiers){
        HotKey(normalKey, (ThisHotkey) => this.SendKeyDown(newKey, newKeyModifiers)) 
        HotKey(normalKey . " Up", (ThisHotkey) => this.SendKeyUp(newKey, newKeyModifiers))
    }

    SendKeyDown(key, modifiers){
        Send("{blind}" . modifiers . "{" . key . " Down}")
    }
    
    SendKeyUp(key, modifiers){
        Send("{blind}{" . key . " Up}")                                                           
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