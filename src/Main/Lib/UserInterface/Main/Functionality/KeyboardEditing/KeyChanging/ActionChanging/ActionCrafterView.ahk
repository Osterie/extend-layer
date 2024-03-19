#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>
#Include "..\HotkeyChanging\HotkeyCrafterView.ahk"
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include ".\ParameterControlsGroup.ahk"
#Include ".\ParameterControl.ahk"
#Include <UserInterface\Main\util\GuiSizeChanger>

class ActionCrafterView extends HotkeyCrafterView{

    saveEventSubscribers := Array()

    specialActionRadio := ""
    newKeyRadio := ""

    currentObjectName := ""
    currentMethodName := ""

    controlsForAllSpecialActionCrafting := ""
    controlsForSpecificSpecialActionCrafting := ""

    __New(controller){
        super.__New(controller)
        this.Opt("+Resize +MinSize840x580")
        this.controlsForAllSpecialActionCrafting := guiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := guiControlsRegistry()
    }

    Create(originalAction){
        this.CreateCrafterTypeRadioButtons()
        super.Create("")
        super.hide()
        this.CreateSpecialActionsListView()
        this.CreateActionDescription("xp w400 h45")
        this.createSpecialActionMaker()
    }

    CreateSpecialActionsListView(){
        listViewOfSpecialAction := this.Add("ListView", "x20 y65 r20 w400", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12")
        listViewOfSpecialAction.ModifyCol(1, "Center", )


        allPossibleSpecialActions := this.controller.getActiveObjectsRegistry().getFriendlyNames()
        Loop allPossibleSpecialActions.Length{
            listViewOfSpecialAction.Add("", allPossibleSpecialActions[A_Index])
        }

        listViewOfSpecialAction.OnEvent("ItemFocus", ObjBindMethod(this, "listViewOfSpecialActionSelected"))

        this.controlsForAllSpecialActionCrafting.AddControl("listViewOfSpecialAction", listViewOfSpecialAction)
    }

    CreateCrafterTypeRadioButtons(){
        this.specialActionRadio := this.Add("Radio", "Checked y30 x10", "Special Action")
        this.specialActionRadio.OnEvent("Click", (*) => this.hideAllButButtons() this.controlsForAllSpecialActionCrafting.show() this.parameterControls.show())
        this.newKeyRadio := this.Add("Radio", "", "New Key")
        this.newKeyRadio.OnEvent("Click", (*) => this.ShowHotkeyCrafterControls() this.controlsForAllSpecialActionCrafting.hide() this.parameterControls.hide())
        
    }

    CreateButtons(){
        saveButton := this.Add("Button", " w100 h20 x300 y0 ", "Save")
        saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        cancelButton := this.Add("Button", "w100 h20", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    listViewOfSpecialActionSelected(listView, rowNumberSpecialAction){

        this.parameterControls.hide()
        friendlyNameOfAction := listView.GetText(rowNumberSpecialAction)
        ObjectInfoOfAction := this.controller.GetObjectInfoByFriendlyName(friendlyNameOfAction)
        MethodInfoOfAction := ObjectInfoOfAction.getMethodByFriendlyMethodName(friendlyNameOfAction)

        
        this.currentObjectName := ObjectInfoOfAction.getObjectName()
        this.currentMethodName := MethodInfoOfAction.getMethodName()
        methodDescription := MethodInfoOfAction.getMethodDescription()

        parameters := MethodInfoOfAction.getMethodParameters()
        
        this.parameterControls.hide()
        this.setTextForSpecialActionMaker(friendlyNameOfAction, methodDescription, parameters)
    }

    CreateSpecialActionMaker(){

        this.CreateActionToDoControls("ym w400 h500")
        
        this.createParameterControls(5)
        this.parameterControls.hide()

        noParametersForActionText := this.Add("Text", "xs+40 ys+60 w200 h200", "THIS ACTION HAS NO PARAMETERS:)")
        noParametersForActionText.SetFont("s20")
        noParametersForActionText.Opt("Hidden1")

        this.controlsForAllSpecialActionCrafting.AddControl("noParametersForActionText", noParametersForActionText)
    }

    CreateActionDescription(position){

        groupBoxForActionDescription := this.Add("GroupBox", " Section " . position , "Action Description")

        actionDescriptionControl := this.Add("Text", "xp+15 yp+15 w380", "")
        actionDescriptionControl.SetFont("s12")
        actionDescriptionControl.Opt("Hidden1")

        this.controlsForSpecificSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)

        this.controlsForSpecificSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
    }

    CreateActionToDoControls(position){
        groupBoxForActionMaker := this.Add("GroupBox", " Section " . position, "Special Action Maker")
        
        groupBoxForActionToDo := this.Add("GroupBox", " Section xp+20 yp+20 wp-40 h45", "Action to do")
        friendlyNameOfActionControl := this.Add("Text", "xs+15 ys+15 wrap", "")
        friendlyNameOfActionControl.SetFont("s12")
        friendlyNameOfActionControl.Opt("Hidden1")

        this.controlsForSpecificSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionMaker", groupBoxForActionMaker)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionToDo", groupBoxForActionToDo)
    }

    setTextForSpecialActionMaker(friendlyNameOfAction, actionDescription, parameters){

        friendlyNameOfActionControl := this.controlsForSpecificSpecialActionCrafting.getControl("friendlyNameOfActionControl")
        friendlyNameOfActionControl.Text := friendlyNameOfAction
        GuiSizeChanger.SetTextAndResize(friendlyNameOfActionControl, friendlyNameOfAction)
        
        actionDescriptionControl := this.controlsForSpecificSpecialActionCrafting.getControl("actionDescriptionControl")
        actionDescriptionControl.Text := actionDescription
        textWidth := GuiSizeChanger.GetTextSize(actionDescriptionControl, actionDescription)[1]


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
        ; TODO add this group box to the ParameterControlGroup2
        groupBoxForParameters := this.Add("GroupBox", " Section xp-15 yp+50 w360 h400", "Parameters")
        this.parameterControls := ParameterControlsGroup(this, "xs+10 ys+30 w335")

        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForParameters", groupBoxForParameters)
    }


    setTextForParameterControls(parameters){
        this.parameterControls.SetInfo(parameters)
        this.parameterControls.Show()
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
        parameters := this.parameterControls.GetParameterValues()
        hotkeyToReturn.setInfoForSpecialHotKey(this.currentObjectName, this.currentMethodName, parameters)
        return hotkeyToReturn
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
}