#Requires AutoHotkey v2.0

Class ListViewFromIniFileContent{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    iniFileRead := ""

    __New(){
        this.iniFileRead := IniFileReader()
    }

    CreateListView(guiObject, columnNames, iniFile){
        this.iniFile := iniFile
        this.listView := guiObject.Add("ListView", "r20 w400 x+10", columnNames)
        
        this.listView.ModifyCol(1, 200)
        this.listView.ModifyCol(2, 200)

        ; ListViewDoubleClickEvent := ObjBindMethod(this, "ListViewDoubleClickEvent")
        ; this.listView.OnEvent("DoubleClick", ListViewDoubleClickEvent)
        
    }

    SetNewListViewItemsByLayerIdentifier(iniFile, section, item){
        
        if (section is Gui.TreeView){
            this.activeTreeViewItem := section.GetText(item)
            keyPairValuesArray := this.iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section.GetText(item))
            this.SetNewListViewItems(keyPairValuesArray)
        }
        else{
            keyPairValuesArray := this.iniFileRead.ReadSectionKeyPairValuesIntoTwoDimensionalArray(iniFile, section)
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
    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}