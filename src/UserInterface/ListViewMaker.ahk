#Requires AutoHotkey v2.0

#Include ".\HotKeyConfigurationPopup.ahk"

class ListViewMaker{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    keyboardLayersInfoRegister := ""

    iniFileRead := ""

    hotkeySavedEvent := ""

    popupForConfiguringHotkey := ""

    newHotKey := ""

    __New(jsonObject, jsonFileContents, keyboardLayersInfoRegister){
        this.jsonObject := jsonObject
        this.jsonFileContents := jsonFileContents
        this.keyboardLayersInfoRegister := keyboardLayersInfoRegister
    }

    CreateListView(guiObject, columnNames){
        
        this.listView := guiObject.Add("ListView", "grid r20 w600 x+10", columnNames)

        ; Create an ImageList so that the ListView can display some icons:
        ; ImageListID1 := IL_Create(10)
        ; ImageListID2 := IL_Create(10, 10, true)  ; A list of large icons to go with the small ones.

        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        Loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)


        ; Attach the ImageLists to the ListView so that it can later display the icons:
        this.listView.SetImageList(ImageListID)
        this.listView.Opt("Report")
        ; this.listView.SetImageList(ImageListID2)
        
        this.listView.ModifyCol(1, 200)
        ; this.listView.ModifyCol(2, 200)

        ListViewDoubleClickEvent := ObjBindMethod(this, "ListViewDoubleClickEvent")
        this.listView.OnEvent("DoubleClick", ListViewDoubleClickEvent)
        
    }

    SetNewListViewItemsByIniFileSection(treeViewGui, selectedTreeViewItem){
        if (treeViewGui is Gui.TreeView){
            this.activeTreeViewItem := treeViewGui.GetText(selectedTreeViewItem)
            itemsToShowForListView := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.activeTreeViewItem)

            this.SetNewListViewItems(itemsToShowForListView.getKeyPairValuesToString())
        }
        else{
            ; TODO, would need this if this class should be general. Among other stuff...
        }
    }


    ; Takes a two dimensional array, items, and adds each item to the listView
    SetNewListViewItems(items){
        this.listView.Delete()
        Loop items.Length{
            this.listView.Add("Icon3", items[A_index]*)
        }
    }

    ; Takes item which should be an array with the same length as the number of columns
    SetListViewItem(item){
        this.listView.Add(, item*)        
    }

    ListViewDoubleClickEvent(listView, rowNumber){

        data := this.keyboardLayersInfoRegister.GetRegistryByLayerIdentifier(this.activeTreeViewItem)

        hotkeyBuild := listView.GetText(rowNumber, 1)
        this.newHotkey := hotkeyBuild
        hotkeyAction := listView.GetText(rowNumber, 2)

        this.popupForConfiguringHotkey := HotKeyConfigurationPopup()
        if (Type(data) == "HotkeysRegistry"){
            this.popupForConfiguringHotkey.CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyBuild, hotkeyAction)
            
        }
        else if (Type(data) == "KeyboardOverlayInfo"){
            this.popupForConfiguringHotkey.CreatePopupForKeyboardOverlayInfo(data, rowNumber)
        }

        saveButtonEvent := ObjBindMethod(this, "popupSaveButtonClickEvent")
        this.popupForConfiguringHotkey.addSaveButtonClickedEvent(saveButtonEvent)
        this.popupForConfiguringHotkey.addSaveButtonClickedEvent(this.hotkeySavedEvent)


    }

    popupSaveButtonClickEvent(*){
        this.newHotkey := this.popupForConfiguringHotkey.getHotkeyFormatted()
        if (this.newHotkey = ""){
            ; Delete that shit
        }
        else {
            ; Set that shit
        }

        ; msgbox(this.newHotkey)
    }

    setHotkeySavedEvent(event){
        this.hotkeySavedEvent := event
    }

    getNewHotkey(){
        return this.newHotKey
    }

    SetOnTop(identifier){
        WinSetAlwaysOnTop 1, identifier
    }


    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}