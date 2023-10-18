#Requires AutoHotkey v2.0

Class ObjectRegistry{

    this.ObjectMap = Map()

    AddObject(objectName, objectInstance){
        this.ObjectMap[objectName] := objectInstance
    }

    GetObject(objectName){
        return this.ObjectMap[objectName]
    }
}