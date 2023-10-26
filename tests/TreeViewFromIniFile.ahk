#Requires AutoHotkey v2.0

; Used to create a treeview for a gui based on the values of an ini file

Class TreeViewFromIniFile{

    iniFile := ""
    treeView := ""

    __New(iniFile){
        this.iniFile := iniFile
    }

    CreateTreeView(guiObject){
        ; guiObject.Add("TreeView", treeViewName, "x" x " y" y " w" w " h" h)
        this.treeView := guiObject.Add("TreeView")
        listView := guiObject.Add("ListView", "grid r20 w400 x+10", ["Key","Value"])
        
        test := ObjBindMethod(this, "test")
        listView.OnEvent("DoubleClick", test)


        listView.ModifyCol(1, 200)
        listView.ModifyCol(2, 200)

        ; Read sections
        ; Todo this logic should be handled by another class or method
        iniFileSections := IniRead(this.iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        Loop iniFileSections.Length{
            
            sectionName := iniFileSections[A_Index]
            this.treeView.Add(sectionName)
            
            ; sectionValues := IniRead(this.iniFile, sectionName)

        }

        TreeViewItemSelectEventMethod := ObjBindMethod(this, "TreeViewItemSelectEvent", listView)
        this.treeView.OnEvent("ItemSelect", TreeViewItemSelectEventMethod)

    }

    TreeViewItemSelectEvent(listView, treeView, item){
        ; Clears the existing values of the listView (if there are any)
        listView.Delete()
        
        

        ; Gets the ini file section of the clicked treeView item
        iniFileSection := this.treeView.GetText(item)
        ; Gets the ini file section values
        iniFileSectionValues := IniRead(this.iniFile, iniFileSection)
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

    test(listView, rowNumber){

        msgbox(rowNumber)
        msgbox(listView.GetText(rowNumber, 1))
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

                listView.Modify(rowNumber,,, inputPrompt.Value)
                ; TODO then modify the ini file, perhaps should use a class for this
                ; TODO could also change the objectRegistry objects from here...
                ; TODO to implement this, probably just have a method called "update objects" or something in the objectRegistry class

                iniFileSection := treeView.GetText(treeView.GetSelection())
                iniFileSectionValues := IniRead(this.iniFile, iniFileSection)
                iniFileSectionValues := StrSplit(iniFileSectionValues, "`n")
                Loop iniFileSectionValues.Length{
                    temporarySectionValues := StrSplit(iniFileSectionValues[A_Index], "=")
                    lineKey := temporarySectionValues[1]
                    lineValue := temporarySectionValues[2]
                    if (lineKey = listViewFirstColum){
                        iniFileSectionValues[A_Index] := lineKey "=" inputPrompt.Value
                    }
                ; }
                ; iniFileSectionValues := StrJoin(iniFileSectionValues, "`n")
                ; IniWrite(this.iniFile, iniFileSection, iniFileSectionValues)
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
