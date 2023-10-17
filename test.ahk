#Requires AutoHotkey v2.0

#Include ".\library\CountdownGUI.ahk"
#Include ".\library\MonitorController.ahk"
#Include ".\library\LayerIndicatorController.ahk"
#Include ".\library\BatteryController.ahk"
#Include ".\library\PrivacyGUIController.ahk"
#Include ".\library\ComputerInputController.ahk"
#Include ".\library\KeysPressedGui.ahk"
#Include ".\library\WebNavigator.ahk"
#Include ".\library\KeyboardOverlay.ahk"
#Include ".\library\DeviceController.ahk"
#Include ".\library\CommandPromptOpener.ahk"
#Include ".\library\FileExplorerNavigator.ahk"
#Include ".\library\Configurator.ahk"
#Include ".\library\KeyboardOverlayRegistry.ahk"
#Include ".\library\ApplicationManipulator.ahk"
#Include ".\library\Mouse.ahk"


A_MaxHotkeysPerInterval := 99000000
A_HotkeyInterval := 99000000
KeyHistory 0
ListLines(False)
SetKeyDelay(-1, -1)
SetMouseDelay(-1)
SetDefaultMouseSpeed(0)
SetWinDelay(-1)
SetControlDelay(-1)
SetWorkingDir(A_ScriptDir)
ProcessSetPriority "High"
; Not changing SendMode defaults it to "input", which makes hotkeys super mega terrible (super   ø)
SendMode "Event"

Class Tester{
    name := "Tester"
    age := 20

    printName(){
        MsgBox(this.name)
    }
    setName(name){
        this.name := name
    }
    getName(){
        return this.name
    }
    CloseTabsToTheRight(){
        MsgBox("CloseTabsToTheRight")
    }
}


SendKeyDown(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . " Down}")
}

SendKeyUp(key, modifiers){
    Send("{blind}{" . key . " Up}")                                                           
}

SendModifierKey(key, modifiers){
    Send("{blind}" . modifiers . "{" . key . "}")
}

; I found two ways to make a hotkey which excecutes a class method:

; CloseTabsToTheRight := ObjBindMethod(WebSearcher, "CloseTabsToTheRight")
; CloseTabsToTheRightHotkey := IniRead("Config.ini", "Hotkeys", "CloseTabsToTheRight") ; Default key is ^!W
; Hotkey(CloseTabsToTheRightHotkey, CloseTabsToTheRight)
WebSearcher := WebNavigator()

; +1 = WebSearcher.OpenUrl("https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&") 
; +2 =WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/course" , blackboardLoginImages, 3000) 
; +3 =WebSearcher.LoginToSite("https://ntnu.blackboard.com/ultra/courses/_39969_1/cl/outline" , blackboardLoginImages, 3000) 

readLine := (IniRead("Config.ini", "FirstLayer-Functions", "+2"))
; Reads the Class name, which is the text before the first period
UsedClass := SubStr(readLine, 1, InStr(readLine, ".")-1)
; Removes the class name from the expression
readLine := SubStr(readLine, InStr(readLine, ".")+1)

UsedMethod := SubStr(readLine, 1, InStr(readLine, "(")-1)
; Removes the method name from the expression, and also the first and last character, which are "(" and ")"
; This leaves only the arguments remainig, which is split into an array, splitting by "," since comma seperates arguments
readLine := SubStr(readLine, InStr(readLine, "(")+1, -1)

Arguments := StrSplit(readLine, ",")
; msgbox(UsedClass . " " . UsedMethod . " " . Arguments) 
validatedArguments := []
temporaryArray := []
inArray := false

for argument in Arguments{
    
    argument := StrReplace(argument, A_Space, "")

    if (SubStr(argument, 1, 1) == "["){
        inArray := true
        temporaryArray.Push(SubStr(argument, 1,))
    }
    else if(SubStr(argument, -1) == "]"){
        inArray := false
        temporaryArray.Push(SubStr(argument, 1, -1))
        validatedArguments.Push(temporaryArray)
    }
    else if(inArray){
        temporaryArray.Push(argument)
    }
    else{
        validatedArguments.Push(argument)
    }
}

StringToArray(text){

}


; way1 := WebSearcher.OpenUrl.Bind(WebSearcher, "https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&")
; firstColumn := ObjBindMethod(WebSearcher, "OpenUrl", "https://tp.educloud.no/ntnu/timeplan/?id[]=38726&type=student&weekTo=52&ar=2023&")
; secondColumn := ObjBindMethod(WebSearcher, "LoginToSite", "https://ntnu.blackboard.com/ultra/course", ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"], "3000")
secondColumn := ObjBindMethod(WebSearcher, UsedMethod, validatedArguments*)
; for element in validatedArguments{
;     secondColumn.Bind(element)
;     ; msgbox(element)
; }

HotKey "+2", (ThisHotkey) => (secondColumn)()

; HotKey "+1", (ThisHotkey) => (firstColumn)()

; TODO REQUIREMENTS:
; - true and false have to be evalueted from the ini file. "true" and "false" must be turned into true and false (booleans)
; - Arrays with elements must be treated as such, if there is a "[" and a "]" after, then the contents are to be treated as elements in an array, and placed in an array.
; - Perhaps it should be possible to create varriables in the ini file? 
;      - they could be created by having "_" at the start and end. 
;      - this would make it possible to for example create an array of values, such as paths to image search images.
;      - Would look like this _BlackBoardLoginImages_ = ["\imageSearchImages\feideBlackboardMaximized.png", "\imageSearchImages\feideBlackboardMinimized.png"]
;      - this would then be read by maybe IniReader and treated as an array and stored in the configurater object somewhere... in an array. IniFileSavedVariables := [_BlackBoardLoginImages_, ...]

; True else strings should be evalueated (is that the right word) and be turned into booleans, from string, obviously.

; +8 =WebSearcher.OpenUrl("https://capquiz.math.ntnu.no/my/")

; ; opens the file explorer in the given location
; ^1 = FileExplorer.NavigateToFolder("C:\") 
; ^2 = FileExplorer.NavigateToFolder("C:\Users\adria")
; ^3 = FileExplorer.NavigateToFolder("C:\Users\adria\github")
; ^4 = FileExplorer.NavigateToFolder("C:\Users\adria\Downloads")
; ^5 = FileExplorer.NavigateToFolder("C:\Users\adria\github\University")
; ^6 = FileExplorer.NavigateToFolder("C:\Users\adria\github\University\Programmering 1\Mappe Vurdering\mappe-idata1003-traindispatchsystem-Osterie")




; statement := iniRead("Config.ini", "test", "test")
; if (statement){
;     msgbox(statement)
; }





*esc::ExitApp