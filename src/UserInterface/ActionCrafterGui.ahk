#Requires AutoHotkey v2.0
#Include ".\guiControlsRegistry.ahk"

; #Include "..\library\MetaInfo\MetaInfoReading\KeyNamesReader.ahk"
#Include <MetaInfo\MetaInfoReading\KeyNamesReader>
#Include ".\HotkeyCrafterGui.ahk"

; #Include "..\library\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo.ahk"
#Include <MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include ".\ParameterControlsGroup.ahk"

class ActionCrafterGui{

    GuiObject := ""
    hotkeyStaticInput := ""
    hotkeyDynamicInput := ""

    controlsForAdvancedHotkeys := ""
    controlsForSimpleHotkeys := ""
    controlsForModifiers := ""
    groupBox := ""
    
    advancedModeButton := ""
    saveButton := ""
    cancelButton := ""

    availableKeyNames := []

    activeObjectsRegistry := ""

    hotkeyCrafter := ""

    specialActionRadio := ""
    newKeyRadio := ""

    currentObjectName := ""
    currentMethodName := ""


    controlsForAllSpecialActionCrafting := ""

    controlsForSpecificSpecialActionCrafting := ""

    controlsForParameters := ""

    currentHotkeyToExcecuteAction := ""

    amountOfParametersToBeFilled := 0

