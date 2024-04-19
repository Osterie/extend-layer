#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoReading\KeyNamesReader>
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


class HotkeyCrafterController{
 
    activeObjectsRegistry := ""
    actionCrafterView := ""

    isCraftingSpecialAction_ := ""

    currentAction := ""

    __New(activeObjectsRegistry){
        this.isCraftingSpecialAction_ := true
        this.activeObjectsRegistry := activeObjectsRegistry
        this.currentAction := ""
    }

    AddActionCrafterView(actionCrafterView){
        this.actionCrafterView := actionCrafterView
    }   

    GetAvailableKeyNames(){
        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(FilePaths.GetPathToKeyNames(), "rw" , "UTF-8")
        availableKeyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()
        return availableKeyNames
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

    GetHotkey(parameters){
        hotkeyToReturn := HotKeyInfo("")
        hotkeyToReturn.setInfoForSpecialHotKey(this.GetCurrentObjectName(), this.GetCurrentMethodName(), parameters)
        return hotkeyToReturn
    }
}