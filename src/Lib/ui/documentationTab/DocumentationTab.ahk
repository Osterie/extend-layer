#Requires AutoHotkey v2.0

#Include <ui\util\TreeViewMaker>
#Include <ui\util\TreeViewStructureNode>

#Include <ui\documentationTab\popups\BackupPopup>
#Include <ui\documentationTab\popups\UpdatePopup>
#Include <ui\documentationTab\popups\ProfilePopup>
#Include <ui\documentationTab\popups\menubar\MenuBarPopup>
#Include <ui\documentationTab\popups\menubar\MenuBarSettingsPopup>
#Include <ui\documentationTab\popups\menubar\MenuBarSuspendingPopup>
#Include <ui\documentationTab\popups\menubar\MenuBarThemesPopup>
#Include <ui\documentationTab\popups\KeyboardLayersPopup>
#Include <ui\documentationTab\popups\HotkeysPopup>
#Include <ui\documentationTab\popups\AddEditHotkeyPopup>
#Include <ui\documentationTab\popups\ActionSettingsPopup>
#Include <ui\documentationTab\popups\KeyboardNavigationPopup>
#Include <ui\documentationTab\popups\LaunchingTheScriptPopup>

class DocumentationTab{

    PROFILES := "Profiles"
    KEYBOARD_LAYERS := "Keyboard Layers"
    HOTKEYS := "Hotkeys"
        ADD_EDIT_HOTKEY := "Add/Edit Hotkey"
    ACTION_SETTINGS := "Action Settings"
    KEYBOARD_NAVIGATION := "Keyboard Navigation"
    MENU_BAR := "Menubar"
        MENU_BAR_THEMES := "Themes"
        MENU_BAR_SETTINGS := "Settings"
        MENU_BAR_SUSPENDING_SCRIPT := "Suspending Script"
    BACKUPS := "Backups"
    UPDATES := "Updates"

    LAUNCHING_THE_SCRIPT := "Launching the Script"

    TREE_VIEW_WIDTH := 200

    __New(){
    }

    ; Creates the documentation tab
    createTab(guiToAddTo){
        treeViewMaker_ := TreeViewMaker()

        root := []
        root.Push(this.createProfilesNode())
        root.Push(this.createKeyboardsNode())
        root.Push(this.createHotkeyNode())
        root.Push(this.createActionSettingsNode())
        root.Push(this.createKeyboardNavigationNode())
        root.Push(this.createMenuBarNode())
        root.Push(this.createBackupNode())
        root.Push(this.createUpdatesNode())
        root.Push(this.createLaunchingTheScriptNode())

        documentationTreeView := treeViewMaker_.createElementsForGui(guiToAddTo, root, "Section w200 r20 w" . this.TREE_VIEW_WIDTH)

        selectedDocumentationTitle := guiToAddTo.Add("Text", "w400 h25 ys", "")
        selectedDocumentationTitle.setFont("s16")

        showDocumentationButton := guiToAddTo.Add("Button", "w200 h100 ys+" 25 . " xs+" . this.TREE_VIEW_WIDTH + 5, "Show &Documentation")
        showDocumentationButton.setFont("s16")
        showDocumentationButton.OnEvent("Click", (*) => this.handleDocumentationItemSelected(treeViewMaker_.GetSelectionText()))

        treeViewMaker_.AddEventAction("ItemSelect", (*) => selectedDocumentationTitle.value := treeViewMaker_.GetSelectionText())
        treeViewMaker_.AddEventAction("Click", (guiControlObject, selectedItemId) => guiControlObject.Modify(selectedItemId, "+Expand"))
    }

    createProfilesNode(){
        return TreeViewStructureNode(this.PROFILES)
    }

    createKeyboardsNode(){
        return TreeViewStructureNode(this.KEYBOARD_LAYERS)
    }

    createHotkeyNode(){
        hotkeys := TreeViewStructureNode(this.HOTKEYS)
        
        addingEditingHotkey := TreeViewStructureNode(this.ADD_EDIT_HOTKEY)
        hotkeys.addChild(addingEditingHotkey)
        
        return hotkeys
    }
    
    createActionSettingsNode(){
        return TreeViewStructureNode(this.ACTION_SETTINGS)
    }

    createKeyboardNavigationNode(){
        return TreeViewStructureNode(this.KEYBOARD_NAVIGATION)
    }

    createMenuBarNode(){
        menubar := TreeViewStructureNode(this.MENU_BAR)

        themes := TreeViewStructureNode(this.MENU_BAR_THEMES)
        menubar.addChild(themes)
        
        settings := TreeViewStructureNode(this.MENU_BAR_SETTINGS)
        menubar.addChild(settings)
        
        suspending := TreeViewStructureNode(this.MENU_BAR_SUSPENDING_SCRIPT)
        menubar.addChild(suspending)

        return menubar
    }

    createBackupNode(){
        return TreeViewStructureNode(this.BACKUPS)
    }

    createUpdatesNode(){
        return TreeViewStructureNode(this.UPDATES)
    }

    createLaunchingTheScriptNode(){
        return TreeViewStructureNode(this.LAUNCHING_THE_SCRIPT)
    }

    handleDocumentationItemSelected(selectedItemText){
        switch selectedItemText {
            case this.PROFILES:
                ProfilePopup()

            case this.KEYBOARD_LAYERS:
                KeyboardLayersPopup()

            case this.HOTKEYS:
                HotkeysPopup()

            ; HOTKEYS SUB MENU 
            case this.ADD_EDIT_HOTKEY:
                AddEditHotkeyPopup()

            case this.ACTION_SETTINGS:
                ActionSettingsPopup()

            case this.KEYBOARD_NAVIGATION:
                KeyboardNavigationPopup()

            case this.MENU_BAR:
                MenuBarPopup()

            ; MENU BAR SUB MENU
            case this.MENU_BAR_SETTINGS:
                MenuBarSettingsPopup()

            ; MENU BAR SUB MENU
            case this.MENU_BAR_SUSPENDING_SCRIPT:
                MenuBarSuspendingPopup()

            ; MENU BAR SUB MENU
            case this.MENU_BAR_THEMES:
                MenuBarThemesPopup()

            case this.BACKUPS:
                BackupPopup()

            case this.UPDATES:
                UpdatePopup()

            case this.LAUNCHING_THE_SCRIPT:
                LaunchingTheScriptPopup()

            default:
                MsgBox("No documentation.")
        }
    }
}