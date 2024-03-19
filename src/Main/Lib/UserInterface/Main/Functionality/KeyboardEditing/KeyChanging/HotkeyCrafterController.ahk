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
        return this.getActiveObjectsRegistry().getFriendlyNames()
    }

    GetObjectInfoByFriendlyName(friendlyMethodName){
        return this.getActiveObjectsRegistry().GetObjectByFriendlyMethodName(friendlyMethodName)
    }

    GetMethodInfoByFriendlyName(friendlyMethodName){
        ObjectInfo := this.getObjectInfoByFriendlyName(friendlyMethodName)
        return ObjectInfo.getMethodByFriendlyMethodName(friendlyMethodName)
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