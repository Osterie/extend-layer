#Requires AutoHotkey v2.0

#Include <Util\StartupConfiguration\ObjectsInitializer>
#Include <Util\StartupConfiguration\MainStartupConfigurator>

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