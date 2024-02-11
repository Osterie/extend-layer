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

    __New(originalAction, pathToKeyNamesFile, activeObjectsRegistry){
        this.activeObjectsRegistry := activeObjectsRegistry
        ; test := this.activeObjectsRegistry.getFriendlyNames()

        keyNamesFileObjReader := KeyNamesReader()
        fileObjectOfKeyNames := FileOpen(pathToKeyNamesFile, "rw" , "UTF-8")

        this.GuiObject := Gui()
        this.GuiObject.Add("Text", "h20", "Original Action: " . originalAction)
        specialActionRadio := this.GuiObject.Add("Radio", "Checked", "Special Action")
        newKeyRadio := this.GuiObject.Add("Radio", "", "New Key")
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