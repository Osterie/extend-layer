#Requires AutoHotkey v2.0

; Used to create a treeview for a gui based on the values of an ini file

Class TreeViewMaker{

    AddTreeViewFromIniFile(guiObject, iniFile){
        ; guiObject.Add("TreeView", treeViewName, "x" x " y" y " w" w " h" h)
        treeView := guiObject.Add("TreeView")
        listView := guiObject.Add("ListView", "grid r20 w400 x+10", ["Key","Value"])
        
        test := ObjBindMethod(this, "test")
        listView.OnEvent("DoubleClick", test)


        listView.ModifyCol(1, 200)
        listView.ModifyCol(2, 200)

        ; Read sections
        ; Todo this logic should be handled by another class or method
        iniFileSections := IniRead(iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        Loop iniFileSections.Length{
            
            sectionName := iniFileSections[A_Index]
            treeView.Add(sectionName)
            
            ; sectionValues := IniRead(iniFile, sectionName)

        }

        TreeViewItemSelectEventMethod := ObjBindMethod(this, "TreeViewItemSelectEvent", listView)
        treeView.OnEvent("ItemSelect", TreeViewItemSelectEventMethod)

    }

    TreeViewItemSelectEvent(listView, treeView, item){
        ; Clears the existing values of the listView (if there are any)
        listView.Delete()
        
        

        ; Gets the ini file section of the clicked treeView item
        iniFileSection := treeView.GetText(item)
        ; Gets the ini file section values
        iniFileSectionValues := IniRead(iniFile, iniFileSection)
        ; Splits the ini file section values into an array
        iniFileSectionValues := StrSplit(iniFileSectionValues, "`n")
        ; Loops through the ini file section values
        Loop iniFileSectionValues.Length{
            ; Gets the current ini file section value, split into an array, with the key and value
            temporarySectionValues := StrSplit(iniFileSectionValues[A_Index], "=")
            lineKey := temporarySectionValues[1]
            lineValue := temporarySectionValues[2]
            listView.Add(, lineKey, lineValue)
        }
    }

    test(listView, item){

        listViewFirstColum := listView.GetText(item, 1)
        listViewSecondColum := listView.GetText(item, 2)
        if (listViewFirstColum = "Key"){

        }
        else{

            IB := InputBox("Value name: " . listViewFirstColum . "`n" . "Value data:", "Edit object value",, listViewSecondColum)
            if IB.Result = "Cancel"{
                MsgBox "You entered '" IB.Value "' but then cancelled."
            }
            else{
                MsgBox "You entered '" IB.Value "'."
            }
            

        }
    }

    AddBranchToTreeView(treeView, branchName, parentBranchName := ""){
        if (parentBranchName = "")
            treeView.Add(branchName)
        else
            treeView.Add(branchName, parentBranchName)
    }
}
