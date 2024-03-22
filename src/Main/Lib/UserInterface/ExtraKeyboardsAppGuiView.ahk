#Requires AutoHotkey v2.0

#Include <UserInterface\Main\ProfileEditing\ProfileRegionModel>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionView>
#Include <UserInterface\Main\ProfileEditing\ProfileRegionController>
#Include <UserInterface\Main\util\TreeViewMaker>
#Include <UserInterface\Main\util\ListViewMaker>

#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>


#Include <UserInterface\Main\Util\DomainSpecificGui>


; TODO everything should inherit from a base gui class which fixes the colors and such of all the guis.
Class ExtraKeyboardsAppGuiView extends DomainSpecificGui{

    settingsValuesListView := ""

    __New(){
        super.__New("+Resize +MinSize920x480", "Extra Keyboards App")
    }

    CreateMain(controller){
        this.controller := controller

        this.CreateProfileEditor()
        this.CreateTabs()
        
        ; Create gui in the top left corner of the screen
        this.Show("x0 y0")
    }

    CreateProfileEditor(){
        profileModel := ProfileRegionModel(this)
        profileView := ProfileRegionView()
        profileView.SubscribeToProfileChangedEvent(ObjBindMethod(this.controller, "HandleProfileChangedEvent"))
        profileController := ProfileRegionController(profileModel, profileView)
        profileController.CreateView()
    }

    CreateTabs(){
        Tab := this.AddTab3("yp+40 xm", ["Keyboards","Change Action Settings","Documentation"])
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
        keyboardLayoutChanger.createElementsForGui(this, this.controller.GetKeyboardLayerIdentifiers())
        
        listViewControl := ListViewMaker()
        listViewControl.CreateListView(this, ["KeyCombo","Action"])
        
        keyboardLayoutChanger.AddEventAction("ItemSelect", (*) => this.controller.ShowHotkeysForLayer(listViewControl, keyboardLayoutChanger.GetSelectionText()))
        listViewControl.AddEventAction("DoubleClick", ObjBindMethod(this.controller, "EditHotkey"))
    }

    CreateFunctionSettingsTab(){
        functionsNamesTreeView := TreeViewMaker()
        functionsNamesTreeView.createElementsForGui(this, this.controller.GetActionNames())
        
        this.settingsValuesListView := ListViewMaker()
        this.settingsValuesListView.CreateListView(this, ["Setting","Value"])
        
        functionsNamesTreeView.AddEventAction("ItemSelect", (*) => this.controller.ShowSettingsForAction(this.settingsValuesListView, functionsNamesTreeView.GetSelectionText()))
        this.settingsValuesListView.AddEventAction("DoubleClick", (*) => this.controller.HandleSettingClicked(this.settingsValuesListView.GetSelectionText()))
    }

    UpdateSettingsForAction(){
        this.settingsValuesListView.SetNewListViewItems(this.controller.GetSettings())
    }

    

    ; CreateTabGeneral(){
    ;     treeViewControl := TreeViewMaker()
    ;     treeViewControl.createElementsForGui(this, treeViewItems)
        
    ;     listViewMadeFromTreeView := ListViewMaker()
    ;     listViewMadeFromTreeView.CreateListView(this, listViewHeaders)
        
    ;     treeViewControl.AddEventAction("ItemSelect", (*) => treeViewItemClickedCallback(listViewMadeFromTreeView, treeViewControl.GetSelectionText()))
    ;     listViewMadeFromTreeView.AddEventAction("DoubleClick", listViewItemDoubleClickedCallback(treeViewControl))
    ; }

    CreateDocumentationTab(){
        this.Add("Edit", "r20")  ; r20 means 20 rows tall.
    }
}
