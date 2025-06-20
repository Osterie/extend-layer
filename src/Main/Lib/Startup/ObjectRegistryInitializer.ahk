#Requires AutoHotkey v2.0

#Include <Startup\ObjectsInitializer>
#Include <Startup\MainStartupConfigurator>

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
        JsonReaderForObjects := ObjectsJsonReader(this.Objects)
        this.ObjectRegister := JsonReaderForObjects.ReadObjectsFromJson()
    }

    GetObjectRegistry(){
        return this.ObjectRegister
    }
}