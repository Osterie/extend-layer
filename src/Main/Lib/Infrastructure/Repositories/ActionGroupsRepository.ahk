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
    ActionGroupRegistry := ""

    ; The action groups have to be registered with the object instances, so that they can be used later on for actions.
    ; Since action group is actually the name of a ahk class, for example "Mouse" or "Keyboard",
    ; we need to use an object instance of one of these classes to actually perform the actions, which are actually methods of these classes.
    ObjectInstanceRegistry := ""

    __New(ObjectInstanceRegistry) {
        this.ActionGroupRegistry := ActionGroupRegistry()
        this.ObjectInstanceRegistry := ObjectInstanceRegistry
    }

    ReadObjectsFromJson() {
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

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        for actionGroupIndex, actionGroupInfo in actionGroups {

            actionGroupObjectName := actionGroupInfo["ObjectName"]
            actionGroupClassName := actionGroupInfo["ClassName"]
            actionGroupDescription := actionGroupInfo["Description"]

            ActionRegistry_ := ActionRegistry()
            actionsInfo := actionGroupInfo["Methods"]

            for actionIndex, actionInfo in actionsInfo {

                actionName := actionInfo["MethodName"]
                actionFriendlyName := actionInfo["FriendlyName"]
                actionDescription := actionInfo["Description"]
                actionParametersInfo := actionInfo["Parameters"]
                
                Action_ := Action(actionName, actionDescription, actionFriendlyName)

                for parameterIndex, actionParameterInfo in actionParametersInfo {

                    parameterName := actionParameterInfo["Name"]
                    parameterType := actionParameterInfo["Type"]
                    parameterDescription := actionParameterInfo["Description"]

                    ActionParameter_ := ActionParameter(parameterName, parameterType, parameterDescription)

                    Action_.addParameter(ActionParameter_)
                }
                ActionRegistry_.addAction(actionName, Action_)
            }

            ; Create the finished object
            ObjectInstance := this.ObjectInstanceRegistry[actionGroupObjectName]
            objectInfo := ActionGroup(actionGroupObjectName, ObjectInstance, actionGroupDescription, ActionRegistry_)

            ; Add the completed object to the registry.
            this.ActionGroupRegistry.addActionGroup(actionGroupObjectName, objectInfo)
        }
        return this.ActionGroupRegistry
    }
}
