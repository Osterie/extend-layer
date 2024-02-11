#Requires AutoHotkey v2.0

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

    getParameterName(){
        return this.name
    }

    getParameterType(){
        return this.parameterType
    }

    getParameterDescription(){
        return this.description
    }
}