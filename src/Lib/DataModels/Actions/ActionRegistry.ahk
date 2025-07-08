#Requires AutoHotkey v2.0

; The purpose of the action registry is to keep track of multiple actions and their descriptions.
; A use for this class is for example to keep track of all the actions in a action group and their descriptions.

class ActionRegistry {

    ; This field will store action names and their descriptions.
    Actions := Map()

    __New() {
        ; Nothing to do here.
        this.Actions.Default := 1
    }

    ; Takes the parameter MethodInfo, which is of the datatype MethodInfo.
    addAction(Action) {
        If (Type(Action) != "Action") {
            throw TypeError("ActionRegistry: addAction: Action must be an object instance of Action class.")
        }
        this.Actions[Action.getActionName()] := Action
    }

    getAction(actionName) {
        return this.Actions[actionName]
    }

    getActions() {
        return this.Actions
    }

    getActionsFriendlyNames() {
        friendlyNames := Array()
        for actionName, Action in this.Actions {
            friendlyName := Action.getFriendlyName()
            friendlyNames.Push(friendlyName)
        }
        return friendlyNames
    }

    getActionByFriendlyName(friendlyName) {
        for actionName, Action in this.Actions {
            if (Action.getFriendlyName() = friendlyName) {
                return Action
            }
        }
        return "Failed to retrieve friendly action name"
    }
}
