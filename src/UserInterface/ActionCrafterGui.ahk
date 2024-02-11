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

    controlsForSpecialActionCrafting := ""

    __New(originalAction, pathToKeyNamesFile, activeObjectsRegistry){

        this.controlsForSpecialActionCrafting := guiControlsRegistry()

        this.activeObjectsRegistry := activeObjectsRegistry
        ; allPossibleSpecialActions := this.activeObjectsRegistry.getFriendlyNames()
        allPossibleSpecialActions := ["Test1", "Test2", "Test3", "Test4", "Test5", "Test6LONGASSNAMEEE", "Test7", "Test8", "Test9", "Test10"]

        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(pathToKeyNamesFile, "rw" , "UTF-8")

        this.GuiObject := Gui(, "Action Crafter")
        this.GuiObject.Opt("+Resize +MinSize640x480")
        
        originalActionControl := this.GuiObject.Add("Text", "", "Original Action: " . originalAction)
        
        specialActionRadio := this.GuiObject.Add("Radio", "Checked", "Special Action")
        specialActionRadio.OnEvent("Click", (*) => this.hotkeyCrafter.hideAllButFinalisationButtons() this.controlsForSpecialActionCrafting.showControls())
        newKeyRadio := this.GuiObject.Add("Radio", "", "New Key")
        newKeyRadio.OnEvent("Click", (*) => this.hotkeyCrafter.show() this.controlsForSpecialActionCrafting.hideControls())

        listViewOfSpecialAction := this.GuiObject.Add("ListView", "r20 Grid", ["Special Action"])
        listViewOfSpecialAction.SetFont("s12", "Verdana")
        ; listViewOfSpecialAction.ModifyCol()


        Loop allPossibleSpecialActions.Length
        {
            listViewOfSpecialAction.Add("", allPossibleSpecialActions[A_Index])
        }

        listViewOfSpecialAction.ModifyCol(1, "Center AutoHdr", )

        this.controlsForSpecialActionCrafting.AddControl("listViewOfSpecialAction", listViewOfSpecialAction)

        this.hotkeyCrafter := HotkeyCrafterGui(originalAction, pathToKeyNamesFile, this.GuiObject)
        this.hotkeyCrafter.hideAllButFinalisationButtons()



        ; this.availableKeyNames := keyNamesFileObjReader.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames).GetKeyNames()
        ; this.controlsForAdvancedHotkeys := guiControlsRegistry()
        ; this.controlsForSimpleHotkeys := guiControlsRegistry()
        ; this.controlsForModifiers := guiControlsRegistry()

        ; originalHotkeyFormatted := HotkeyFormatConverter.convertFromFriendlyName(originalHotkey, " + ")

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
}
test := ActionCrafterGui("+Capslock", "..\resources\keyNames\keyNames.txt", "")
test.Show()