#Requires AutoHotkey v2.0

#Include <UserInterface\Main\ProfileEditing\ProfileRegionModel>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionView>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionController>
#Include <UserInterface\Main\util\TreeViewMaker>
#Include <UserInterface\Main\util\ListViewMaker>
#Include <UserInterface\Main\Functionality\KeyboardEditing\HotKeyConfigurationView>
#Include <UserInterface\Main\util\GuiColorsChanger>

#Include <UserInterface\Main\Util\DomainSpecificGui>


; TODO everything should inherit from a base gui class which fixes the colors and such of all the guis.
Class ExtraKeyboardsAppGuiView extends DomainSpecificGui{

    ; Used to create the gui
    ExtraKeyboardsAppGui := ""

    __New(){

    }

    CreateMain(controller){
        this.controller := controller

        this.ExtraKeyboardsAppGui := DomainSpecificGui("+Resize +MinSize920x480", "Extra Keyboards App")


        this.CreateProfileEditor()
        this.CreateTabs()
        
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

    GetHwnd(){
        return this.ExtraKeyboardsAppGui.Hwnd
    }
}
