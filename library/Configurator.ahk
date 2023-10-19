#Requires AutoHotkey v2.0
#Include "iniFileReader.ahk"
#Include "KeyboardOverlay.ahk"

; TODO the ini file reader class, which is currently empty i believe, should read ini files.
; "æ ø å" and such are replaced with other values, since the ini file cant be utf-8 with bom encoding, therefore the result should replace these wrong characters with "æøå" respectively.
; TODO this class is too complex... use more modularization!


Class Configurator{

    iniFile := ""
    ObjectRegistry := ""
    IniReader := ""

    __New(iniFile, ObjectRegistry){
        this.iniFile := iniFile
        this.ObjectRegistry := ObjectRegistry
        this.IniReader := IniFileReader()
    }

    ChangeIniFile(iniFile){
        this.iniFile := iniFile
    }

    ChangeObjectRegistry(ObjectRegistry){
        this.ObjectRegistry := ObjectRegistry
    }

    ; TODO add method to read which keys are used to show keyboard overlays, should be in the correct layer section, because only then should they activate
    ReadAllKeyboardOverlays(){

        SectionNames := IniRead("Config.ini")
        SectionNames := StrSplit(SectionNames, "`n")
        Loop SectionNames.Length{
            SectionName := SectionNames[A_Index]
            if (InStr(SectionName, "KeyboardOverlay")){

                ; OverlayRegistry := this.ObjectRegistry.GetObject("OverlayRegistry")

                NewKeyboardOverlay := KeyboardOverlay()
                NewKeyboardOverlay.CreateGui()
                this.ReadKeyboardOverlaySection(NewKeyboardOverlay, SectionName)

                ; OverlayRegistry.addKeyboardOverlay(NewKeyboardOverlay, SectionName)
                this.ObjectRegistry.GetObject("OverlayRegistry").addKeyboardOverlay(NewKeyboardOverlay, SectionName)
                ; TODO use the keyboardOVelray class to create a new keyboard overlay, which then columns are added to
                ; TODO, each layer should have the "KeyboardOverlayKey" in it, which is then created there and such blah blah blah
            
            }
        }

    }

    ReadKeyboardOverlaySection(KeyboardOverlay, section){
        
        ; modifierKey := this.IniReader.ReadLine(this.iniFile, section, "ShowOverlayKey")
        
        
        iniFileSection := this.IniReader.ReadSection(this.iniFile, section)

        ; Reads where the columns start, and deletes everything before that.
        startOfColumns := InStr(iniFileSection,"Column1")
        iniFileSection := SubStr(iniFileSection,startOfColumns)

        KeyboardOverlayColumns := StrSplit(iniFileSection, "`n")
        
        ; A_LoopField is the current item in the loop.
        Loop KeyboardOverlayColumns.Length{
            ColumnValues := this.GetKeyValue(KeyboardOverlayColumns[A_Index])
            KeyboardOverlayColumnHelperKey := StrSplit(ColumnValues, ",")[1]
            KeyboardOverlayColumnHelperKey := this.GetStringWithoutQuotes(KeyboardOverlayColumnHelperKey)
            KeyboardOverlayColumnFriendlyName := StrSplit(ColumnValues, ",")[2]
            KeyboardOverlayColumnFriendlyName := this.GetStringWithoutQuotes(KeyboardOverlayColumnFriendlyName)
            this.SetKeyboardOverlayColumn(KeyboardOverlay, KeyboardOverlayColumnHelperKey, KeyboardOverlayColumnFriendlyName )
        }
    }

    SetKeyboardOverlayColumn(KeyboardOverlay, ColumnHelperKey, ColumnFriendlyName){
        KeyboardOverlay.AddStaticColumn(ColumnHelperKey, ColumnFriendlyName)
    }

    CreateHotkeyForKeyboardOverlay(sectionName, showKeyboardOverlayKey){
        ; instanceOfOverlay := this.ObjectRegistry.GetObject("OverlayRegistry").GetKeyboardOverlay(sectionName)
        instanceOfRegistry := this.ObjectRegistry.GetObject("OverlayRegistry")
        HotKey(showKeyboardOverlayKey, (ThisHotkey) => instanceOfRegistry.ShowKeyboardOverlay(sectionName))
        ; TODO, this " up" should be added for all layers...
        HotKey(showKeyboardOverlayKey . " Up", (ThisHotkey) => instanceOfRegistry.hideAllLayers())
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

    GetKeyValue(key){
        return StrSplit(key, "=")[2]
    }

    GetStringWithoutQuotes(text){
        textWithoutQutoes := StrReplace(text, "`"", "")
        textWithoutQutoes := StrReplace(textWithoutQutoes, "'", "")
        return textWithoutQutoes
    }
}