#Requires AutoHotkey v2.0

#Include <Startup\ObjectsInitializer>
#Include <Startup\MainStartupConfigurator>
#Include <Infrastructure\Repositories\ActionGroupsRepository>

class ObjectRegistryInitializer {

    ObjectRegister := ""
    Objects := ""

    InitializeObjectRegistry(){
        this.InitializeObjects()
        this.ReadObjectsInformationFromJson()
    }
    
    InitializeObjects(){
        initializerForObjects := ObjectsInitializer()
        initializerForObjects.InitializeObjects()
        this.Objects := initializerForObjects.GetObjects()
    }

    ReadObjectsInformationFromJson(){
        JsonReaderForObjects := ActionGroupsRepository(this.Objects)
        this.ObjectRegister := JsonReaderForObjects.ReadObjectsFromJson()
    }

    GetObjectRegistry(){
        return this.ObjectRegister
    }
}