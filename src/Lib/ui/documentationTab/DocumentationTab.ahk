#Requires AutoHotkey v2.0

#Include <ui\util\TreeViewMaker>
#Include <ui\util\TreeViewStructureNode>
#Include <ui\documentationTab\backups\BackupPopup>

class DocumentationTab{

    currentPage := ""
    guiToAddTo := ""

    BACKUPS := "Backups"

    TREE_VIEW_WIDTH := 200

    __New(guiToAddTo){
        this.guiToAddTo := guiToAddTo
    }

    ; Creates the documentation tab
    createTab(){
        treeViewMaker_ := TreeViewMaker()


        root := []
        root.Push(this.createBackupNode())
        root.Push(this.createUpdatesNode())
        root.Push(this.createProfilesNode())
        root.Push(this.createMenuBarNode())
        root.Push(this.createActionSettingsNode())
        root.Push(this.createKeyboardsNode())
        root.Push(this.createHotkeyNode())

        treeView := treeViewMaker_.createElementsForGui(this.guiToAddTo, root, "Section w200 r20 w" . this.TREE_VIEW_WIDTH)

        showDocumentationButton := this.guiToAddTo.Add("Button", "ys+" 25 . " xs+" . this.TREE_VIEW_WIDTH + 5, "This is a button")
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
        updates := TreeViewStructureNode("Updates")

        checkingForUpdates := TreeViewStructureNode("Checking for Updates")
        checkingForUpdates.addChild(TreeViewStructureNode("Manual Check"))
        checkingForUpdates.addChild(TreeViewStructureNode("Automatic Check"))
        updates.addChild(checkingForUpdates)

        installingUpdates := TreeViewStructureNode("Installing Updates")
        installingUpdates.addChild(TreeViewStructureNode("From File"))
        installingUpdates.addChild(TreeViewStructureNode("From Internet"))
        updates.addChild(installingUpdates)

        managingUpdates := TreeViewStructureNode("Managing Updates")
        managingUpdates.addChild(TreeViewStructureNode("Update Settings"))
        managingUpdates.addChild(TreeViewStructureNode("Update History"))
        updates.addChild(managingUpdates)

        return updates
    }

    createProfilesNode(){
        profiles := TreeViewStructureNode("Profiles")

        editing := TreeViewStructureNode("Editing")
        editing.addChild(TreeViewStructureNode("Changing Key Mappings"))
        editing.addChild(TreeViewStructureNode("Modifying Action Settings"))
        profiles.addChild(editing)

        adding := TreeViewStructureNode("Adding")
        adding.addChild(TreeViewStructureNode("New Profile"))
        adding.addChild(TreeViewStructureNode("Importing Profile"))
        profiles.addChild(adding)

        managing := TreeViewStructureNode("Managing")
        managing.addChild(TreeViewStructureNode("Deleting Profile"))
        managing.addChild(TreeViewStructureNode("Renaming Profile"))
        managing.addChild(TreeViewStructureNode("Profile Settings"))
        profiles.addChild(managing)

        return profiles
    }

    createMenuBarNode(){
        menubar := TreeViewStructureNode("Menubar")

        settings := TreeViewStructureNode("Settings")
        settings.addChild(TreeViewStructureNode("General Settings"))
        settings.addChild(TreeViewStructureNode("Profile Settings"))
        settings.addChild(TreeViewStructureNode("Backup Settings"))
        menubar.addChild(settings)

        suspending := TreeViewStructureNode("Suspending Script")
        suspending.addChild(TreeViewStructureNode("When to Suspend"))
        suspending.addChild(TreeViewStructureNode("Resuming from Suspend"))
        menubar.addChild(suspending)

        themes := TreeViewStructureNode("Themes")
        themes.addChild(TreeViewStructureNode("Changing Theme"))
        themes.addChild(TreeViewStructureNode("Custom Themes"))
        menubar.addChild(themes)

        return menubar
    }

    createActionSettingsNode(){
        actionSettings := TreeViewStructureNode("Action Settings")

        return actionSettings
    }

    createKeyboardsNode(){
        keyboards := TreeViewStructureNode("Keyboards")

        globalLayer := TreeViewStructureNode("Global Layer")
        globalLayer.addChild(TreeViewStructureNode("What is Global Layer?"))
        globalLayer.addChild(TreeViewStructureNode("Setting Global Layer Hotkeys"))
        keyboards.addChild(globalLayer)

        normalLayer := TreeViewStructureNode("Normal Layer")
        normalLayer.addChild(TreeViewStructureNode("What is Normal Layer?"))
        normalLayer.addChild(TreeViewStructureNode("Setting Normal Layer Hotkeys"))
        keyboards.addChild(normalLayer)

        secondaryLayer := TreeViewStructureNode("Secondary Layer")
        secondaryLayer.addChild(TreeViewStructureNode("What is Secondary Layer?"))
        secondaryLayer.addChild(TreeViewStructureNode("Setting Secondary Layer Hotkeys"))
        keyboards.addChild(secondaryLayer)

        tertiaryLayer := TreeViewStructureNode("Tertiary Layer")
        tertiaryLayer.addChild(TreeViewStructureNode("What is Tertiary Layer?"))
        tertiaryLayer.addChild(TreeViewStructureNode("Setting Tertiary Layer Hotkeys"))
        keyboards.addChild(tertiaryLayer)

        return keyboards
    }

    createHotkeyNode(){
        hotkeys := TreeViewStructureNode("Hotkeys")

        addingEditing := TreeViewStructureNode("Adding/Editing a Hotkey")
        addingEditing.addChild(TreeViewStructureNode("Set Hotkey"))
        addingEditing.addChild(TreeViewStructureNode("Advanced/Simple Mode"))
        addingEditing.addChild(TreeViewStructureNode("Set Action"))
        addingEditing.addChild(TreeViewStructureNode("Setting Action or New Key"))
        hotkeys.addChild(addingEditing)

        managingHotkeys := TreeViewStructureNode("Managing Hotkeys")
        managingHotkeys.addChild(TreeViewStructureNode("Deleting Hotkey"))
        managingHotkeys.addChild(TreeViewStructureNode("Hotkey Settings"))
        hotkeys.addChild(managingHotkeys)

        return hotkeys
    }

    handleDocumentationItemSelected(selectedItemText){
        ; Here you would load and display the documentation related to selectedItemText
        ; MsgBox("Selected documentation item: " . selectedItemText)
        
        ; this.guiToAddTo.Opt("+LastFound")
        ; WinRedraw(this.guiToAddTo)
        switch selectedItemText {
            case this.BACKUPS:
                currentPage := BackupPopup()

                
            default:
                currentPage := ""
                
        }
    }
}



; TODO edit profiles and add profiles gui sizes are pretty different, i think they use different font sizes.
; TODO change height of edit profiels dialog.

; TODO can create profiles which are just another keyboard layout, colemak, dvorak and such.

; TODO image for tray icon, custom right click options for tray icon? 

; TODO create icon for Extend Layer, can use one of the cool graphical images. or create new from graphical images creator.
; those images are on the dell school computer...
 
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

