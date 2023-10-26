#Requires AutoHotkey v2.0

#Include "..\src\library\IniFileReading\IniFileReader.ahk"

; Used to create a treeview for a gui based on the values of an ini file

Class TreeViewFromIniFile{

    iniFile := ""
    treeView := ""
    iniFileRead := ""

    __New(iniFile){
        this.iniFile := iniFile
        this.iniFileRead := IniFileReader()
    }

    CreateTreeView(guiObject){
        ; guiObject.Add("TreeView", treeViewName, "x" x " y" y " w" w " h" h)
        this.treeView := guiObject.Add("TreeView")

        ; Read sections
        ; Todo this logic should be handled by another class or method
        iniFileSections := this.iniFileRead.ReadSectionNames(this.iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        Loop iniFileSections.Length{
            sectionName := iniFileSections[A_Index]
            this.treeView.Add(sectionName)
        }
    }

    AddEventAction(eventType, action){
        this.treeView.OnEvent(eventType, action)
    }

    TreeViewItemSelectEvent(listView, treeView, item){
        ; Clears the existing values of the listView (if there are any)
        listView.Delete()
        ; Gets the ini file section of the clicked treeView item
        iniFileSection := this.treeView.GetText(item)
        ; Gets the ini file section values
        iniFileSectionValues := this.iniFileRead.ReadSection(this.iniFile, iniFileSection)
        ; Splits the ini file section values into an array
        iniFileSectionValues := StrSplit(iniFileSectionValues, "`n")
        ; Loops through the ini file section values
        Loop iniFileSectionValues.Length{
            ; Gets the key and value from the ini file section value
            lineKey := this.iniFileRead.GetKeyFromLine(iniFileSectionValues[A_Index])
            lineValue := this.iniFileRead.GetValueFromLine(iniFileSectionValues[A_Index])
            listView.Add(, lineKey, lineValue)
        }
    }

}
