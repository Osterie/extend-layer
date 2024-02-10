#Requires AutoHotkey v2.0

#Include "..\..\JsonParsing\JXON\JXON.ahk"

#Include "..\MetaInfoStorage\Objects\ObjectInfo.ahk"
#Include "..\MetaInfoStorage\Objects\MethodInfo.ahk"
#Include "..\MetaInfoStorage\Objects\MethodRegistry.ahk"


class ObjectsJsonReader{

    PATH_TO_OBJECT_INFO := ""
    ObjectRegister := ""
    ObjectInstanceRegistry := ""
    allClassesInformationJson := ""

    __New(jsonFilePath, ObjectInstanceRegistry){
        this.PATH_TO_OBJECT_INFO := jsonFilePath
        this.ObjectRegister := ObjectRegistry()
        this.ObjectInstanceRegistry := ObjectInstanceRegistry
    }

    ReadObjectsFromJson(){
        try{
            jsonStringFunctionalityInformation := FileRead(this.PATH_TO_OBJECT_INFO, "UTF-8")
        }
        catch{
            throw ("Could not read the file: " . this.PATH_TO_OBJECT_INFO)
        }
        this.allClassesInformationJson := jxon_load(&jsonStringFunctionalityInformation)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For ClassName , ClassInformation in this.allClassesInformationJson{
            
            ObjectName := ClassInformation["ObjectName"]
            className := ClassInformation["ClassName"]

            objectMethods := MethodRegistry()
            allMethodsOfClass := ClassInformation["Methods"]

            For MethodName, MethodInformation in allMethodsOfClass{
                
                methodDescription := MethodInformation["Description"]
                allMethodParameters := MethodInformation["Parameters"]
                methodFriendlyName := MethodInformation["FriendlyName"]
                methodInformation := MethodInfo(methodName, methodDescription, methodFriendlyName)
                
                For ParameterName, ParameterInformation in allMethodParameters{
                    
                    parameterType := ParameterInformation["Type"]
                    parameterDescription := ParameterInformation["Description"]
                    methodInformation.addParameter(ParameterName, parameterDescription)
                }
                objectMethods.addMethod(MethodName, methodInformation)
            }

            ; Create the finished object
            ObjectInstance := this.ObjectInstanceRegistry[ObjectName]
            objectInformation := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

            ; Add the completed object to the registry.
            this.ObjectRegister.AddObject(ObjectName, objectInformation)
        }
    }

    getObjectRegister(){
        return this.ObjectRegister
    }
}