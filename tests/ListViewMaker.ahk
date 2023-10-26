#Requires AutoHotkey v2.0

Class ListViewMaker{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    CreateListView(guiObject, columnNames, iniFile){
        this.iniFile := iniFile
        this.listView := guiObject.Add("ListView", "grid r20 w400 x+10", columnNames)
        
        this.listView.ModifyCol(1, 200)
        this.listView.ModifyCol(2, 200)

        ListViewDoubleClickEvent := ObjBindMethod(this, "ListViewDoubleClickEvent")
        this.listView.OnEvent("DoubleClick", ListViewDoubleClickEvent)
        
    }

    SetNewListViewItemsByIniFileSection(iniFile, section, item){
        if (section is Gui.TreeView){
            this.activeTreeViewItem := section.GetText(item)
            keyPairValuesArray := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section.GetText(item))
            this.SetNewListViewItems(keyPairValuesArray)
        }
        else{
            keyPairValuesArray := iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section)
            this.SetNewListViewItems(keyPairValuesArray)
        }
    }


    ; Takes a two dimensional array, items, and adds each item to the listView
    SetNewListViewItems(items){
        
        this.listView.Delete()
        Loop items.Length{
            this.listView.Add(, items[A_index]*)
        }
    }

    ; Takes item which should be an array with the same length as the number of columns
    SetListViewItem(item){
        this.listView.Add(, item*)        
    }

    ; 
    ListViewDoubleClickEvent(listView, rowNumber){

        listViewFirstColum := this.listView.GetText(rowNumber, 1)
        listViewSecondColum := this.listView.GetText(rowNumber, 2)
        if (rowNumber != 0){
    
            inputPrompt := InputBox("Value name: " . listViewFirstColum . "`n" . "Value data:", "Edit object value",, listViewSecondColum)
            if inputPrompt.Result = "Cancel"{
                ; Do nothing
            }
            else if(inputPrompt.Value = ""){
                ; Do Nothing
            }
            else{
    
                this.listView.Modify(rowNumber,,, inputPrompt.Value)
                ; TODO then modify the ini file, perhaps should use a class for this
                ; TODO could also change the objectRegistry objects from here or somewhere...
                ; TODO to implement this, probably just have a method called "update objects" or something in the objectRegistry class

                iniFileSection := this.activeTreeViewItem
                IniWrite(inputPrompt.Value, this.iniFile, iniFileSection, listViewFirstColum)
    
            }
        }
    }

    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }

}