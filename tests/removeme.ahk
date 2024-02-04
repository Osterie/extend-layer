#Requires AutoHotkey v2.0

#SingleInstance Force ; skips the dialog box and replaces the old instance automatically
A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 100
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super)
SendMode "Event"

class HotKeyInfo{

    hotkeyName := ""
    friendlyHotkeyName := ""
    isObject := ""
    objectName := ""
    methodName := ""
    parameters := []
    
    newHotKey := ""
    newHotKeyFriendlyName := ""
    modifiers := ""

    __New(hotkeyName){
        this.hotkeyName := hotkeyName
        this.friendlyHotkeyName := this.convertToFriendlyHotkeyName(hotkeyName)
    }

    setInfoForNormalHotKey(newHotKey, modifiers){
        this.isObject := false
        this.newHotKey := newHotKey
        this.modifiers := modifiers
        this.newHotKeyFriendlyName := this.convertToFriendlyHotkeyName(this.modifiers . this.newHotKey)
    }
    
    hotkeyIsObject(){
        return this.isObject
    }

    setInfoForSpecialHotKey(objectName, MethodName, parameters){
        this.isObject := true
        this.objectName := objectName
        this.methodName := methodName
        this.parameters := parameters
    }

    ; TODO make it's own class
    convertToFriendlyHotkeyName(hotkeyNameWithModifiers){

        tmpString := hotkeyNameWithModifiers

        friendlyName := ""

        possibleModifiers := Map()
        possibleModifiers["^"] := "Ctrl + "
        possibleModifiers["#"] := "Win + "
        possibleModifiers["!"] := "Alt + "
        possibleModifiers["+"] := "Shift + "
        possibleModifiers["<"] := "Left "
        possibleModifiers[">"] := "Right "
        possibleModifiers["&"] := "And "
        possibleModifiers["*"] := "Any + "

        possibleModifiers.Default := ""


        index := 0
        stringLength := StrLen(tmpString)
        Loop Parse tmpString{
            index++
            if ( (possibleModifiers[A_LoopField] == "") or index == stringLength) {
                friendlyName .= A_LoopField
            }
            else{
                friendlyName .= possibleModifiers[A_LoopField]
            }
        }
        return friendlyName
    }

    toString(){
        if(this.isObject){
            return this.objectName . "." . this.methodName . "(" . this.parametersToString(this.parameters) . ")"
        }
        else{
            return this.newHotKeyFriendlyName
        }
    }

    parametersToString(parameters){
        if (this.parameters.length == 0){
            return ""
        }

        stringToReturn := ""

        for argument in this.parameters{
            if (Type(argument) == "Array"){
                For subArgument in argument{
                    stringToReturn .= subArgument . ","
                }
            }
            else{
                stringToReturn .= argument . ","
            }
        }
        return stringToReturn
    }

    getHotkeyName(){
        return this.hotkeyName
    }

    getFriendlyHotkeyName(){
        return this.friendlyHotkeyName
    }

}

; test :=HotKeyInfo("!^Ctrl")

msgbox(test.getFriendlyHotkeyName())

; test1 := Test()