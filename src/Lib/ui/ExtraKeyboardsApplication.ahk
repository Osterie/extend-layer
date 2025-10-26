#Requires AutoHotkey v2.0

#Include <ui\profileediting\ProfileRegion>
#Include <ui\profileediting\ProfileRegionController>
#Include <ui\util\TreeViewMaker>
#Include <ui\util\ListViewMaker>
#Include <ui\MenuBar\ThemesMenu>
#Include <ui\MenuBar\SettingsMenu>

#Include <Updater\UpdateChecker>

#Include <Util\Formaters\HotkeyFormatter>
#Include <Util\NetworkUtils\NetworkChecker>

#Include <ui\updatesAndBackupsTab\UpdatesAndBackupsTab>
#Include <ui\documentationTab\DocumentationTab>

#Include <ui\Util\DomainSpecificGui>

#Include <Shared\Logger>

; TODO fix issue with multiple dialogs being possible to open at the same time

Class ExtraKeyboardsApplication extends DomainSpecificGui{

    Logger := Logger.getInstance()

    settingsValuesListView := ""
    hotkeysListView := ""

    DocumentationTab := ""

    THEMES_MENU_NAME := "&Themes"
    SUSPEND_SCRIPT_MENU_NAME := "Suspend S&cript"
    START_SCRIPT_MENU_NAME := "Start S&cript      " ; Spaces added so when Suspend script is clicked, it does not change size so much when the name changes.
    SETTINGS_MENU_NAME := "&Settings"
    ; Constructor for the ExtraKeyboardsApplication class
    __New(){
        super.__New("+MinSize920x480", "Extend Layer")
    }

    ; Creates the main gui for the application
    createMain(controller){
        this.controller := controller
        this.OnEvent('Close', (*) => this.destroy())
        this.CreateMenuBar()
        this.CreateProfileEditor()
        this.CreateTabs()
        
        ; Show gui in the top left corner of the screen
        this.Show()
    }

    CreateMenuBar(){

        MyMenuBar := MenuBar()
            
        _SettingsMenu := SettingsMenu((*) => this.UpdateGuiSettings())
        ThemeCategoriesMenu := ThemesMenu((*) => this.UpdateColorTheme())
        
        MyMenuBar.Add(this.THEMES_MENU_NAME, ThemeCategoriesMenu)
        ; TODO can do suspend differently. have custom suspend menu bar class
        MyMenuBar.Add(this.SETTINGS_MENU_NAME, _SettingsMenu)
        MyMenuBar.Add(this.SUSPEND_SCRIPT_MENU_NAME, (ItemName, ItemPos, MyMenuBar) => this.HandleSuspendClicked(ItemName, ItemPos, MyMenuBar))
        this.AddUpdateMenu(MyMenuBar)
        
        this.MenuBar := MyMenuBar

    }

    AddUpdateMenu(MyMenuBar){
        if (!NetworkChecker.isConnectedToInternet()){
            ; No internet connection, cannot check for updates.
            return
        }
        try{
            UpdateChecker_ := UpdateChecker()
            if (UpdateChecker_.updateAvailable()){
                MyMenuBar.Add("🔄Update available!", (ItemName, ItemPos, MyMenuBar) => this.HandleupdateAvailableClicked(ItemName, ItemPos, MyMenuBar))
            }
        }
        catch Error as e{
            ; Failed to check for updates, do not add update menu item.
            this.Logger.logError("Failed to check for updates: " A_LastError, "ExtraKeyboardsApplication.ahk", A_LineNumber)
            return
        }

    }

    HandleSuspendClicked(ItemName, ItemPos, MyMenuBar) {
        if (ItemName = this.SUSPEND_SCRIPT_MENU_NAME){
            MyMenuBar.Rename(ItemName, this.START_SCRIPT_MENU_NAME)
            Suspend(1)
        }
        else{
            MyMenuBar.Rename(ItemName, this.SUSPEND_SCRIPT_MENU_NAME)
            Suspend(0)
        }
    }

    HandleupdateAvailableClicked(ItemName, ItemPos, MyMenuBar) {
        this.controller.HandleupdateAvailableClicked()
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
        Tab := this.Add("Tab3", "yp+40 xm", ["Keyboards","Change Action Settings","Documentation", "Updates and Backups"])
        Tab.UseTab(1)
        this.CreateKeyboardsTab()

        Tab.UseTab(2)
        this.CreateFunctionSettingsTab()

        Tab.UseTab(3)
        this.CreateDocumentationTab()

        Tab.UseTab(4)
        this.createUpdatesAndBackupsTab()

        Tab.UseTab(0) ; subsequently-added controls will not belong to the tab control.
    }

    ; Creates the tab for the keyboard settings
    CreateKeyboardsTab(){
        keyboardLayoutChanger := TreeViewMaker()
        keyboardLayoutChanger.createElementsForGuiOld(this, this.controller.GetKeyboardLayerIdentifiers())
        
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
        this.ButtonForDeletingInfo.OnEvent("Click", (*) => this.controller.deleteHotkey(HotkeyFormatter.convertFromFriendlyName(this.hotkeysListView.GetSelectionText())))

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

    UpdateGuiSettings(){
        ; TODO in future, support more settings.
        this.controller.UpdateGuiSettings()
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
        functionsNamesTreeView.createElementsForGuiOld(this, this.controller.getActionGroupNames())
        
        this.settingsValuesListView := ListViewMaker()
        this.settingsValuesListView.CreateListView(this, "r20 w600 x+10 -multi",  ["ActionSetting","Value"])
        
        functionsNamesTreeView.AddEventAction("ItemSelect", (*) => this.controller.ShowSettingsForAction(functionsNamesTreeView.GetSelectionText()))
        this.settingsValuesListView.AddEventAction("DoubleClick", (*) => this.controller.HandleFunctionSettingClicked(this.settingsValuesListView.GetSelectionText()))
    }

    ; Updates the settings list view with the newest settings
    UpdateSettingsForActions(){
        this.settingsValuesListView.SetNewListViewItems(this.controller.getActionSettings())
    }

    ; CreateTabGeneral(){
    ;     treeViewControl := TreeViewMaker()
    ;     treeViewControl.createElementsForGuiOld(this, treeViewItems)
        
    ;     listViewMadeFromTreeView := ListViewMaker()
    ;     listViewMadeFromTreeView.CreateListView(this, listViewHeaders)
        
    ;     treeViewControl.AddEventAction("ItemSelect", (*) => treeViewItemClickedCallback(listViewMadeFromTreeView, treeViewControl.GetSelectionText()))
    ;     listViewMadeFromTreeView.AddEventAction("DoubleClick", listViewItemDoubleClickedCallback(treeViewControl))
    ; }

    ; Creates the tab for the documentation
    CreateDocumentationTab(){
        this.DocumentationTab := DocumentationTab()
        this.DocumentationTab.createTab(this)
    }

    createUpdatesAndBackupsTab(){
        UpdatesAndBackupsTab_ := UpdatesAndBackupsTab(this)
        UpdatesAndBackupsTab_.createTab()
    }

    destroy(){
        super.destroy()
        this.controller.DoDestroy()
    }
}
