#Requires AutoHotkey v2.0

; The purpose of the method registry is to keep track of multiple methods and their descriptions.
; A use for this class is for example to keep track of all the methods in a class and their descriptions.

class MethodRegistry{
    ; A class has unique method names. Therefore a HashMap should be used.

    ; This field will store method names and their descriptions.
    Methods := Map()

    __New(){
        ; Nothing to do here.
        this.Methods.Default := 1
    }

    ; Takes the parameter MethodInfo, which is of the datatype MethodInfo.
    AddMethod(methodName, methodInfo){
        this.Methods[methodName] := methodInfo
    }

    getMethod(methodName){
        return this.Methods[methodName]
    }

    getMethods(){
        return this.Methods
    }

    getMethodsFriendlyNames(){
        friendlyNames := Array()
        For methodName, methodInfo in this.Methods{
            friendlyName := methodInfo.getFriendlyName()
            friendlyNames.Push(friendlyName)
        }
        return friendlyNames
    }
}