#Requires AutoHotkey v2.0

#Include <ui\Main\util\GuiControlsRegistry>
#Include "..\HotkeyChanging\HotkeyCrafter.ahk"

#Include ".\ParameterControlsGroup.ahk"
#Include ".\ParameterControl.ahk"
#Include <ui\Main\util\GuiSizeChanger>

class ActionCrafter extends HotkeyCrafter{

    saveEventSubscribers := Array()

    controlsForAllSpecialActionCrafting := ""
    controlsForSpecificSpecialActionCrafting := ""

    __New(controller){
        super.__New(controller)
        this.Opt("+Resize +MinSize840x580")
        this.controlsForAllSpecialActionCrafting := GuiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := GuiControlsRegistry()
    }

    Create(){
        this.CreateCrafterTypeRadioButtons()
        super.Create("")
        super.hide()
        this.CreateSpecialActionsListView()
        this.CreateActionDescription("xp w400 h45")
        this.createSpecialActionMaker()
    }

    CreateSpecialActionsListView(){
        specialActions := this.Add("ListView", "x20 y65 r20 w400", ["Special Action"])
        specialActions.SetFont("s12")
        specialActions.ModifyCol(1, "Center", )

        this.AddItemsToListView(specialActions, this.controller.GetSpecialActions())
        specialActions.OnEvent("ItemFocus", (*) => this.controller.handleActionSelected(specialActions.GetText(specialActions.GetNext( , "Focused"))))

        this.controlsForAllSpecialActionCrafting.AddControl("specialActions", specialActions)
    }

    AddItemsToListView(listview, items){
        Loop items.Length{
            listview.Add("", items[A_Index])
        }
    }

    CreateCrafterTypeRadioButtons(){
        specialActionRadio := this.Add("Radio", "Checked y30 x10", "Special Action")
        specialActionRadio.OnEvent("Click", (*) => this.controller.doSpecialActionCrafting())
        newKeyRadio := this.Add("Radio", "", "New Key")
        newKeyRadio.OnEvent("Click", (*) => this.controller.doNewKeyActionCrafting())
    }

    SetSpecialActionAsActive(){
        this.HideHotkeyCrafterControls() 
        this.ShowSpecialActionCrafterControls()
    }

    SetNewKeyAsActive(){
        this.ShowHotkeyCrafterControls() 
        this.HideSpecialActionCrafterControls()
    }

    ShowSpecialActionCrafterControls(){
        this.controlsForAllSpecialActionCrafting.show()
        this.parameterControls.show()
    }

    HideSpecialActionCrafterControls(){
        this.controlsForAllSpecialActionCrafting.hide()
        this.HideParameters()
    }

    HideParameters(){
        this.parameterControls.hide()
    }

    CreateButtons(){
        saveButton := this.Add("Button", " w100 h20 x300 y0 ", "Save")
        saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())
        
        cancelButton := this.Add("Button", "w100 h20", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.Destroy())
    }

    CreateSpecialActionMaker(){

        this.CreateActionToDoControls("ym w400 h500")
        
        this.createParameterControls(5)
        this.HideParameters()

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

        if(parameters.Length = 0){
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
        if (this.controller.IsCraftingSpecialAction()){
            return this.getNewSpecialActionHotkey()
        }
        else if (!this.controller.IsCraftingSpecialAction()){
            return this.getNewHotkey()
        }
    }

    GetNewSpecialActionHotkey(){
        return this.controller.GetHotkey(this.parameterControls.GetParameterValues())
    }

    SubscribeToSaveEvent(action){
        this.saveEventSubscribers.Push(action)
    }

    NotifyListenersSave(){
        Loop this.saveEventSubscribers.Length{
            this.saveEventSubscribers[A_Index](this.getNewAction())
        }
        this.Destroy()
    }
}