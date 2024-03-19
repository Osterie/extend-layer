#Requires AutoHotkey v2.0

class HotkeyCrafterController{
 
    availableKeyNames := ""
    activeObjectsRegistry := ""

    __New(availableKeyNames, activeObjectsRegistry){
        this.availableKeyNames := availableKeyNames
        this.activeObjectsRegistry := activeObjectsRegistry
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
}