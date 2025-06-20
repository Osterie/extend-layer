#Requires AutoHotkey v2.0

class MethodInfo{
    ; A method has a name, and a description.


    ; A method also (somethimes) has paramaters.
    ; These methodParameters should have a description as well.

    methodName := ""
    methodDescription := ""
    methodParameters := Array()
    friendlyName := ""

    ; Since a method does not alw
    __New(name, description, friendlyName){
        this.methodName := name
        this.methodDescription := description
        this.friendlyName := friendlyName
    }

    addParameter(parameterInfo){
        this.methodParameters.Push(parameterInfo)
        ; this.methodParameters[parameterInfo.getName()] := parameterInfo
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

    getMethodParameterInfo(parameterName){
        for index, parameter in this.methodParameters {
            if (parameter.getName() = parameterName) {
                return parameter
            }
        }
        throw Error("Parameter '" . parameterName . "' not found in method '" . this.methodName . "'.")
    }
    getFriendlyName(){
        return this.friendlyName
    }
}