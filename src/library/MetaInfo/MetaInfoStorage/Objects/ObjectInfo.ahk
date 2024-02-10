#Requires AutoHotkey v2.0

class ObjectInfo{

    ; Name of the object (String)
    objectName := ""
    ; The instance of the object (the datatype is the one of the given object)
    objectInstance := ""
    ; The methods of the object, which should be of the datatype MethodRegistry.
    methodsWithDescriptions := ""
    objectDescription := ""

    ; Try to add, if already exists, send a msgbox informing of such...
    __New(objectName, objectInstance, objectDescription, methodsWithDescriptions){
        this.objectName := objectName
        this.objectInstance := objectInstance
        this.methodsWithDescriptions := methodsWithDescriptions
        this.objectDescription := objectDescription
    }

    getObjectName(){
        return this.objectName
    }

    getObjectInstance(){
        return this.objectInstance
    }

    getObjectDescription(){
        return this.objectDescription
    }

    getFriendlyNames(){
        return this.methodsWithDescriptions.getMethodsFriendlyNames()
    }

    getMethodsWithDescriptions(){
        return this.methodsWithDescriptions
    }
}