#Requires AutoHotkey v2.0

#Include "..\..\JsonParsing\JXON\JXON.ahk"

#Include "..\MetaInfoStorage\Objects\ObjectInfo.ahk"
#Include "..\MetaInfoStorage\Objects\MethodInfo.ahk"
#Include "..\MetaInfoStorage\Objects\MethodRegistry.ahk"
#Include "..\MetaInfoStorage\Objects\ParameterInfo.ahk"

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>



class ObjectsJsonReader{

    PATH_TO_OBJECT_INFO := FilePaths.GetObjectInfo()
    ObjectRegister := ""
    ObjectInstanceRegistry := ""

    __New(ObjectInstanceRegistry){
        this.ObjectRegister := ObjectRegistry()
        this.ObjectInstanceRegistry := ObjectInstanceRegistry
    }

    ReadObjectsFromJson(){
        try{
            jsonStringFunctionalityInformation := FileRead(this.PATH_TO_OBJECT_INFO, "UTF-8")
        }
        catch{
            throw ValueError("Could not read the file: " . this.PATH_TO_OBJECT_INFO)
        }
        allClassesInformationJson := jxon_load(&jsonStringFunctionalityInformation)

        ; -----------Read JSON----------------

        ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
        For classIndex , ClassInformation in allClassesInformationJson{

            ObjectName := ClassInformation["ObjectName"]
            className := ClassInformation["ClassName"]
            classDescription := ClassInformation["Description"]

            objectMethods := MethodRegistry()
            allMethodsOfClass := ClassInformation["Methods"]

            For index, MethodInformation in allMethodsOfClass {
                
                methodDescription := MethodInformation["Description"]
                methodName := MethodInformation["MethodName"]
                methodFriendlyName := MethodInformation["FriendlyName"]
                allMethodParameters := MethodInformation["Parameters"]
                methodInformation := MethodInfo(methodName, methodDescription, methodFriendlyName)
                
                For Name, ParameterInformation in allMethodParameters{
                    
                    parameterName := ParameterInformation["Name"]
                    parameterType := ParameterInformation["Type"]
                    parameterDescription := ParameterInformation["Description"]

                    parameterInformation := ParameterInfo(parameterName, parameterType, parameterDescription)

                    methodInformation.addParameter(parameterInformation)
                }
                objectMethods.AddMethod(MethodName, methodInformation)
            }

            ; Create the finished object
            ObjectInstance := this.ObjectInstanceRegistry[ObjectName]
            objectInformation := ObjectInfo(ObjectName, ObjectInstance, classDescription, objectMethods)

            ; Add the completed object to the registry.
            this.ObjectRegister.AddObject(ObjectName, objectInformation)
        }
        return this.ObjectRegister
    }
}