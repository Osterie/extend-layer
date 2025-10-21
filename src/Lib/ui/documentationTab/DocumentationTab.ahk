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

class DocumentationTab{

    currentPage := ""
    guiToAddTo := ""

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
    

    TREE_VIEW_WIDTH := 200

    __New(guiToAddTo){
        this.guiToAddTo := guiToAddTo
    }

    ; Creates the documentation tab
    createTab(){
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

        treeView := treeViewMaker_.createElementsForGui(this.guiToAddTo, root, "Section w200 r20 w" . this.TREE_VIEW_WIDTH)

        showDocumentationButton := this.guiToAddTo.Add("Button", "ys+" 25 . " xs+" . this.TREE_VIEW_WIDTH + 5, "Show Documentation")
        showDocumentationButton.OnEvent("Click", (*) => this.handleDocumentationItemSelected(treeViewMaker_.GetSelectionText()))


        
        ; treeViewMaker_.AddEventAction("ItemSelect", (guiControlObject, selectedItemId) => this.handleDocumentationItemSelected(treeViewMaker_.GetSelectionText(), selectedItemId))
        ; treeViewMaker_.AddEventAction("ItemSelect", (guiControlObject, selectedItemId) => guiControlObject.Modify(selectedItemId, "+Expand"))
        treeViewMaker_.AddEventAction("Click", (guiControlObject, selectedItemId) => guiControlObject.Modify(selectedItemId, "+Expand"))
        ; treeViewMaker_.AddEventAction("LoseFocus", (guiControlObject, selectedItemId) => guiControlObject.Modify(selectedItemId, "+Expand"))

    }

    createBackupNode(){
        backups := TreeViewStructureNode(this.BACKUPS)


        ; creatingBackups := TreeViewStructureNode("Creating Backups")
        ; creatingBackups.addChild(TreeViewStructureNode("Old Version"))
        ; creatingBackups.addChild(TreeViewStructureNode("New Version"))
        ; creatingBackups.addChild(TreeViewStructureNode("Automatic Backups"))
        ; backups.addChild(creatingBackups)

        ; restoringBackups := TreeViewStructureNode("Restoring Backups")
        ; restoringBackups.addChild(TreeViewStructureNode("From File"))
        ; restoringBackups.addChild(TreeViewStructureNode("From Cloud"))
        ; backups.addChild(restoringBackups)

        ; managingBackups := TreeViewStructureNode("Managing Backups")
        ; managingBackups.addChild(TreeViewStructureNode("Deleting Old Backups"))
        ; managingBackups.addChild(TreeViewStructureNode("Backup Settings"))
        ; backups.addChild(managingBackups)

        return backups
    }

    createUpdatesNode(){
        updates := TreeViewStructureNode(this.UPDATES)

        ; checkingForUpdates := TreeViewStructureNode("Checking for Updates")
        ; checkingForUpdates.addChild(TreeViewStructureNode("Manual Check"))
        ; checkingForUpdates.addChild(TreeViewStructureNode("Automatic Check"))
        ; updates.addChild(checkingForUpdates)

        ; installingUpdates := TreeViewStructureNode("Installing Updates")
        ; installingUpdates.addChild(TreeViewStructureNode("From File"))
        ; installingUpdates.addChild(TreeViewStructureNode("From Internet"))
        ; updates.addChild(installingUpdates)

        ; managingUpdates := TreeViewStructureNode("Managing Updates")
        ; managingUpdates.addChild(TreeViewStructureNode("Update Settings"))
        ; managingUpdates.addChild(TreeViewStructureNode("Update History"))
        ; updates.addChild(managingUpdates)

        return updates
    }

    createProfilesNode(){
        profiles := TreeViewStructureNode(this.PROFILES)

        ; editing := TreeViewStructureNode("Editing")
        ; editing.addChild(TreeViewStructureNode("Changing Key Mappings"))
        ; editing.addChild(TreeViewStructureNode("Modifying Action Settings"))
        ; profiles.addChild(editing)

        ; adding := TreeViewStructureNode("Adding")
        ; adding.addChild(TreeViewStructureNode("New Profile"))
        ; adding.addChild(TreeViewStructureNode("Importing Profile"))
        ; profiles.addChild(adding)

        ; managing := TreeViewStructureNode("Managing")
        ; managing.addChild(TreeViewStructureNode("Deleting Profile"))
        ; managing.addChild(TreeViewStructureNode("Renaming Profile"))
        ; managing.addChild(TreeViewStructureNode("Profile Settings"))
        ; profiles.addChild(managing)

        return profiles
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

    createActionSettingsNode(){
        actionSettings := TreeViewStructureNode(this.ACTION_SETTINGS)
        return actionSettings
    }

    createKeyboardNavigationNode(){
        keyboardNavigation := TreeViewStructureNode(this.KEYBOARD_NAVIGATION)
        return keyboardNavigation
    }

    createKeyboardsNode(){
        keyboards := TreeViewStructureNode(this.KEYBOARD_LAYERS)
        return keyboards
    }

    createHotkeyNode(){
        hotkeys := TreeViewStructureNode(this.HOTKEYS)

        addingEditingHotkey := TreeViewStructureNode(this.ADD_EDIT_HOTKEY)
        hotkeys.addChild(addingEditingHotkey)

        return hotkeys
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

            default:
                MsgBox("No documentation.")
        }
    }
}

; TODO documentation tab
; 	- Popups?
; 	- Use tree structure? (TreeViewMaker/ListViewMaker class)
; 	- Tree sturcture with dropdowns? so click for example Backups and it will show many more submenus for Backup related docs. clicking one of the submenues will open to the right the documentation page for vthat.
	
; 	- List on the left, which when clicked shows a documentation page for the clicked feature. Can have an icon for each feature, like PowerToys has. Can use gifs/images to help user understand featuer

; What to have documentation for?
; 	- Backups
; 	- Updates
; 	- Profiles (editing, adding, importing, exporting, the different preset profiles)

; 	MENU BAR
; 	- Settings (currently only Stop script on GUI close.
; 	- Suspend script/ Start script, what does it do.
; 	- Themes. (are sorted into three categories, choosing a category and then clicking a theme name will change the color theme of the Extend Layer GUI, and persists, mention this yada yada.


; 	ACTION SETTINGS
; 	Perhaps action settings should be refactored to be ish like the doucmentation tab will be, like how powertoys is.   Instead of inputs, can have radio buttons, buttons and other inputs for the different settings, and different depending on what type is excpected (int, string, boolean, URL, img, etc. )

; 	KEYBOARDS
; 	- GlobalLayer-Hotkeys. What is GlobalLayer?
; 	- NormalLayer. What is NormalLayer?
; 	- SecondaryLayer. What is SecondaryLayer?
; 	- TertiaryLayer. What is TertiaryLayer?

; 	HOTKEYS
; 	- Adding/Editing a hotkey. (set hotkey, advanced/ not advanced mode. Set action, setting action or new key...)
	

; General Documentation page:
; - Title of the clicked page, for example "Global Layer"
; - An image(optional) of that feature or something related to id. Image can have an under title
; - Paragraphs with titles.
; - Some features can have general components which can be reused between them, but which not all pages might need. For example a paragraph with image component.

