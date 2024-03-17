#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include "..\HotkeyChanging\HotkeyCrafterView.ahk"
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include ".\ParameterControlsGroup.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>
#Include <UserInterface\Main\Util\DomainSpecificGui>


class ActionCrafterView extends HotkeyCrafterView{

    saveEventSubscribers := Array()

    specialActionRadio := ""
    newKeyRadio := ""

    currentObjectName := ""
    currentMethodName := ""


    controlsForAllSpecialActionCrafting := ""

    controlsForSpecificSpecialActionCrafting := ""

    controlsForParameters := ""

    amountOfParametersToBeFilled := 0

    __New(controller){
        super.__New(controller)
        this.Opt("+Resize +MinSize840x580")
    }

    Create(originalAction){
        

        this.controlsForAllSpecialActionCrafting := guiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := guiControlsRegistry()
        this.controlsForParameters := guiControlsRegistry()

        allPossibleSpecialActions := this.controller.getActiveObjectsRegistry().getFriendlyNames()


        
        originalActionControl := this.Add("Text", "", "Original Action: " . originalAction)
        
        this.specialActionRadio := this.Add("Radio", "Checked", "Special Action")
        this.specialActionRadio.OnEvent("Click", (*) => this.hideAllButFinalisationButtons() this.controlsForAllSpecialActionCrafting.show())
        this.newKeyRadio := this.Add("Radio", "", "New Key")
        this.newKeyRadio.OnEvent("Click", (*) => this.ShowSome() this.controlsForAllSpecialActionCrafting.hide())

        super.Create(originalAction)
        this.hideAllButFinalisationButtons()
        this.hideButtons()
        this.hideOriginalHotkeyText()

        listViewOfSpecialAction := this.Add("ListView", "x20 y65 r20 w400", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12")
        listViewOfSpecialAction.ModifyCol(1, "Center", )


        Loop allPossibleSpecialActions.Length
        {
            listViewOfSpecialAction.Add("", allPossibleSpecialActions[A_Index])
        }

        specialActionSelectedEvent := ObjBindMethod(this, "listViewOfSpecialActionSelected")
        listViewOfSpecialAction.OnEvent("ItemSelect", specialActionSelectedEvent)


        this.controlsForAllSpecialActionCrafting.AddControl("listViewOfSpecialAction", listViewOfSpecialAction)

        this.createSpecialActionMaker()

        this.saveButton := this.Add("Button", " w100 h20 x300 y0 ", "Save")
        this.saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        this.cancelButton := this.Add("Button", "w100 h20", "Cancel")
        this.cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    listViewOfSpecialActionSelected(listView, rowNumberSpecialAction, columnNumber){
        friendlyNameOfAction := listView.GetText(rowNumberSpecialAction)
        ObjectInfoOfAction := this.controller.getActiveObjectsRegistry().GetObjectByFriendlyMethodName(friendlyNameOfAction)
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

        groupBoxForActionDescription := this.Add("GroupBox", " Section xp w400 h45", "Action Description")
        actionDescriptionControl := this.Add("Text", "xp+15 yp+15 w380", "")
        actionDescriptionControl.SetFont("s12")

        actionDescriptionControl.Opt("Hidden1")

        groupBoxForActionMaker := this.Add("GroupBox", " Section ym w400 h500", "Special Action Maker")

        
        groupBoxForActionToDo := this.Add("GroupBox", " Section xp+20 yp+20 wp-40 h45", "Action to do")
        friendlyNameOfActionControl := this.Add("Text", "xs+15 ys+15 wrap", "")
        friendlyNameOfActionControl.SetFont("s12")
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

        this.controlsForSpecificSpecialActionCrafting.show()
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

            parameterControls.hide()
        }
    }

    hideParameterControls(){
        For parameterControls in this.parameterControlsArray{
            parameterControls.hide()
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
            parameterControls.show()
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