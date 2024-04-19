#Requires AutoHotkey v2.0

#Include <ui\Main\profileediting\ProfileRegion>
#Include <ui\Main\profileediting\ProfileRegionController>
#Include <ui\Main\util\TreeViewMaker>
#Include <ui\Main\util\ListViewMaker>
#Include <ui\Main\MenuBar\ThemesMenu>

#Include <Util\HotkeyFormatConverter>
#Include <Util\MetaInfo\MetaInfoStorage\Themes\logic\Themes>
#Include <Util\MetaInfo\MetaInfoStorage\KeyboardLayouts\KeyboardsInfo\Hotkeys\entity\HotKeyInfo>

#Include <ui\Main\Util\DomainSpecificGui>

; TODO fix issue with multiple dialogs being possible to open at the same time

Class ExtraKeyboardsAppGui extends DomainSpecificGui{

    settingsValuesListView := ""
    hotkeysListView := ""

    ; Constructor for the ExtraKeyboardsAppGui class
    __New(){
        super.__New("+MinSize920x480", "Extra Keyboards App")
    }

    ; Creates the main gui for the application
    CreateMain(controller){
        this.controller := controller
        this.CreateMenuBar()
        this.CreateProfileEditor()
        this.CreateTabs()
        
        ; ; Show gui in the top left corner of the screen
        this.Show()
    }

    CreateMenuBar(){

        MyMenuBar := MenuBar()
            
        ThemeCategoriesMenu := ThemesMenu((*) => this.UpdateColorTheme())

        
        MyMenuBar.Add("&Themes", ThemeCategoriesMenu)
        MyMenuBar.Add("&Suspend Script", (ItemName, ItemPos, MyMenuBar) => HandleSuspendClicked(ItemName, ItemPos, MyMenuBar))
        this.MenuBar := MyMenuBar


        HandleSuspendClicked(ItemName, ItemPos, MyMenuBar) {
            if (ItemName = "&Suspend Script"){
                MyMenuBar.Rename(ItemName, "&Start Script")
                Suspend(1)
            }
            else{
                MyMenuBar.Rename(ItemName, "&Suspend Script")
                Suspend(0)
            }

        }
    }

    ; Creates the region for profile editing
    CreateProfileEditor(){
        profileView := ProfileRegion()
        profileView.SubscribeToProfileChangedEvent(ObjBindMethod(this.controller, "HandleProfileChangedEvent"))
        profileController := ProfileRegionController(profileView)
        profileController.CreateView(this)
    }

    ; Creates the tabs for the application
    CreateTabs(){
        Tab := this.Add("Tab3", "yp+40 xm", ["&Keyboards","&Change Action Settings","Documentation"])
        Tab.UseTab(1)
        this.CreateKeyboardsTab()

        Tab.UseTab(2)
        this.CreateFunctionSettingsTab()

        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(0) ; subsequently-added controls will not belong to the tab control.
    }

    ; Creates the tab for the keyboard settings
    CreateKeyboardsTab(){
        keyboardLayoutChanger := TreeViewMaker()
        keyboardLayoutChanger.createElementsForGui(this, this.controller.GetKeyboardLayerIdentifiers())
        
        this.hotkeysListView := ListViewMaker()
        this.hotkeysListView.CreateListView(this, "r20 w600 x+10 -multi" , ["KeyCombo","Action"])
        
        this.CreateConfigurationButtons()

        this.hotkeysListView.AddEventAction("ItemSelect", (listView, rowSelected, ColumnSelected) => this.ChangeConfigurationButtonsStatus(rowSelected))
        keyboardLayoutChanger.AddEventAction("ItemSelect", (*) => this.controller.DoLayerSelected(keyboardLayoutChanger.GetSelectionText()))
        this.hotkeysListView.AddEventAction("DoubleClick", (listView, rowClicked) => this.controller.DoAddOrEditHotkey(listView.GetText(rowClicked, 1)))

    }

    ; Creates the buttons for adding/editing/deleting a hotkey.
    CreateConfigurationButtons(){
        
        this.ButtonForAddingInfo := this.Add("Button", "", "Add")
        this.ButtonForAddingInfo.OnEvent("Click", (*) => this.controller.DoAddOrEditHotkey())
        this.ButtonForAddingInfo.Opt("Hidden1")

        this.ButtonForEditingInfo := this.Add("Button", " Yp", "Edit")
        this.ButtonForEditingInfo.OnEvent("Click", (*) => this.controller.DoAddOrEditHotkey(this.hotkeysListView.GetSelectionText()))
        this.ButtonForEditingInfo.Opt("Hidden1")

        this.ButtonForDeletingInfo := this.Add("Button", "Yp", "Delete")
        this.ButtonForDeletingInfo.OnEvent("Click", (*) => this.controller.DeleteHotkey(HotkeyFormatConverter.convertFromFriendlyName(this.hotkeysListView.GetSelectionText())))

        this.ButtonForDeletingInfo.Opt("Hidden1")

    }

    ; Disables the buttons for editing/deleting a hotkey.
    ; Shows the buttons for adding/editing/deleting a hotkey if a layer is selected.
    ; Else hides the buttons for adding/editing/deleting a hotkey.
    UpdateConfigurationButtons(){
        this.DisableConfigurationButtons()

        if (this.controller.GetCurrentLayer() == ""){
            this.ButtonForAddingInfo.Opt("Hidden1")
            this.ButtonForEditingInfo.Opt("Hidden1")
            this.ButtonForDeletingInfo.Opt("Hidden1")
        } 
        else {
            this.ButtonForAddingInfo.Opt("Hidden0")
            this.ButtonForEditingInfo.Opt("Hidden0")
            this.ButtonForDeletingInfo.Opt("Hidden0")
        }
    }

    ; If the focues row is 0 (a row without values) the edit and delete buttons are disabled,
    ; Since they should only be active when a row with values is selected.
    ; If the row is not 0, the edit and delete buttons are enabled.
    ChangeConfigurationButtonsStatus(rowFocused){
        if (rowFocused = 0){
            this.DisableConfigurationButtons()
        }
        else{
            if (this.hotkeysListView.GetCount() = 0){
                this.DisableConfigurationButtons()
            }
            else{
                this.EnableConfigurationButtons()
            }
        }
    }

    ; Enables the edit/delete button, and makes the edit button the default button.
    ; Meaning that it is pressed when the user presses enter
    EnableConfigurationButtons(){
        this.ButtonForAddingInfo.Opt("-Default")
        this.ButtonForEditingInfo.Enabled := true
        this.ButtonForEditingInfo.Opt("+Default")
        this.ButtonForDeletingInfo.Enabled := true
    }

    ; Disables the edit/delete button, and makes the add button the default button.
    ; Meaning that it is pressed when the user presses enter
    DisableConfigurationButtons(){
        this.ButtonForAddingInfo.Opt("+Default")
        this.ButtonForEditingInfo.Enabled := false
        this.ButtonForEditingInfo.Opt("-Default")
        this.ButtonForDeletingInfo.Enabled := false
    }

    ; Updates the hotkeys list view with the newest hotkeys
    UpdateHotkeys(){
        this.hotkeysListView.SetNewListViewItems(this.controller.GetHotkeys())
    }

    ; Creates the tab for the action settings
    CreateFunctionSettingsTab(){
        functionsNamesTreeView := TreeViewMaker()
        functionsNamesTreeView.createElementsForGui(this, this.controller.GetActionNames())
        
        this.settingsValuesListView := ListViewMaker()
        this.settingsValuesListView.CreateListView(this, "r20 w600 x+10 -multi",  ["Setting","Value"])
        
        functionsNamesTreeView.AddEventAction("ItemSelect", (*) => this.controller.ShowSettingsForAction(functionsNamesTreeView.GetSelectionText()))
        this.settingsValuesListView.AddEventAction("DoubleClick", (*) => this.controller.HandleSettingClicked(this.settingsValuesListView.GetSelectionText()))
    }

    ; Updates the settings list view with the newest settings
    UpdateSettingsForActions(){
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

    ; Creates the tab for the documentation
    CreateDocumentationTab(){
        this.Add("Edit", "r20")  ; r20 means 20 rows tall.
    }
}
