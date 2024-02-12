#Requires AutoHotkey v2.0

class KeyNamesRegistry{

    keyNames := ""

    __New(){
        this.keyNames := Array()
        this.keyNames.Default := ""
    }

    AddKeyName(KeyName){
        KeyName := StrReplace(KeyName, "`r", "")
        this.keyNames.Push(KeyName)
    }

    GetKeyNames(){
        return this.keyNames
    }
}