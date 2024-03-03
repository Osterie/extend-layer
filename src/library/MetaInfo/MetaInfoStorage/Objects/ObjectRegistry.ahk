#Requires AutoHotkey v2.0

Class ObjectRegistry{

    ObjectMap := Map()

    __New(){
        
        ; if object is not found in map, 0 is returned
        this.ObjectMap.Default := 0
    }

    AddObject(objectName, ObjectInfo){
        this.ObjectMap[objectName] := ObjectInfo
    }

    GetObjectInfo(objectName){
        return this.ObjectMap[objectName]
    }

    GetMap(){
        return this.ObjectMap
    }

}