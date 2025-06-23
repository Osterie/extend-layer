#Requires AutoHotkey v2.0

; Rename to ActionParameter
class ParameterInfo{
    ; A parameter has a name, a parameterType and a description.

    name := ""
    parameterType := ""
    description := ""


    ; Since a parameter does not alw
    __New(name, parameterType, description){
        this.name := name
        this.parameterType := parameterType
        this.description := description
    }

    getName(){
        return this.name
    }

    getType(){
        return this.parameterType
    }

    getDescription(){
        return this.description
    }
}