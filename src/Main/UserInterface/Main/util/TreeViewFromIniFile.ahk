#Requires AutoHotkey v2.0

#Include <FoldersAndFiles\IniFileReader>

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

        ImageListID := this.GetCustomImage()
        this.treeView := guiObject.Add("TreeView", "r20 ImageList" . ImageListID)

        ; Read sections
        ; Todo this logic should be handled by another class or method
        iniFileSections := this.iniFileRead.ReadSectionNames(this.iniFile)
        iniFileSections := StrSplit(iniFileSections, "`n")
        Loop iniFileSections.Length{
            sectionName := iniFileSections[A_Index]
            this.treeView.Add(sectionName, 0, "Icon4")
        }
    }

    AddEventAction(eventType, action){
        this.treeView.OnEvent(eventType, action)
    }

    GetCustomImage(){
        ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
        Loop 10  ; Load the ImageList with some standard system icons.
            IL_Add(ImageListID, "shell32.dll", A_Index)

        return ImageListID
    }

}
