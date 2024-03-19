#Requires AutoHotkey v2.0

class HotkeyCrafterController{
 
    availableKeyNames := ""
    activeObjectsRegistry := ""
    currentObjectName := ""
    currentMethodName := ""

    __New(availableKeyNames, activeObjectsRegistry){
        this.availableKeyNames := availableKeyNames
        this.activeObjectsRegistry := activeObjectsRegistry
        this.currentObjectName := ""
        this.currentMethodName := ""
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

    GetObjectInfoByActionName(actionName){
        return this.getActiveObjectsRegistry().GetObjectByFriendlyMethodName(actionName)
    }

    GetMethodInfoByActionName(actionName){
        ObjectInfo := this.getObjectInfoByActionName(actionName)
        return ObjectInfo.getMethodByFriendlyMethodName(actionName)
    }

    GetCurrentObjectName(){
        return this.currentObjectName
    }

    GetCurrentMethodName(){
        return this.currentMethodName
    }

    SetCurrentObjectName(objectName){
        this.currentObjectName := objectName
    }

    SetCurrentMethodName(methodName){
        this.currentMethodName := methodName
    }
}