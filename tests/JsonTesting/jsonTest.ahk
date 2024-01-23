#Requires AutoHotkey v2.0

#Include "..\..\src\library\JsonParsing\JXON\JXON.ahk"

; text := "
; (
; {
;     "glossary": {
;         "title": "example glossary",
;         "GlossDiv": {
;             "title": "S",
;             "GlossList": {
;                 "GlossEntry": {
;                     "ID": "SGML",
;                     "SortAs": "SGML",
;                     "GlossTerm": "Standard Generalized Markup Language",
;                     "Acronym": "SGML",
;                     "Abbrev": "ISO 8879:1986",
;                     "GlossDef": {
;                         "para": "A meta-markup language, used to create markup languages such as DocBook.",
;                         "GlossSeeAlso": ["GML", "XML"]
;                     },
;                     "GlossSee": "markup"
;                 }
;             }
;         }
;     }
; }
; )"

; TODO add a friendly name... to json values


jsonStringFunctionalityInformation := FileRead("Json.json")

json := jxon_load(&jsonStringFunctionalityInformation)
; msgbox(json["Mouse"]["ObjectName"])
For ClassName , ClassInformation in json{

    ObjectName := ClassInformation["ObjectName"]
    className := ClassInformation["ClassName"]
    
    allMethodsOfClass := ClassInformation["Methods"]

    msgbox(ObjectName)
    msgbox(className)

    For MethodName, MethodInformation in allMethodsOfClass{
        
        methodDescription := MethodInformation["Description"]
        allMethodParameters := MethodInformation["Parameters"]
        
        msgbox(MethodName)
        msgbox(methodDescription)

        For ParameterName, ParameterInformation in allMethodParameters{
            
            parameterType := ParameterInformation["Type"]
            parameterDescription := ParameterInformation["Description"]
            
            MsgBox(parameterName)
            MsgBox(parameterType)
            MsgBox(parameterDescription)
        }
    }
    ExitApp
}