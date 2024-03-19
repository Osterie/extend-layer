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

    GetObjectInfoByFriendlyName(friendlyObjectName){
        return this.getActiveObjectsRegistry().GetObjectByFriendlyMethodName(friendlyObjectName)
    }

    GetMethodInfoByFriendlyName(friendlyObjectName){
        ObjectInfoOfAction := this.getObjectInfoByFriendlyName(friendlyObjectName)
        return ObjectInfoOfAction.getMethodByFriendlyMethodName(friendlyNameOfAction)
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