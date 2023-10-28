#Requires AutoHotkey v2.0

class GuiEventHandler{
    

    ListViewEditValueEvent(listView, rowNumber, event, iniFile, activeTreeViewItem){

        listViewFirstColum := listView.GetText(rowNumber, 1)
        listViewSecondColum := listView.GetText(rowNumber, 2)
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

                iniFileSection := activeTreeViewItem
                IniWrite(inputPrompt.Value, iniFile, iniFileSection, listViewFirstColum)
                Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")

            }
        }
    }

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
                Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")

            }
        }
    }

    AddEventAction(eventType, action){
        this.listView.OnEvent(eventType, action)
    }
}