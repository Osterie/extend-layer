#Requires AutoHotkey v2.0

#Include "..\..\JsonParsing\JXON\JXON.ahk"

#Include "..\MetaInfoStorage\MetaInfoStorage\Objects\ObjectInfo.ahk"
#Include "..\MetaInfoStorage\MetaInfoStorage\Objects\MethodInfo.ahk"
#Include "..\MetaInfoStorage\MetaInfoStorage\Objects\MethodRegistry.ahk"


class ObjectsJsonReader{

    PATH_TO_OBJECT_INFO := ""
    ObjectRegister := ObjectRegister()
    ObjectInstanceRegistry := ObjectInstanceRegistry()
    allClassesInformationJson := ""

    __New(jsonFilePath, ObjectInstanceRegistry){
        this.PATH_TO_OBJECT_INFO := jsonFilePath
        this.ObjectRegister := ObjectRegister()
        this.ObjectInstanceRegistry := ObjectInstanceRegistry
    }

    ReadJsonFile(){
        try{
            jsonStringFunctionalityInformation := FileRead(this.PATH_TO_OBJECT_INFO, "UTF-8")
        }
        catch{
            throw Exception("Could not read the file: " . this.PATH_TO_OBJECT_INFO)
            return
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
                methodInformation := MethodInfo(methodName, methodDescription)
                
                For ParameterName, ParameterInformation in allMethodParameters{
                    
                    parameterType := ParameterInformation["Type"]
                    parameterDescription := ParameterInformation["Description"]
                    methodInformation.addParameter(ParameterName, parameterDescription)
                }
                objectMethods.addMethod(MethodName, methodInformation)
            }

            ; Create the finished object
            ObjectInstance := this.Objects[ObjectName]
            objectInformation := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

            ; Add the completed object to the registry.
            this.ObjectRegister.AddObject(ObjectName, objectInformation)
        }
    }

    getObjectRegister(){
        return this.ObjectRegister
    }
}
; -----------Read JSON----------------

; TODO create a class for this and such....
; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
For ClassName , ClassInformation in this.allClassesInformationJson{
    
    ObjectName := ClassInformation["ObjectName"]
    className := ClassInformation["ClassName"]

    objectMethods := MethodRegistry()
    allMethodsOfClass := ClassInformation["Methods"]

    For MethodName, MethodInformation in allMethodsOfClass{
        
        methodDescription := MethodInformation["Description"]
        allMethodParameters := MethodInformation["Parameters"]
        methodInformation := MethodInfo(methodName, methodDescription)
        
        For ParameterName, ParameterInformation in allMethodParameters{
            
            parameterType := ParameterInformation["Type"]
            parameterDescription := ParameterInformation["Description"]
            methodInformation.addParameter(ParameterName, parameterDescription)
        }
        objectMethods.addMethod(MethodName, methodInformation)
    }

    ; Create the finished object
    ObjectInstance := this.Objects[ObjectName]
    objectInformation := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

    ; Add the completed object to the registry.
    this.ObjectRegister.AddObject(ObjectName, objectInformation)
}