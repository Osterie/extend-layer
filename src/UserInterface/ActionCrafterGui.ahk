#Requires AutoHotkey v2.0
#Include ".\guiControlsRegistry.ahk"

#Include "..\library\MetaInfo\MetaInfoReading\KeyNamesReader.ahk"
#Include ".\HotkeyCrafterGui.ahk"

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

    controlsForAllSpecialActionCrafting := ""

    controlsForSpecificSpecialActionCrafting := ""

    __New(originalAction, pathToKeyNamesFile, activeObjectsRegistry){

        this.controlsForAllSpecialActionCrafting := guiControlsRegistry()
        this.controlsForSpecificSpecialActionCrafting := guiControlsRegistry()

        this.activeObjectsRegistry := activeObjectsRegistry
        ; allPossibleSpecialActions := this.activeObjectsRegistry.getFriendlyNames()
        allPossibleSpecialActions := ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6LONGASSNAMEEE turn off battery saver and such (WIP)", "Test7", "Test8", "Test9", "Test10"]

        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(pathToKeyNamesFile, "rw" , "UTF-8")

        this.GuiObject := Gui(, "Action Crafter")
        this.GuiObject.Opt("+Resize +MinSize640x480")
        
        originalActionControl := this.GuiObject.Add("Text", "", "Original Action: " . originalAction)
        
        specialActionRadio := this.GuiObject.Add("Radio", "Checked", "Special Action")
        specialActionRadio.OnEvent("Click", (*) => this.hotkeyCrafter.hideAllButFinalisationButtons() this.controlsForAllSpecialActionCrafting.showControls())
        newKeyRadio := this.GuiObject.Add("Radio", "", "New Key")
        newKeyRadio.OnEvent("Click", (*) => this.hotkeyCrafter.show() this.controlsForAllSpecialActionCrafting.hideControls())

        listViewOfSpecialAction := this.GuiObject.Add("ListView", "r20 Grid w400", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12 c333333", "Segoe UI")

        specialActionSelectedEvent := ObjBindMethod(this, "listViewOfSpecialActionSelected")
        listViewOfSpecialAction.OnEvent("ItemSelect", specialActionSelectedEvent)
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


        this.createSpecialActionMaker()


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
        ; ObjectInfoOfAction := this.activeObjectsRegistry.GetObjectByFriendlyMethodName(friendlyNameOfAction)
        ; MethodInfoOfAction := ObjectInfoOfAction.getMethodByFriendlyMethodName(friendlyNameOfAction)

        ; objectName := ObjectInfoOfAction.getObjectName()
        ; methodName := MethodInfoOfAction.getMethodName()

        ; parameters := MethodInfoOfAction.getMethodParameters()

        objectName := "layers"
        methodName := "cycleLayerIndicators"
        friendlyNameOfAction := "Cycle Layer Indicators"
        methodDescription := "Cycles the layer indicators for a given layer, this is just some extra text i added because i needed a longer description.)"

        this.setTextForSpecialActionMaker(friendlyNameOfAction, methodDescription)

    }

    createSpecialActionMaker(){

        groupBoxForActionMaker := this.GuiObject.Add("GroupBox", " Section ym w400 h500", "Special Action Maker")
        
        groupBoxForActionToDo := this.GuiObject.Add("GroupBox", " Section xp+20 yp+20 w360 h45", "Action to do")
        friendlyNameOfActionControl := this.GuiObject.Add("Text", "xs+15 ys+15 wrap", "")
        friendlyNameOfActionControl.SetFont("s12 c333333", "Segoe UI")
        friendlyNameOfActionControl.Opt("Hidden1")
        
        groupBoxForActionDescription := this.GuiObject.Add("GroupBox", " Section xp-15 yp+40 w360 h45", "Action Description")
        actionDescriptionControl := this.GuiObject.Add("Text", "Section xp+15 yp+15 w335", "")
        actionDescriptionControl.SetFont("s12 c333333", "Segoe UI")
        actionDescriptionControl.Opt("Hidden1")

        this.controlsForSpecificSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForSpecificSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForSpecificSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)


        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionMaker", groupBoxForActionMaker)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionToDo", groupBoxForActionToDo)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForAllSpecialActionCrafting.AddControl("friendlyNameOfActionControl", friendlyNameOfActionControl)
        this.controlsForAllSpecialActionCrafting.AddControl("groupBoxForActionDescription", groupBoxForActionDescription)
        this.controlsForAllSpecialActionCrafting.AddControl("actionDescriptionControl", actionDescriptionControl)



    }

    setTextForSpecialActionMaker(friendlyNameOfAction, actionDescription){

        friendlyNameOfActionControl := this.controlsForSpecificSpecialActionCrafting.getControl("friendlyNameOfActionControl")
        friendlyNameOfActionControl.Text := friendlyNameOfAction
        this.SetTextAndResize(friendlyNameOfActionControl, friendlyNameOfAction)
        
        actionDescriptionControl := this.controlsForSpecificSpecialActionCrafting.getControl("actionDescriptionControl")
        actionDescriptionControl.Text := actionDescription
        textWidth := (this.GetTextSize(actionDescriptionControl, actionDescription)[1])

        ; this.SetTextAndResize(actionDescriptionControl, actionDescription)


        newHeight := 45 + (textWidth/350)*20
        this.controlsForSpecificSpecialActionCrafting.getControl("groupBoxForActionDescription").Move(, , , newHeight)
        actionDescriptionControl.Move(, , , newHeight-30)


        this.controlsForSpecificSpecialActionCrafting.ShowControls()
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
        return this.hotkeyCrafter.getNewHotkey()
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
test := ActionCrafterGui("+Capslock", "..\resources\keyNames\keyNames.txt", "")
test.Show()