#Requires AutoHotkey v2.0

class HotkeyCrafterController{
 
    availableKeyNames := ""
    activeObjectsRegistry := ""
    actionCrafterView := ""

    isCraftingSpecialAction_ := ""

    currentAction := ""

    __New(availableKeyNames, activeObjectsRegistry){
        this.isCraftingSpecialAction_ := true
        this.availableKeyNames := availableKeyNames
        this.activeObjectsRegistry := activeObjectsRegistry
        this.currentAction := ""
    }

    AddActionCrafterView(actionCrafterView){
        this.actionCrafterView := actionCrafterView
    }   

    GetAvailableKeyNames(){
        return this.availableKeyNames
    }

    GetActiveObjectsRegistry(){
        return this.activeObjectsRegistry
    }

    GetSpecialActions(){
        return this.getActiveObjectsRegistry().GetFriendlyNames()
    }

    GetCurrentObjectName(){
        ObjectInfoOfAction := this.GetObjectInfoByActionName(this.currentAction)
        return ObjectInfoOfAction.getObjectName()
    }

    GetCurrentMethodName(){
        MethodInfoOfAction := this.GetMethodInfoByActionName(this.currentAction)
        return MethodInfoOfAction.getMethodName()
    }

    SetActionInformation(actionName){
        this.currentAction := actionName
    }

    GetMethodDescription(){
        MethodInfoOfAction := this.GetMethodInfoByActionName(this.currentAction)
        return MethodInfoOfAction.getMethodDescription()
    }

    GetMethodParameters(){
        MethodInfoOfAction := this.GetMethodInfoByActionName(this.currentAction)
        return MethodInfoOfAction.getMethodParameters()
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

    ; GetNewAction(){
    ;             ; TODO check if the values to return are correct perhaps...
    ;             if (this.controller.IsCraftingSpecialAction()){
    ;                 return this.getNewSpecialActionHotkey()
    ;             }
    ;             else if (!this.controller.IsCraftingSpecialAction()){
    ;                 return this.getNewHotkey()
    ;             }
    ; }

    ; getNewSpecialActionHotkey(){
    ;     hotkeyToReturn := HotKeyInfo("")
    ;     parameters := this.parameterControls.GetParameterValues()
    ;     hotkeyToReturn.setInfoForSpecialHotKey(this.controller.GetCurrentObjectName(), this.controller.GetCurrentMethodName(), parameters)
    ;     return hotkeyToReturn
    ; }

    ; getNewHotkey(){

    ;     hotkeyToReturn := HotKeyInfo()

    ;     if (this.advancedModeCheckBox.Value = true){
    ;         hotkeyKey := this.advancedHotkeyCrafter.getKey()
    ;         hotkeyModifiers := this.advancedHotkeyCrafter.getModifiers()
    ;         hotkeyToReturn.setInfoForNormalHotKey(hotkeyKey, hotkeyModifiers)
    ;     }
    ;     else {
    ;         hotkeyToReturn.setInfoForNormalHotKey(this.SimpleHotkeyCrafter.getKey())
    ;     }
    ;     return hotkeyToReturn
    ; }

    IsCraftingSpecialAction(){
        return this.isCraftingSpecialAction_
    }
    
    ; Private
    GetObjectInfoByActionName(actionName){
        return this.getActiveObjectsRegistry().GetObjectByFriendlyMethodName(actionName)
    }

    ; Private
    GetMethodInfoByActionName(actionName){
        ObjectInfo := this.getObjectInfoByActionName(actionName)
        return ObjectInfo.getMethodByFriendlyMethodName(actionName)
    }

    
}