#Requires AutoHotkey v2.0

#Include "Main\ProfileEditing\ProfileRegionModel.ahk"
#Include "Main\ProfileEditing\ProfileRegionView.ahk"
#Include "Main\ProfileEditing\ProfileRegionController.ahk"
#Include "Main\util\TreeViewMaker.ahk"
#Include "Main\util\ListViewMaker.ahk"
#Include "Main\Functionality\Keyboard\KeyboardEditing\HotKeyConfigurationPopup.ahk"
#Include "Main\util\GuiColorsChanger.ahk"


; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGuiView{

    ; Used to create the gui
    ExtraKeyboardsAppGui := ""

    __New(){
        ; Empty
    }


    CreateMain(controller){
        this.controller := controller  

        this.ExtraKeyboardsAppGui := Gui("+Resize +MinSize920x480", "Extra Keyboards App")
        this.ExtraKeyboardsAppGui.BackColor := "051336"
        this.ExtraKeyboardsAppGui.SetFont("c6688cc Bold")

        ; TODO when a profile is changed, update the paths? or not? since i at the moment restart everything when the profile is changed.
        this.CreateProfileEditor()
        this.CreateTabs()
        this.setColors()
        
        ; Create gui in the top left corner of the screen
        this.ExtraKeyboardsAppGui.Show("x0 y0")
    }

    CreateProfileEditor(){
        profileModel := ProfileRegionModel(this.ExtraKeyboardsAppGui)
        profileView := ProfileRegionView()
        profileController := ProfileRegionController(profileModel, profileView, ObjBindMethod(this.controller, "HandleProfileChangedEvent"))
        profileController.CreateView()
    }

    CreateTabs(){
        Tab := this.ExtraKeyboardsAppGui.AddTab3("yp+40 xm", ["Keyboards","Change Functions Settings","Documentation"])
        Tab.UseTab(1)
        this.CreateKeyboardsTab()

        Tab.UseTab(2)
        this.CreateFunctionSettingsTab()

        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0) ; subsequently-added controls will not belong to the tab control.
    }

    CreateKeyboardsTab(){

        ; TODO perhaps use inheritance or something, but this is the exact same as CreateFunctionSettingsTab pretty much 
        keyboardLayoutChanger := TreeViewMaker()
        keyboardLayoutChanger.createElementsForGui(this.ExtraKeyboardsAppGui, this.controller.GetKeyboardLayerIdentifiers())
        
        listViewControl := ListViewMaker()
        listViewControl.CreateListView(this.ExtraKeyboardsAppGui, ["KeyCombo","Action"])
        
        keyboardLayoutChanger.AddEventAction("ItemSelect", ObjBindMethod(this.controller, "HandleKeyboardLayerSelected", listViewControl))
        listViewControl.AddEventAction("DoubleClick", ObjBindMethod(this.controller, "HandleKeyComboActionDoubleClickedEvent"))
    }

    CreateFunctionSettingsTab(){

        functionsNamesTreeView := TreeViewMaker()
        functionsNamesTreeView.createElementsForGui(this.ExtraKeyboardsAppGui, this.controller.GetFunctionNames())
        
        settingsValuesListView := ListViewMaker()
        settingsValuesListView.CreateListView(this.ExtraKeyboardsAppGui, ["Setting","Value"])
        
        functionsNamesTreeView.AddEventAction("ItemSelect", ObjBindMethod(this.controller, "HandleFunctionFromTreeViewSelected", settingsValuesListView))
        settingsValuesListView.AddEventAction("DoubleClick", ObjBindMethod(this.controller, "HandleSettingClicked", functionsNamesTreeView))
    }


    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
    }

    setColors(){
        controlColor := "060621"
        textColor := "6688FF"
        GuiColorsChanger.setControlsColor(this.ExtraKeyboardsAppGui, controlColor)
        GuiColorsChanger.setControlsTextColor(this.ExtraKeyboardsAppGui, textColor)

        ; Top bar or whatever it is called
        GuiColorsChanger.DwmSetCaptionColor(this.ExtraKeyboardsAppGui, 0x300f45) ; color is in RGB format
        GuiColorsChanger.DwmSetTextColor(this.ExtraKeyboardsAppGui, 0x27eaf1)
    }

    Destroy(){
        this.ExtraKeyboardsAppGui.Destroy()
    }
}
