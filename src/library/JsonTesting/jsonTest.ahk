#Requires AutoHotkey v2.0

#Include "..\..\src\library\JsonParsing\JXON\JXON.ahk"

#Include "..\..\src\library\MetaInfoStorage\ObjectInfo.ahk"
#Include "..\..\src\library\MetaInfoStorage\MethodInfo.ahk"
#Include "..\..\src\library\MetaInfoStorage\MethodRegistry.ahk"

; TODO add a friendly name... to json values


jsonStringFunctionalityInformation := FileRead("Json.json")

json := jxon_load(&jsonStringFunctionalityInformation)
; msgbox(json["Mouse"]["ObjectName"])

; Used to control mouse actions, and disable/enable mouse
MouseInstance := Mouse()
; Sets the click speed of the auto clicker
mouseCps := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Mouse", "AutoClickerClickCps")
MouseInstance.SetAutoClickerClickCps(mouseCps)
; Adds the mouse object to the registry
; ----Mouse methods----

; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
For ClassName , ClassInformation in json{

    ObjectName := ClassInformation["ObjectName"]
    className := ClassInformation["ClassName"]
    
    allMethodsOfClass := ClassInformation["Methods"]

    objectMethods = MethodRegistry()

    For MethodName, MethodInformation in allMethodsOfClass{
        
        methodDescription := MethodInformation["Description"]
        allMethodParameters := MethodInformation["Parameters"]
        
        MethodINfo := MethodInfo(methodName, methodDescription)

        For ParameterName, ParameterInformation in allMethodParameters{
            
            parameterType := ParameterInformation["Type"]
            parameterDescription := ParameterInformation["Description"]
            
            MethodINfo.addParameter(ParameterName, parameterDescription, parameterType)

        }

        objectMethods.addMethod(MethodName, MethodINfo)
    }


    ExitApp

    ; Create the finished object
    ObjectInstance = StoredObjects.getInstance(ObjectName)
    ObjectInfo := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

    ; Add the completed object to the registry.
    ObjectRegister.AddObject(ObjectName, ObjectInfo)

}

