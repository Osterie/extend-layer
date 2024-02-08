#Requires AutoHotkey v2.0

#Include "..\MetaInfoStorage\KeyNames\KeyNamesRegistry.ahk"

class KeyNamesReader{


    ReadKeyNamesFromTxtFile(fileObj){
        if (Type(fileObj) = "File"){
            registryOfKeyNames := KeyNamesRegistry()

            keyNames := fileObj.Read()
            keyNamesSplitted := StrSplit(keyNames, "`n")
            Loop keyNamesSplitted.Length{
                keyName := keyNamesSplitted[A_index]
                if (keyName != ""){
                    
                    registryOfKeyNames.AddKeyName(keyName)
                }
            }
        }

        return registryOfKeyNames
    }
}