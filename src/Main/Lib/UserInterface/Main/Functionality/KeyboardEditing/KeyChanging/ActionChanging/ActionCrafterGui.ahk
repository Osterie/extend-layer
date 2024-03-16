#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include "..\HotkeyChanging\HotkeyCrafterGui.ahk"
#Include ".\ParameterControlsGroup.ahk"
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include <UserInterface\Main\util\GuiSizeChanger>
#Include <UserInterface\Main\Util\DomainSpecificGui>

#Include "..\HotkeyChanging\HotkeyCrafterGui.ahk"



class ActionCrafterGui extends HotkeyCrafterGui{

    activeObjectsRegistry := ""

    saveEventSubscribers := Array()

    specialActionRadio := ""
    newKeyRadio := ""

    currentObjectName := ""
    currentMethodName := ""


    controlsForAllSpecialActionCrafting := ""

    controlsForSpecificSpecialActionCrafting := ""

    controlsForParameters := ""

    amountOfParametersToBeFilled := 0

    arrayOfKeyNames := []

    __New(originalAction, arrayOfKeyNames, activeObjectsRegistry){

        super.__New()

        ; this.Opt("+Resize +MinSize640x480")
        ; this.show("w640 h480")


        this.arrayOfKeyNames := arrayOfKeyNames

        this.controlsForAllSpecialActionCrafting := guiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := guiControlsRegistry()
        this.controlsForParameters := guiControlsRegistry()

        this.activeObjectsRegistry := activeObjectsRegistry
        allPossibleSpecialActions := this.activeObjectsRegistry.getFriendlyNames()


        
        originalActionControl := this.Add("Text", "", "Original Action: " . originalAction)
        
        this.specialActionRadio := this.Add("Radio", "Checked", "Special Action")
        this.specialActionRadio.OnEvent("Click", (*) => this.hideAllButFinalisationButtons() this.controlsForAllSpecialActionCrafting.showControls())
        this.newKeyRadio := this.Add("Radio", "Section", "New Key")
        this.newKeyRadio.OnEvent("Click", (*) => this.ShowSome() this.controlsForAllSpecialActionCrafting.hideControls())

        super.Create(originalAction, arrayOfKeyNames)
        this.hideAllButFinalisationButtons()
        this.hideButtons()
        this.hideOriginalHotkeyText()

        listViewOfSpecialAction := this.Add("ListView", "xs ys r20 w400", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12 c333333", "Segoe UI")


        Loop allPossibleSpecialActions.Length
        {
            listViewOfSpecialAction.Add("", allPossibleSpecialActions[A_Index])
        }

        listViewOfSpecialAction.ModifyCol(1, "Center ", )

        this.controlsForAllSpecialActionCrafting.AddControl("listViewOfSpecialAction", listViewOfSpecialAction)



        ; validationText := this.guiObject.Add("Text", "x+20 y+20", "Validation Text")



        this.createSpecialActionMaker()

        specialActionSelectedEvent := ObjBindMethod(this, "listViewOfSpecialActionSelected")
        listViewOfSpecialAction.OnEvent("ItemSelect", specialActionSelectedEvent)

        
        this.controlsForAdvancedHotkeys := guiControlsRegistry()
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.controlsForModifiers := guiControlsRegistry()

        this.saveButton := this.Add("Button", " w100 h20 xM yp+150", "Save")
        this.saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        this.cancelButton := this.Add("Button", "w100 h20", "Cancel")
        this.cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    listViewOfSpecialActionSelected(listView, rowNumberSpecialAction, columnNumber){
        friendlyNameOfAction := listView.GetText(rowNumberSpecialAction)
        ObjectInfoOfAction := this.activeObjectsRegistry.GetObjectByFriendlyMethodName(friendlyNameOfAction)
        MethodInfoOfAction := ObjectInfoOfAction.getMethodByFriendlyMethodName(friendlyNameOfAction)

        this.currentObjectName := ObjectInfoOfAction.getObjectName()
        this.currentMethodName := MethodInfoOfAction.getMethodName()
        methodDescription := MethodInfoOfAction.getMethodDescription()

        parameters := MethodInfoOfAction.getMethodParameters()

        this.setAmountOfParametersToBeFilled(parameters.Count)
        this.hideParameterControls()
        this.setTextForSpecialActionMaker(friendlyNameOfAction, methodDescription, parameters)

    }

    setAmountOfParametersToBeFilled(parameterCount){
        this.amountOfParametersToBeFilled := parameterCount
    }

    createSpecialActionMaker(){

        groupBoxForActionDescription := this.Add("GroupBox", " Section xp yp-185 w400 h45", "Action Description")
        actionDescriptionControl := this.Add("Text", "xp+15 yp+15 w380", "")
        actionDescriptionControl.SetFont("s12 c333333", "Segoe UI")
        actionDescriptionControl.Opt("Hidden1")

        groupBoxForActionMaker := this.Add("GroupBox", " Section ym w400 h500", "Special Action Maker")

        
        groupBoxForActionToDo := this.Add("GroupBox", " Section xp+20 yp+20 w360 h45", "Action to do")
        friendlyNameOfActionControl := this.Add("Text", "xs+15 ys+15 wrap", "")
        friendlyNameOfActionControl.SetFont("s12 c333333", "Segoe UI")
        friendlyNameOfActionControl.Opt("Hidden1")

        
        this.createParameterControls(5)

        noParametersForActionText := this.Add("Text", "xs+40 ys+60 w200 h200", "THIS ACTION HAS NO PARAMETERS:)")
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
        GuiSizeChanger.SetTextAndResize(friendlyNameOfActionControl, friendlyNameOfAction)
        
        actionDescriptionControl := this.controlsForSpecificSpecialActionCrafting.getControl("actionDescriptionControl")
        actionDescriptionControl.Text := actionDescription
        textWidth := (this.GetTextSize(actionDescriptionControl, actionDescription)[1])

        ; GuiSizeChanger.SetTextAndResize(actionDescriptionControl, actionDescription)


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

        groupBoxForParameters := this.Add("GroupBox", " Section xp-15 yp+50 w360 h400", "Parameters")

        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForParameters", groupBoxForParameters)

        this.parameterControlsArray := Array()

        Loop amountOfParameters{
            
            parameterControl := this.Add("Text", "xs+10 yp+30 w335", "")
            parameterControl.SetFont("Bold")

            parameterEdit := this.Add("Edit", "xs+10 yp+30 w335", "")
            
            parameterDescription := this.Add("Text", "xs+10 yp+30 w335", "")

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

            parameterControls.setTextControlValue(parameterName)
            parameterControls.setEditControlType(parameterType)
            parameterControls.setDescriptionControlValue(parameterDescription)
            parameterControls.ShowControls()
        }
    }

    subscribeToSaveEvent(action){
        this.saveEventSubscribers.Push(action)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.getNewAction())
        }
        this.Destroy()
    }

    addCancelButtonClickEventAction(action){
        this.addCancelButtonClickEventAction(action)
    }
    
    ; addDeleteButtonClickEventAction(action){
    ;     this.addDeleteButtonClickEventAction(action)
    ; }

    addCloseEventAction(action){
        this.addCloseEventAction(action)
    }

    getCrafter(){
        ; TODO add conditionals to check which crafter 
        return this
    }

    getNewAction(){
        ; TODO check if the values to return are correct perhaps...
        if (this.specialActionRadio.Value = true){
            return this.getNewSpecialActionHotkey()
        }
        else if (this.newKeyRadio.Value = true){
            return this.getNewHotkey()
        }
    }

    getNewSpecialActionHotkey(){
        hotkeyToReturn := HotKeyInfo("")
        parameters := []
        Loop this.amountOfParametersToBeFilled{
            parameterControls := this.parameterControlsArray[A_index]
            parameterValue := parameterControls.getEditControlValue()
            parameters.Push(parameterValue)
        }
        hotkeyToReturn.setInfoForSpecialHotKey(this.currentObjectName, this.currentMethodName, parameters)
        return hotkeyToReturn
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