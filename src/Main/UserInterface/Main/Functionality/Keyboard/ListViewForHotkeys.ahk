#Requires AutoHotkey v2.0

#Include ".\KeyboardEditing\HotKeyConfigurationPopup.ahk"

class ListViewForHotkeys{

    listView := ""
    activeTreeViewItem := ""

    keyboardLayersInfoRegister := ""

    activeObjectsRegistry := ""

    hotkeySavedEvent := ""

    popupForConfiguringHotkey := ""

    newHotKey := ""
    originalHotkey := ""

    newAction := ""
    
    arrayOfKeyNames := []

    __New(activeObjectsRegistry, jsonFileContents, keyboardLayersInfoRegister, arrayOfKeyNames){
        this.activeObjectsRegistry := activeObjectsRegistry
        this.jsonFileContents := jsonFileContents
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
        this.arrayOfKeyNames := arrayOfKeyNames
    }

    CreateListView(guiObject, columnNames){
        
        this.listView := guiObject.Add("ListView", "r20 w600 x+10", columnNames)

        ; Attach the ImageLists to the ListView so that it can later display the icons:
        this.listView.SetImageList(this.getImageList())
        
        this.listView.ModifyCol(1, 200)
        this.listView.ModifyCol(2, 397)

        ; this.listView.OnEvent("DoubleClick", ObjBindMethod(this, "ListViewDoubleClickEvent"))
    }

    getImageList(){
        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        Loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)
        return ImageListID
    }

    ; Takes a two dimensional array, items, and adds each item to the listView
    SetNewListViewItems(items){
        this.listView.Delete()
        Loop items.Length{
            this.listView.Add("Icon3", items[A_index]*)
        }
    }

    ListViewDoubleClickEvent(listView, rowNumber){
        ; TODO error here
        data := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.activeTreeViewItem)
        
        hotkeyBuild := listView.GetText(rowNumber, 1)
        this.newHotkey := hotkeyBuild
        this.originalHotkey := hotkeyBuild
        hotkeyAction := listView.GetText(rowNumber, 2)

        this.popupForConfiguringHotkey := HotKeyConfigurationPopup(this.activeObjectsRegistry, this.arrayOfKeyNames)
        if (Type(data) == "HotkeysRegistry"){
            this.popupForConfiguringHotkey.CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyBuild, hotkeyAction)
            
        }
        else if (Type(data) == "KeyboardOverlayInfo"){
            this.popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo(data, rowNumber)
        }

        saveButtonEvent := ObjBindMethod(this, "popupSaveButtonClickEvent")
        this.popupForConfiguringHotkey.addSaveButtonClickedEvent(saveButtonEvent)
        this.popupForConfiguringHotkey.addSaveButtonClickedEvent(this.hotkeySavedEvent)

        cancelButtonEvent := ObjBindMethod(this, "popupCancelButtonClickEvent")
        this.popupForConfiguringHotkey.addCancelButtonClickedEvent(cancelButtonEvent)


    }

    popupSaveButtonClickEvent(*){
        this.newHotkey := this.popupForConfiguringHotkey.getHotkeyFormatted()
        this.newAction := this.popupForConfiguringHotkey.getAction()
        if (this.newHotkey = ""){
            ; TODO implement
            ; Delete that shit
        }
        else {
            ; Set that shit
        }

    }

    popupCancelButtonClickEvent(*){
        this.popupForConfiguringHotkey.Destroy()
    }

    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}