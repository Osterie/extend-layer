#Requires AutoHotkey v2.0

#Include "..\library\FoldersAndFiles\IniFileReader.ahk"


Class ListViewMaker{

    listView := ""
    activeTreeViewItem := ""
    iniFile := ""

    iniFileRead := ""

    __New(){
        this.iniFileRead := IniFileReader()
    }

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

    ListViewDoubleClickEvent(listView, rowNumber){

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
            SaveButton.onEvent("Click", (*) =>
            
                ; TODO validate values, can not be empty!, can not be the same as another key, etc...
                IniWrite(inputValue.Value, this.iniFile, iniFileSection, inputKey.Value)
                inputGui.Destroy()
                Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
            )

            CancelButton.onEvent("Click", (*) =>inputGui.Destroy())
            
            DeleteButton.onEvent("Click", (*) => 

                IniDelete(this.iniFile, iniFileSection, inputKey.Value)
                inputGui.Destroy()
                Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
            )

            ; inputPrompt := InputBox("Value name: " . listViewFirstColum . "`n" . "Value data:", "Edit object value",, listViewSecondColum)

            ; if inputPrompt.Result = "Cancel"{
            ;     ; Do nothing
            ; }
            ; else if(inputPrompt.Value = ""){
            ;     ; Do Nothing
            ; }
            ; else{
    
            ;     this.listView.Modify(rowNumber,,, inputPrompt.Value)
            ;     ; TODO then modify the ini file, perhaps should use a class for this
            ;     ; TODO could also change the objectRegistry objects from here or somewhere...
            ;     ; TODO to implement this, probably just have a method called "update objects" or something in the objectRegistry class

            ;     iniFileSection := this.activeTreeViewItem
            ;     IniWrite(inputPrompt.Value, this.iniFile, iniFileSection, listViewFirstColum)
            ;     Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
            ; }
        ; }
        ; An empty row is double clicked and the user may want to add another key pair value (change a key to a new one)
        ; else{

        ; }
    }

    SetOnTop(identifier){
        WinSetAlwaysOnTop 1, identifier
    }


    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }

}