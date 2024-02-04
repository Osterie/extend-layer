#Requires AutoHotkey v2.0

#Include "..\JsonParsing\JXON\JXON.ahk"

; #Include "..\..\src\library\MetaInfoStorage\ObjectInfo.ahk"
; #Include "..\..\src\library\MetaInfoStorage\MethodInfo.ahk"
; #Include "..\..\src\library\MetaInfoStorage\MethodRegistry.ahk"

; TODO add a friendly name... to json values


jsonStringFunctionalityInformation := FileRead("Json.json")

json := jxon_load(&jsonStringFunctionalityInformation)

json2 := Map()
json2["object"] := Map()
json2["object"]["name"] := "Mouse"
json2["object"]["methods"] := Map()
json2["object"]["methods"]["Click"] := Map()
json2["object"]["methods"]["Click"]["description"] := "Clicks the mouse"
json2["object"]["methods"]["Click"]["parameters"] := Map()
json2["object"]["methods"]["Click"]["parameters"]["x"] := Map()
json2["object"]["methods"]["Click"]["parameters"]["x"]["type"] := "int"
json2["object"]["methods"]["Click"]["parameters"]["x"]["description"] := "The x position to click"
json2["object"]["methods"]["Click"]["parameters"]["y"] := Map()
json2["object"]["methods"]["Click"]["parameters"]["y"]["type"] := "int"
json2["object"]["methods"]["Click"]["parameters"]["y"]["description"] := "The y position to click"
json2["object"]["methods"]["Move"] := Map()
json2["object"]["methods"]["Move"]["description"] := "Moves the mouse"
json2["object"]["methods"]["Move"]["parameters"] := Map()
json2["object"]["methods"]["Move"]["parameters"]["x"] := Map()
json2["object"]["methods"]["Move"]["parameters"]["x"]["type"] := "int"
json2["object"]["methods"]["Move"]["parameters"]["x"]["description"] := "The x position to move to"
json2["object"]["methods"]["Move"]["parameters"]["y"] := Map()
json2["object"]["methods"]["Move"]["parameters"]["y"]["type"] := "int"
json2["object"]["methods"]["Move"]["parameters"]["y"]["description"] := "The y position to move to"
json2["object"]["methods"]["GetPos"] := Map()

; json2 := {"object": {"name": "Mouse", "methods": {"Click": {"description": "Clicks the mouse", "parameters": {"x": {"type": "int", "description": "The x position to click"}, "y": {"type": "int", "description": "The y position to click"}}}, "Move": {"description": "Moves the mouse", "parameters": {"x": {"type": "int", "description": "The x position to move to"}, "y": {"type": "int", "description": "The y position to move to"}}}, "GetPos": {"description": "Gets the current mouse position", "parameters": {}}}}}
; msgbox(json["Mouse"]["ObjectName"])
; msgbox(Jxon_Dump(json2))

; FileRead("Json2.json").Write("hei")

FileObj := FileOpen("Json2.json", "rw" , "UTF-8")

; FileObj.Seek(10, 0)
CurrentSize := FileObj.Length
Loop currentSize{
    currentValue := FileObj.ReadLine()
    if ( currentValue = "5"){
        msgbox("yaay")
        ; FileObj.WriteLine("This had a 5 in itt...")
        FileObj.WriteLine("ThisisareallyLongText")

    }
}
; msgbox(FileObj.ReadLine())
; msgbox(FileObj.ReadLine())
; msgbox(FileObj.ReadLine())
; msgbox(FileObj.ReadLine())
; msgbox(FileObj.ReadLine())
; FileObj.WriteLine("hei")
; FileObj.WriteLine("hade")
; FileObj("Json2.json").Write(Jxon_Dump(json2))
Loop Read "Json.json"{
    ; msgbox(A_LoopReadLine)
}

; msgbox(json["Mouse"]["ObjectName"])

; Used to control mouse actions, and disable/enable mouse
; MouseInstance := Mouse()
; ; Sets the click speed of the auto clicker
; mouseCps := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Mouse", "AutoClickerClickCps")
; MouseInstance.SetAutoClickerClickCps(mouseCps)
; ; Adds the mouse object to the registry
; ; ----Mouse methods----

; ; TODO! add try catch to all of these. If one of these informations are missing something wrong will happen!
; For ClassName , ClassInformation in json{

;     ObjectName := ClassInformation["ObjectName"]
;     className := ClassInformation["ClassName"]
    
;     allMethodsOfClass := ClassInformation["Methods"]

;     objectMethods = MethodRegistry()

;     For MethodName, MethodInformation in allMethodsOfClass{
        
;         methodDescription := MethodInformation["Description"]
;         allMethodParameters := MethodInformation["Parameters"]
        
;         MethodINfo := MethodInfo(methodName, methodDescription)

;         For ParameterName, ParameterInformation in allMethodParameters{
            
;             parameterType := ParameterInformation["Type"]
;             parameterDescription := ParameterInformation["Description"]
            
;             MethodINfo.addParameter(ParameterName, parameterDescription, parameterType)

;         }

;         objectMethods.addMethod(MethodName, MethodINfo)
;     }


;     ExitApp

;     ; Create the finished object
;     ObjectInstance = StoredObjects.getInstance(ObjectName)
;     ObjectInfo := ObjectInfo(ObjectName, ObjectInstance, objectMethods)

;     ; Add the completed object to the registry.
;     ObjectRegister.AddObject(ObjectName, ObjectInfo)

; }