    __New(originalAction, pathToKeyNamesFile, activeObjectsRegistry, currentHotkeyToExcecuteAction){

        this.currentHotkeyToExcecuteAction := currentHotkeyToExcecuteAction

        this.controlsForAllSpecialActionCrafting := guiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := guiControlsRegistry()
        this.controlsForParameters := guiControlsRegistry()

        this.activeObjectsRegistry := activeObjectsRegistry
        allPossibleSpecialActions := this.activeObjectsRegistry.getFriendlyNames()
        ; allPossibleSpecialActions := ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6LONGASSNAMEEE turn off battery saver and such (WIP)", "Test7", "Test8", "Test9", "Test10"]

        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(pathToKeyNamesFile, "rw" , "UTF-8")

        this.GuiObject := Gui(, "Action Crafter")
        this.GuiObject.Opt("+Resize +MinSize640x480")
        
        originalActionControl := this.GuiObject.Add("Text", "", "Original Action: " . originalAction)
        
        this.specialActionRadio := this.GuiObject.Add("Radio", "Checked", "Special Action")
        this.specialActionRadio.OnEvent("Click", (*) => this.hotkeyCrafter.hideAllButFinalisationButtons() this.controlsForAllSpecialActionCrafting.showControls())
        this.newKeyRadio := this.GuiObject.Add("Radio", "", "New Key")
        this.newKeyRadio.OnEvent("Click", (*) => this.hotkeyCrafter.show() this.controlsForAllSpecialActionCrafting.hideControls())

        listViewOfSpecialAction := this.GuiObject.Add("ListView", "r20 Grid w400", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12 c333333", "Segoe UI")

        ; listViewOfSpecialAction.OnEvent("ItemSelect", msgbox("test"))
        ; listViewOfSpecialAction.ModifyCol()




        ; TODO what is needed for an action:
        ; Object name
        ; Method name
        ; Method parameters (which would be an array)
        ; .isObject true

        ; TODO what is needed for a hotkey:
        ; Key
        ; Modifiers
        ; .isObject false

        Loop allPossibleSpecialActions.Length
        {
            listViewOfSpecialAction.Add("", allPossibleSpecialActions[A_Index])
        }

        listViewOfSpecialAction.ModifyCol(1, "Center ", )

        this.controlsForAllSpecialActionCrafting.AddControl("listViewOfSpecialAction", listViewOfSpecialAction)

        this.hotkeyCrafter := HotkeyCrafterGui(originalAction, pathToKeyNamesFile, this.GuiObject)
        this.hotkeyCrafter.hideAllButFinalisationButtons()

        ; validationText := this.guiObject.Add("Text", "x+20 y+20", "Validation Text")

        this.createSpecialActionMaker()

        specialActionSelectedEvent := ObjBindMethod(this, "listViewOfSpecialActionSelected")
        listViewOfSpecialAction.OnEvent("ItemSelect", specialActionSelectedEvent)

        ; this.availableKeyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()
        ; this.controlsForAdvancedHotkeys := guiControlsRegistry()
        ; this.controlsForSimpleHotkeys := guiControlsRegistry()
        ; this.controlsForModifiers := guiControlsRegistry()

        ; originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")

    }

    ; TODO what is needed for an action:
        ; Object name
        ; Method name
        ; Method parameters (which would be an array)
        ; .isObject true

    listViewOfSpecialActionSelected(listView, rowNumberSpecialAction, columnNumber){
        friendlyNameOfAction := listView.GetText(rowNumberSpecialAction)
        ObjectInfoOfAction := this.activeObjectsRegistry.GetObjectByFriendlyMethodName(friendlyNameOfAction)
        MethodInfoOfAction := ObjectInfoOfAction.getMethodByFriendlyMethodName(friendlyNameOfAction)

        this.currentObjectName := ObjectInfoOfAction.getObjectName()
        this.currentMethodName := MethodInfoOfAction.getMethodName()
        methodDescription := MethodInfoOfAction.getMethodDescription()

        parameters := MethodInfoOfAction.getMethodParameters()

        this.setAmountOfParametersToBeFilled(parameters.count)

        ; objectName := "layers"
        ; methodName := "cycleLayerIndicators"
        ; friendlyNameOfAction := "Cycle Layer Indicators"
        ; methodDescription := "Cycles the layer indicators for a given layer, this is just some extra text i added because i needed a longer description.)"

        ; ; !TESTING
        ; parameters := Map()
        ; parameter1 := Object()
        ; parameter1.name := "red"
        ; parameter1.type := "int"
        ; parameter1.description := "The red value to set the gamme. 0-255"
        ; parameters["red"] := parameter1

        ; parameter2 := Object()
        ; parameter2.name := "Folder path"
        ; parameter2.type := "string"
        ; parameter2.description := "A path to a folder. from the root. Example: C:\\Users\\User\\Desktop\\Folder"
        ; parameters["Folder path"] := parameter2

        ; parameter3 := Object()
        ; parameter3.name := "shit"
        ; parameter3.type := "int"
        ; parameter3.description := "The brightness to set the monitor to. 0-100"
        ; parameters["Brightness"] := parameter3

        this.hideParameterControls()
        this.setTextForSpecialActionMaker(friendlyNameOfAction, methodDescription, parameters)

    }

    setAmountOfParametersToBeFilled(parameterCount){
        this.amountOfParametersToBeFilled := parameterCount
    }

    createSpecialActionMaker(){

        groupBoxForActionDescription := this.GuiObject.Add("GroupBox", " Section xp yp-185 w400 h45", "Action Description")
        actionDescriptionControl := this.GuiObject.Add("Text", "xp+15 yp+15 w380", "")
        actionDescriptionControl.SetFont("s12 c333333", "Segoe UI")
        actionDescriptionControl.Opt("Hidden1")

        groupBoxForActionMaker := this.GuiObject.Add("GroupBox", " Section ym w400 h500", "Special Action Maker")

        
        groupBoxForActionToDo := this.GuiObject.Add("GroupBox", " Section xp+20 yp+20 w360 h45", "Action to do")
        friendlyNameOfActionControl := this.GuiObject.Add("Text", "xs+15 ys+15 wrap", "")
        friendlyNameOfActionControl.SetFont("s12 c333333", "Segoe UI")
        friendlyNameOfActionControl.Opt("Hidden1")

        
        this.createParameterControls(5)

        noParametersForActionText := this.guiObject.Add("Text", "xs+40 ys+60 w200 h200", "THIS ACTION HAS NO PARAMETERS:)")
        noParametersForActionText.SetFont("s20")
        noParametersForActionText.Opt("Hidden1")

        this.controlsForSpecificSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForSpecificSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForSpecificSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)


        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionMaker", groupBoxForActionMaker)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionToDo", groupBoxForActionToDo)
        this.controlsForAllSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForAllSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("noParametersForActionText", noParametersForActionText)
    }

    setTextForSpecialActionMaker(friendlyNameOfAction, actionDescription, parameters){

        friendlyNameOfActionControl := this.controlsForSpecificSpecialActionCrafting.getControl("friendlyNameOfActionControl")
        friendlyNameOfActionControl.Text := friendlyNameOfAction
        this.SetTextAndResize(friendlyNameOfActionControl, friendlyNameOfAction)
        
        actionDescriptionControl := this.controlsForSpecificSpecialActionCrafting.getControl("actionDescriptionControl")
        actionDescriptionControl.Text := actionDescription
        textWidth := (this.GetTextSize(actionDescriptionControl, actionDescription)[1])

        ; this.SetTextAndResize(actionDescriptionControl, actionDescription)


        newHeight := 50 + (textWidth/350)*20
        this.controlsForSpecificSpecialActionCrafting.getControl("groupBoxForActionDescription").Move(, , , newHeight)
        actionDescriptionControl.Move(, , , newHeight-30)

        
        if(parameters.count = 0){
            this.controlsForAllSpecialActionCrafting.getControl("noParametersForActionText").Opt("Hidden0")
        }
        else{
            this.controlsForAllSpecialActionCrafting.getControl("noParametersForActionText").Opt("Hidden1")
            this.setTextForParameterControls(parameters)
        }

        this.controlsForSpecificSpecialActionCrafting.ShowControls()
    }

    createParameterControls(amountOfParameters){

        groupBoxForParameters := this.GuiObject.Add("GroupBox", " Section xp-15 yp+50 w360 h400", "Parameters")

        this.parameterControlsArray := Array()

        Loop amountOfParameters{
            
            parameterControl := this.GuiObject.Add("Text", "xs+10 yp+30 w335", "")
            parameterControl.SetFont("Bold")

            parameterEdit := this.GuiObject.Add("Edit", "xs+10 yp+30 w335", "")
            
            parameterDescription := this.GuiObject.Add("Text", "xs+10 yp+30 w335", "")
            ; parameterDescription.SetFont("Bold")

            parameterControls := ParameterControlsGroup(parameterControl, parameterEdit, parameterDescription)
            this.parameterControlsArray.Push(parameterControls)

            parameterControls.HideControls()
        }
    }

    hideParameterControls(){
        For parameterControls in this.parameterControlsArray{
            parameterControls.HideControls()
        }
    }

    setTextForParameterControls(parameters){
        index := 0
        For parameter, parameterInfo in parameters{
            index++
            parameterControls := this.parameterControlsArray[index]

            parameterName := parameterInfo.getName()
            parameterType := parameterInfo.getType()
            parameterDescription := parameterInfo.getDescription()

            ; !TESTING
            ; parameterName := parameterInfo.name
            ; parameterType := parameterInfo.type
            ; parameterDescription := parameterInfo.description
            
            parameterControls.setTextControlValue(parameterName)

            parameterControls.setEditControlType(parameterType)

            parameterControls.setDescriptionControlValue(parameterDescription)

            parameterControls.ShowControls()

        }
    }

    addSaveButtonClickEventAction(action){
        this.hotkeyCrafter.addSaveButtonClickEventAction(action)
    }

    addCancelButtonClickEventAction(action){
        this.hotkeyCrafter.addCancelButtonClickEventAction(action)
    }
    
    addDeleteButtonClickEventAction(action){
        this.hotkeyCrafter.addDeleteButtonClickEventAction(action)
    }

    addCloseEventAction(action){
        this.hotkeyCrafter.addCloseEventAction(action)
    }

    getCrafter(){
        ; TODO add conditionals to check which crafter 
        return this.hotkeyCrafter
    }

    getNewAction(){
        ; TODO add conditionals to check which crafter
        ; TODO check if the values to return are correct perhaps...
        if (this.specialActionRadio.Value = true){
            ; TODO return a action
            return this.getNewSpecialActionHotkey()
        }
        else if (this.newKeyRadio.Value = true){
            return this.hotkeyCrafter.getNewHotkey()
        }
    }

    getNewSpecialActionHotkey(){
        hotkeyToReturn := HotKeyInfo(this.currentHotkeyToExcecuteAction)
        parameters := []
        Loop this.amountOfParametersToBeFilled{
            parameterControls := this.parameterControlsArray[A_index]
            parameterValue := parameterControls.getEditControlValue()
            parameters.Push(parameterValue)
        }
        hotkeyToReturn.setInfoForSpecialHotKey(this.currentObjectName, this.currentMethodName, parameters)
        return hotkeyToReturn
    }

    show(){
        this.GuiObject.show()
    }

    Destroy(){
        this.GuiObject.destroy()
    }

    ; TODO create a class for this...
    SetTextAndResize(textCtrl, text) {
        textCtrl.Move(,, this.GetTextSize(textCtrl, text)*)
        textCtrl.Value := text
        textCtrl.Gui.Show('AutoSize')
    

    }

    GetTextSize(textCtrl, text) {
        static WM_GETFONT := 0x0031, DT_CALCRECT := 0x400
        hDC := DllCall('GetDC', 'Ptr', textCtrl.Hwnd, 'Ptr')
        hPrevObj := DllCall('SelectObject', 'Ptr', hDC, 'Ptr', SendMessage(WM_GETFONT,,, textCtrl), 'Ptr')
        height := DllCall('DrawText', 'Ptr', hDC, 'Str', text, 'Int', -1, 'Ptr', buf := Buffer(16), 'UInt', DT_CALCRECT)
        width := NumGet(buf, 8, 'Int') - NumGet(buf, 'Int')
        DllCall('SelectObject', 'Ptr', hDC, 'Ptr', hPrevObj, 'Ptr')
        DllCall('ReleaseDC', 'Ptr', textCtrl.Hwnd, 'Ptr', hDC)
        return [Round(width * 96/A_ScreenDPI), Round(height * 96/A_ScreenDPI)]
    }
}
; test := ActionCrafterGui("+Capslock", "..\resources\keyNames\keyNames.txt", "")
; test.Show()