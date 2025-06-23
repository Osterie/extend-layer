#Requires AutoHotkey v2.0


class ActionGroup {

    ; Name of the object (String)
    actionGroupObjectName := ""
    ; The instance of the object (the datatype is the one of the given object)
    objectInstance := ""
    ; The methods of the object, which should be of the datatype ActionRegistry.
    actionRegistry := ""
    description := ""

    ; TODO check type of given parameters.
    ; TODO Try to add, if already exists, send a msgbox informing of such...
    __New(actionGroupObjectName, objectInstance, description, actionRegistry) {
        if (Type(actionGroupObjectName) != "String") {
            throw TypeError("actionGroupObjectName must be a String, got: " . Type(actionGroupObjectName))
        }
        if (!IsObject(objectInstance)) {
            throw TypeError("objectInstance must be an object, got: " . Type(objectInstance))
        }
        if (Type(actionRegistry) != "ActionRegistry") {
            throw TypeError("actionRegistry must be of type ActionRegistry, got: " . Type(actionRegistry))
        }
        this.actionGroupObjectName := actionGroupObjectName
        this.objectInstance := objectInstance
        this.actionRegistry := actionRegistry
        this.description := description
    }

    getObjectName() {
        return this.actionGroupObjectName
    }

    getObjectInstance() {
        return this.objectInstance
    }

    getDescription() {
        return this.description
    }

    getFriendlyNamesOfActions() {
        return this.actionRegistry.getActionsFriendlyNames()
    }

    getActionByFriendlyActionName(friendlyActionName) {
        return this.actionRegistry.getActionByFriendlyName(friendlyActionName)
    }

    getActions() {
        return this.actionRegistry
    }

    destroyObjectInstance() {
        this.objectInstance.destroy()
    }
}
