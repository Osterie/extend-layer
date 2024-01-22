#Requires AutoHotkey v2.0

class MethodInfo{
    ; A method has a name, and a description.


    ; A method also (somethimes) has paramaters.
    ; These parameters should have a description as well.

    methodName := ""
    methodDescription := ""
    methodParameters := Map()

    ; Since a method does not alw
    __New(name, description){
        this.name := name
        this.description := description
    }

    addParameter(name, description){
        this.parameters[name] := description
    }

}