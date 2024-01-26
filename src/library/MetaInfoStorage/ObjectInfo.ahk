#Requires AutoHotkey v2.0

class ObjectInfo{

    ; Name of the object (String)
    objectName := ""
    ; The instance of the object (the datatype is the one of the given object)
    objectInstance := ""
    ; The methods of the object, which should be of the datatype MethodRegistry.
    methodsWithDescriptions := ""

    ; Try to add, if already exists, send a msgbox informing of such...
    __New(objectName, objectInstance, methodsWithDescriptions){
        this.objectName := objectName
        this.objectInstance := objectInstance
        this.methodsWithDescriptions := methodsWithDescriptions
    }

    getObjectName(){
        return this.objectName
    }

    getObjectInstance(){
        return this.objectInstance
    }

    getMethodsWithDescriptions(){
        return this.methodsWithDescriptions
    }
}