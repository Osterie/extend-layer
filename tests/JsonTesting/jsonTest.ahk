#Requires AutoHotkey v2.0

#Include "..\..\src\library\JsonParsing\JXON\JXON.ahk"

#Include "..\..\src\library\MetaInfoStorage\ObjectInfo.ahk"
#Include "..\..\src\library\MetaInfoStorage\MethodInfo.ahk"
#Include "..\..\src\library\MetaInfoStorage\MethodRegistry.ahk"

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

; Used to control mouse actions, and disable/enable mouse
MouseInstance := Mouse()
; Sets the click speed of the auto clicker
mouseCps := IniRead("../config/UserProfiles/" . currentProfile . "/ClassObjects.ini", "Mouse", "AutoClickerClickCps")
MouseInstance.SetAutoClickerClickCps(mouseCps)
; Adds the mouse object to the registry
; ----Mouse methods----


MouseMethodMoveMouseToCenter := MethodInfo("MoveMouseToCenterOfScreen", "Moves the mouse to the center of the screen")
MouseMethodToggleAutoClick := MethodInfo("ToggleAutoClicker", "Toggles an auto clicker on/off, the click speed can be set in the function settings")
MouseMethodStartAutoClick := MethodInfo("StartAutoClicker", "Starts an auto clicker, the click speed can be set in the function settings")
MouseMethodStopAutoClick := MethodInfo("StopAutoClicker", "Stops an auto clicker, the click speed can be set in the function settings")

MouseMethodSendClick := MethodInfo("SendClick", "Sends a mouse click.")

MouseMethodMoveMouse := MethodInfo("MoveMouseTo", "Moves a mouse to a specified location")
MouseMethodMoveMouse.addParameter("x", "The x coordinate to move to")
MouseMethodMoveMouse.addParameter("y", "The y coordinate to move to")



MouseMethods := MethodRegistry()

MouseMethods.addMethod(MouseMethodMoveMouseToCenter.getMethodName(), MouseMethodMoveMouseToCenter)
MouseMethods.addMethod(MouseMethodToggleAutoClick.getMethodName(), MouseMethodToggleAutoClick)
MouseMethods.addMethod(MouseMethodStartAutoClick.getMethodName() , MouseMethodStartAutoClick)
MouseMethods.addMethod(MouseMethodStopAutoClick.getMethodName(), MouseMethodStopAutoClick)
MouseMethods.addMethod(MouseMethodSendClick.getMethodName(), MouseMethodSendClick)
MouseMethods.addMethod(MouseMethodMoveMouse.getMethodName(), MouseMethodMoveMouse)

MouseObjectInfo := ObjectInfo("MouseInstance", MouseInstance, MouseMethods)

ObjectRegister.AddObject(MouseObjectInfo.getObjectName(), MouseObjectInfo)


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