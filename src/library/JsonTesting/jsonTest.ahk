#Requires AutoHotkey v2.0

#Include "..\JsonParsing\JXON\JXON.ahk"

; #Include "..\..\src\library\MetaInfoStorage\ObjectInfo.ahk"
; #Include "..\..\src\library\MetaInfoStorage\MethodInfo.ahk"
; #Include "..\..\src\library\MetaInfoStorage\MethodRegistry.ahk"

; TODO add a friendly name... to json values


jsonStringFunctionalityInformation := FileRead("Json.json")

json := jxon_load(&jsonStringFunctionalityInformation)

jsonToWrite := Jxon_Dump(json)

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
toWrite := (Jxon_Dump(json))
indentationLevel := 0
textToReturn := ""
previousValue := ""

Loop Parse toWrite{
    if(A_LoopField = "{"){
        indentationLevel++
        textToReturn .= "{`n"
        Loop indentationLevel{
            textToReturn .= "`t"
        }
    }
    else if (A_LoopField = "}"){
        indentationLevel--
        textToReturn .= "`n"
        Loop indentationLevel{
            textToReturn .= "`t"
        }
        textToReturn .= "}"

    }
    else if (A_LoopField = "," and (previousValue = "`"" or previousValue = "}")){
        textToReturn .= ",`n"
        Loop indentationLevel{
            textToReturn .= "`t"
        }
    }
    else{
        textToReturn .= A_LoopField
    }
    previousValue := A_LoopField
}
; toWrite := StrReplace(toWrite, "{", "{`n`t")
; toWrite := StrReplace(toWrite, "}", "`n}")
; toWrite := StrReplace(toWrite, ",", ",`n`t")
; toWrite := StrReplace(toWrite, ":", ": ")



FileObj := FileOpen("Json2.json", "rw" , "UTF-8")

FileObj.WriteLine(textToReturn)
