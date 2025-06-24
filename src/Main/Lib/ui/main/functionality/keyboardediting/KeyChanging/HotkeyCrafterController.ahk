#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\ActionGroupsRepository>
#Include <Infrastructure\Repositories\KeyNamesRepository>

#Include <DataModels\KeyboardLayouts\KeyboardsInfo\HotkeyLayer\HotKeyInfo>

class HotkeyCrafterController{

    ActionGroupsRepository := ActionGroupsRepository.getInstance()

    actionCrafterView := ""

    isCraftingSpecialAction_ := ""

    currentAction := ""

    __New(){
        this.isCraftingSpecialAction_ := true
        this.currentAction := ""
    }

    AddActionCrafter(actionCrafterView){
        this.actionCrafterView := actionCrafterView
    }   

    GetAvailableKeyNames(){
        KeyNamesRepo := KeyNamesRepository()
        return KeyNamesRepo.getKeyNames()
    }

    GetSpecialActions(){
        return this.ActionGroupsRepository.getAllFriendlyActionNames()
    }

    GetCurrentObjectName(){
        ObjectInfoOfAction := this.GetActionGroupsInfoByActionName(this.currentAction)
        return ObjectInfoOfAction.getObjectName()
    }

    GetCurrentMethodName(){
        MethodInfoOfAction := this.getActionByFriendlyActionName(this.currentAction)
        return MethodInfoOfAction.getActionName()
    }

    SetActionInformation(actionName){
        this.currentAction := actionName
    }

    GetMethodDescription(){
        MethodInfoOfAction := this.getActionByFriendlyActionName(this.currentAction)
        return MethodInfoOfAction.getActionDescription()
    }

    GetMethodParameters(){
        MethodInfoOfAction := this.getActionByFriendlyActionName(this.currentAction)
        return MethodInfoOfAction.getActionParameters()
    }

    ; Change the view. Hides and shows controls such that the
    ; user can craft a new special action
    doSpecialActionCrafting(){
        this.isCraftingSpecialAction_ := true
        this.actionCrafterView.SetSpecialActionAsActive()
    }

    ; Change the view. Hides and shows controls such that the 
    ; user can craft a new key
    doNewKeyActionCrafting(){
        this.isCraftingSpecialAction_ := false
        this.actionCrafterView.SetNewKeyAsActive()
    }

    ; Change the view
    ; This runs when a action is selected.
    ; It hides existing parameters
    ; and then creates controls showing information about the action
    ; and the parameters that can be set.
    HandleActionSelected(actionName){
        this.SetActionInformation(actionName)
        this.actionCrafterView.hideParameters()
        this.actionCrafterView.setTextForSpecialActionMaker(actionName, this.GetMethodDescription(), this.GetMethodParameters())
    }

    IsCraftingSpecialAction(){
        return this.isCraftingSpecialAction_
    }
    
    ; TODO change some of these methods! another class should handle this.
    ; Private
    GetActionGroupsInfoByActionName(actionName){
        return this.ActionGroupsRepository.getActionGroupByFriendlyActionName(actionName)
    }

    ; Private
    getActionByFriendlyActionName(friendlyActionName){
        ActionGroup := this.GetActionGroupsInfoByActionName(friendlyActionName)
        return ActionGroup.getActionByFriendlyActionName(friendlyActionName)
    }

    GetHotkey(parameters){
        hotkeyToReturn := HotKeyInfo("")
        hotkeyToReturn.setInfoForSpecialHotKey(this.GetCurrentObjectName(), this.GetCurrentMethodName(), parameters)
        return hotkeyToReturn
    }
}