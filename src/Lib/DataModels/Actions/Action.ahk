#Requires AutoHotkey v2.0

class Action {
    ; An action has a name, and a description.

    ; An action also (somethimes) has paramaters.

    name := ""
    description := ""
    friendlyName := ""
    actionParameters := Array()

    __New(name, description, friendlyName) {
        this.name := name
        this.description := description
        this.friendlyName := friendlyName
    }

    addParameter(parameterInfo) {
        if (Type(parameterInfo) != "ActionParameter") {
            throw TypeError("Expected parameterInfo to be of type ActionParameter, got " . Type(parameterInfo))
        }
        this.actionParameters.Push(parameterInfo)
    }

    getActionName() {
        return this.name
    }

    getActionDescription() {
        return this.description
    }

    getActionParameters() {
        return this.actionParameters
    }

    getActionParameter(parameterName) {
        for index, parameter in this.actionParameters {
            if (parameter.getName() = parameterName) {
                return parameter
            }
        }
        throw Error("Parameter '" . parameterName . "' not found in action '" . this.name . "'.")
    }
    
    getFriendlyName() {
        return this.friendlyName
    }
}
