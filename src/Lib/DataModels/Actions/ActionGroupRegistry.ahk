#Requires AutoHotkey v2.0

class ActionGroupRegistry {

    ActionGroups := Map()

    __New() {
        ; if ActionGroup is not found in map, 0 is returned
        this.ActionGroups.Default := 0
    }

    addActionGroup(actionGroup) {
        if (Type(actionGroup) != "ActionGroup") {
            throw TypeError(
                "ActionGroupRegistry: addActionGroup: actionGroup must be an object instance of ActionGroup class.")
        }
        if (this.ActionGroups.Has(actionGroup.getObjectName())) {
            throw Error("ActionGroupRegistry: addActionGroup: Action group with name '" . actionGroup.getObjectName() . "' already exists.")
        }
        this.ActionGroups[actionGroup.getObjectName()] := actionGroup
    }

    getActionGroup(actionGroupName) {
        return this.ActionGroups[actionGroupName]
    }

    getActionGroups() {
        return this.ActionGroups
    }

    getAllFriendlyActionNames() {
        allFriendlyActionNames := Array()
        for actionGroupName, actionGroup in this.ActionGroups {
            friendlyActionNames := actionGroup.getFriendlyNamesOfActions()

            loop friendlyActionNames.Length {
                allFriendlyActionNames.Push(friendlyActionNames[A_index])
            }
        }

        return allFriendlyActionNames
    }

    getActionGroupByFriendlyActionName(friendlyActionName) {
        for actionGroupName, actionGroup in this.ActionGroups {
            friendlyActionNames := actionGroup.getFriendlyNamesOfActions()

            loop friendlyActionNames.Length {
                if (friendlyActionNames[A_index] = friendlyActionName) {
                    return actionGroup
                }
            }
        }
    }

    destroyObjectInstances() {
        for actionGroupName, ActionGroup in this.ActionGroups {
            ActionGroup.destroyObjectInstance()
        }
    }
}
