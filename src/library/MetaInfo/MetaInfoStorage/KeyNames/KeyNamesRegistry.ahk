#Requires AutoHotkey v2.0

class KeyNamesRegistry{

    keyNames 

    __New(){
        this.keyNames := Map()
        this.keyNames.Default := ""
    }

    AddKeyName(KeyName){
        this.keyNames[KeyName] := KeyName
    }

    GetKeyName(KeyName){
        return this.keyNames[KeyName]
    }
    
    GetKeyNames(){
        return this.keyNames
    }

    GetKeyNamesAsArray(){
        return this.keyNames.Keys()
    }
}