#Requires AutoHotkey v2.0

#Include <Startup\ObjectsInitializer>
#Include <Startup\MainStartupConfigurator>
#Include <Infrastructure\Repositories\ActionGroupsRepository>

class ObjectRegistryInitializer {

    ObjectRegister := ""
    Objects := ""

    InitializeObjectRegistry(){
        this.initializeObjects()
        this.ReadObjectsInformationFromJson()
    }
    
    initializeObjects(){
        initializerForObjects := ObjectsInitializer()
        initializerForObjects.initializeObjects()
        this.Objects := initializerForObjects.GetObjects()
    }

    ReadObjectsInformationFromJson(){
        actionGroupsRepo := ActionGroupsRepository()
        this.ObjectRegister := actionGroupsRepo.getActionGroupRegistry()
    }

    GetObjectRegistry(){
        return this.ObjectRegister
    }
}