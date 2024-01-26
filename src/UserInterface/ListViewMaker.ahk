#Requires AutoHotkey v2.0

class ListViewMaker{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    iniFileRead := ""

    __New(jsonObject, jsonFileContents){
        this.jsonObject := jsonObject
        this.jsonFileContents := jsonFileContents
    }

    CreateListView(guiObject, columnNames){
        
        this.listView := guiObject.Add("ListView", "grid r20 w400 x+10", columnNames)
        
        this.listView.ModifyCol(1, 200)
        this.listView.ModifyCol(2, 200)

        ; ListViewDoubleClickEvent := ObjBindMethod(this, "ListViewDoubleClickEvent")
        ; this.listView.OnEvent("DoubleClick", ListViewDoubleClickEvent)
        
    }

    SetNewListViewItemsByIniFileSection(treeViewGui, selectedTreeViewItem){
        if (treeViewGui is Gui.TreeView){
            this.activeTreeViewItem := treeViewGui.GetText(selectedTreeViewItem)
            msgbox(this.activeTreeViewItem)
            msgbox(this.jsonFileContents[this.activeTreeViewItem])
            this.SetNewListViewItems([["key1", "value1"], ["key2", "value2"]])
        }
        else{
            ; TODO, would need this if this class should be general. Among other stuff...
        }
    }


    ; Takes a two dimensional array, items, and adds each item to the listView
    SetNewListViewItems(items){
        
        this.listView.Delete()
        msgbox(items.Length)
        Loop items.Length{
            this.listView.Add(, items[A_index]*)
        }
    }

    ; Takes item which should be an array with the same length as the number of columns
    SetListViewItem(item){
        this.listView.Add(, item*)        
    }

    ListViewDoubleClickEvent(listView, rowNumber){

        originalFirstColumnValue := this.listView.GetText(rowNumber, 1)
        originalSecondColumnValue := this.listView.GetText(rowNumber, 2)

        listViewFirstColum := this.listView.GetText(rowNumber, 1)
        listViewSecondColum := this.listView.GetText(rowNumber, 2)

        ; if (rowNumber != 0){
    
            ; TODO should be set to on top, can not be not top ever...
            
            inputGui := Gui()
            inputGui.opt("+Resize +MinSize300x560 +AlwaysOnTop")
            
            inputGui.Add("Text", "w300 h20", "Value From Key:")
            inputKey := inputGui.Add("Edit", "xm w300 h20", listViewFirstColum)
            
            inputGui.Add("Text", "xm w300 h20", "Value New Key Action:")
            inputValue := inputGui.Add("Edit", "xm w300 h20", listViewSecondColum)
            
            SaveButton := inputGui.Add("Button", "w100 h20", "Save")
            CancelButton := inputGui.Add("Button", "w100 h20", "Cancel")
            DeleteButton := inputGui.Add("Button", "w100 h20", "Delete")

            inputGui.Show()

            iniFileSection := this.activeTreeViewItem
            SaveButton.onEvent("Click", (*) => this.SaveButtonClickEvent(inputGui, rowNumber, inputKey, iniFileSection, inputValue))

            CancelButton.onEvent("Click", (*) =>inputGui.Destroy())
            
            DeleteButton.onEvent("Click", (*) => 

                this.listView.Delete(rowNumber)
                IniDelete(this.iniFile, iniFileSection, listViewFirstColum)
                inputGui.Destroy()
                ; TODO change this
                Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
            )
    }

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