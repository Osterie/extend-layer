#Requires AutoHotkey v2.0

class ActionGroupRegistry {

    ActionGroups := Map()

    __New() {
        ; if ActionGroup is not found in map, 0 is returned
        this.ActionGroups.Default := 0
    }

    addActionGroup(actionGroupName, actionGroup) {
        this.ActionGroups[actionGroupName] := actionGroup
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
        for actionGroupName, objectInfo in this.ActionGroups {
            objectInfo.destroyObjectInstance()
        }
    }

}
