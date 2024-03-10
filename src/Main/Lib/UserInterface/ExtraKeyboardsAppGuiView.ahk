#Requires AutoHotkey v2.0

#Include <UserInterface\Main\ProfileEditing\ProfileRegionModel>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionView>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionController>
#Include <UserInterface\Main\util\TreeViewMaker>
#Include <UserInterface\Main\util\ListViewMaker>
#Include <UserInterface\Main\Functionality\KeyboardEditing\HotKeyConfigurationView>
#Include <UserInterface\Main\util\GuiColorsChanger>

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
