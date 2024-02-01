#Requires AutoHotkey v2.0

#Include ".\HotKeyConfigurationPopup.ahk"

class ListViewMaker{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    keyboardLayersInfoRegister := ""

    iniFileRead := ""

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
        hotkeyAction := listView.GetText(rowNumber, 2)

        popup := HotKeyConfigurationPopup()
        if (Type(data) == "HotkeysRegistry"){
            popup.CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyBuild, hotkeyAction)
            
        }
        else if (Type(data) == "KeyboardOverlayInfo"){
            popup.CreatePopupForKeyboardOverlayInfo(data, rowNumber)
        }

        ; if (rowNumber != 0){
    
            ; TODO should be set to on top, can not be not top ever...
            

    ;         iniFileSection := this.activeTreeViewItem
    ;         SaveButton.onEvent("Click", (*) => this.SaveButtonClickEvent(inputGui, rowNumber, inputKey, iniFileSection, inputValue))

    ;         CancelButton.onEvent("Click", (*) =>inputGui.Destroy())
            
    ;         DeleteButton.onEvent("Click", (*) => 

    ;             this.listView.Delete(rowNumber)
    ;             IniDelete(this.iniFile, iniFileSection, listViewFirstColum)
    ;             inputGui.Destroy()
    ;             ; TODO change this
    ;             Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
    ;         )
    }

    ; CreatePopupForHotkeyRegistry(data, rowNumber){
    ;     hotkeyBuild := this.listView.GetText(rowNumber, 1)
    ;     hotkeyAction := this.listView.GetText(rowNumber, 2)

    ;     inputGui := Gui()
    ;     inputGui.opt("+Resize +MinSize300x560 +AlwaysOnTop")
        
    ;     inputGui.Add("Text", "w300 h20", "Hotkey:")
    ;     inputKey := inputGui.Add("Edit", "xm w300 h20", hotkeyBuild)
        
    ;     currentHotkeyInfo := data.GetHotkey(hotkeyBuild)
    ;     if (currentHotkeyInfo.hotkeyIsObject()){
    ;         this.CreateHotKeyMaker(inputGui)
    ;     }
    ;     else{

    ;     }
    ;     inputGui.Add("Text", "xm w300 h20", "New Action For Hotkey:")
    ;     inputValue := inputGui.Add("Edit", "xm w300 h20", hotkeyAction)
        
    ;     SaveButton := inputGui.Add("Button", "w100 h20", "Save")
    ;     CancelButton := inputGui.Add("Button", "w100 h20", "Cancel")
    ;     DeleteButton := inputGui.Add("Button", "w100 h20", "Delete")
    ;     inputGui.Show()
    ; }

    ; CreateHotKeyMaker(guiToAddTo){
    ;     manually := guiToAddTo.Add("CheckBox", , "Manually create hotkey")
    ;     manually.onEvent("Click", (*) => {
    ;         if (manually.Value){
    ;             this.CreateHotKeyMakerManually(guiToAddTo)
    ;         }
    ;         else{
    ;             this.CreateHotKeyMakerFromGui(guiToAddTo)
    ;         }
    ;     })
    ;     guiToAddTo.Add("Hotkey", "vChosenHotkey")
    ;     guiToAddTo.Add("CheckBox", "vShipToBillingAddress", "Add win key as modifier")

    ; }

    SaveButtonClickEvent(inputGui, rowNumber, inputKey, iniFileSection, inputValue){
        ; TODO validate values, can not be empty!, can not be the same as another key, etc...
        if(rowNumber != 0){
            oldIniFileKey := this.listView.GetText(rowNumber)
            IniDelete this.iniFile, iniFileSection, oldIniFileKey
            this.listView.Modify(rowNumber, , inputKey.Value, inputValue.Value)
        }
        else{
            this.listView.Add(, inputKey.Value, inputValue.Value)

        }
        IniWrite(inputValue.Value, this.iniFile, iniFileSection, inputKey.Value)
        inputGui.Destroy()
        ; TODO change this
        Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
    }

    SetOnTop(identifier){
        WinSetAlwaysOnTop 1, identifier
    }


    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}