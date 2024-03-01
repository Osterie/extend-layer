#Requires AutoHotkey v2.0

class MethodInfo{
    ; A method has a name, and a description.


    ; A method also (somethimes) has paramaters.
    ; These methodParameters should have a description as well.

    methodName := ""
    methodDescription := ""
    methodParameters := Map()
    friendlyName := ""

    ; Since a method does not alw
    __New(name, description, friendlyName){
        this.methodName := name
        this.methodDescription := description
        this.friendlyName := friendlyName
    }

    addParameter(parameterInfo){
        this.methodParameters[parameterInfo.getName()] := parameterInfo
    }

    getMethodName(){
        return this.methodName
    }

    getMethodDescription(){
        return this.methodDescription
    }

    getMethodParameters(){
        return this.methodParameters
    }

    getMethodParameterDescription(parameterName){
        return this.methodParameters[parameterName]
    }
    getFriendlyName(){
        return this.friendlyName
    }
}