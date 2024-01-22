#Requires AutoHotkey v2.0

class ObjectInfo{

    objectName := ""
    objectInstance := ""
    methodsWithDescriptions := ""

    ; Try to add, if already exists, send a msgbox informing of such...
    ; ObjectName is a string. Which is the name of the object.
    ; ObjectInstance is an instance of the class. AKA the object itself to add.
    ; MethodsWithDescriptions is an instance of a MethodsDescriptions class, which is basically a hashmap of the methods and their descriptions for the given object.
    __New(objectName, objectInstance, methodsWithDescriptions){
        this.objectName := objectName
        this.methodsWithDescriptions := methodsWithDescriptions
    }
    ; {objectName, methodsWithDescriptions}
    ; Hashmap (objectName, methodsWithDescriptions)
    ; ObjectName
    ; Object methods (MethodsDescription instance)
}