#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON>

#Include <DataModels\Actions\ActionGroupRegistry>
#Include <DataModels\Actions\ActionGroup>
#Include <DataModels\Actions\ActionRegistry>
#Include <DataModels\Actions\Action>
#Include <DataModels\Actions\ActionParameter>

#Include <Shared\FilePaths>

class ActionGroupsRepository {

    PATH_TO_ACTION_GROUP_INFO := FilePaths.GetPathToActionGroupsInfo()
    ActionGroupRegistry := ActionGroupRegistry()

    ; The action groups have to be registered with the object instances, so that they can be used later on for actions.
    ; Since action group is actually the name of a ahk class, for example "Mouse" or "Keyboard",
    ; we need to use an object instance of one of these classes to actually perform the actions, which are actually methods of these classes.
    objectInstances := Map()

    __New(objectInstances) {
        this.objectInstances := objectInstances
        this.readObjectsFromJson()  ; Load the action groups from the JSON file
    }

    getActionGroupRegistry() {
        return this.ActionGroupRegistry
    }

    

    readObjectsFromJson() {
        actionGroups := this.loadActionGroupsFromFile()

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        for actionGroupIndex, actionGroupInfo in actionGroups {
            ActionGroup_ := this.createActionGroupFromInfo(actionGroupInfo)

            ; Add the completed object to the registry.
            this.ActionGroupRegistry.addActionGroup(ActionGroup_)
        }
    }

    createActionGroupFromInfo(actionGroupInfo) {
        ; actionGroupClassName := actionGroupInfo["ClassName"]

        actionGroupObjectName := actionGroupInfo["ObjectName"]
        actionGroupDescription := actionGroupInfo["Description"]

        ActionRegistry_ := ActionRegistry()
        actionsInfo := actionGroupInfo["Methods"]

        for actionIndex, actionInfo in actionsInfo {
            Action_ := this.createActionFromInfo(actionInfo)
            ActionRegistry_.addAction(Action_)
        }

        return ActionGroup(actionGroupObjectName, this.objectInstances[actionGroupObjectName], actionGroupDescription, ActionRegistry_)
    }

    createActionFromInfo(actionInfo) {
        actionName := actionInfo["MethodName"]
        actionFriendlyName := actionInfo["FriendlyName"]
        actionDescription := actionInfo["Description"]

        Action_ := Action(actionName, actionDescription, actionFriendlyName)
        actionParametersInfo := actionInfo["Parameters"]

        for parameterIndex, actionParameterInfo in actionParametersInfo {
            ActionParameter_ := this.createActionParameterFromInfo(actionParameterInfo)
            Action_.addParameter(ActionParameter_)
        }

        return Action_
    }

    createActionParameterFromInfo(actionParameterInfo) {
        parameterName := actionParameterInfo["Name"]
        parameterType := actionParameterInfo["Type"]
        parameterDescription := actionParameterInfo["Description"]

        return ActionParameter(parameterName, parameterType, parameterDescription)
    }

    loadActionGroupsFromFile() {
        if (!FileExist(this.PATH_TO_ACTION_GROUP_INFO)) {
            throw ValueError("The file does not exist: " . this.PATH_TO_ACTION_GROUP_INFO)
        }
        try {
            jsonString := FileRead(this.PATH_TO_ACTION_GROUP_INFO, "UTF-8")
        }
        catch {
            throw ValueError("Could not read the file: " . this.PATH_TO_ACTION_GROUP_INFO)
        }
        actionGroups := jxon_load(&jsonString)
        return actionGroups
    }
}
