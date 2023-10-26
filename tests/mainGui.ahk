#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\src\library\IniFileReading\IniFileReader.ahk"

iniFileRead := IniFileReader()

MyGui := Gui()
MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("Text", , "Current Profile:")
MyGui.Add("DropDownList", "vColorChoice", ["Black","White","Red"])


; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
addProfileButton := MyGui.Add("Button", "Default w80", "Add profile")
importProfileButton := MyGui.Add("Button", "Default w80", "Import profile")
exportProfileButton := MyGui.Add("Button", "Default w80", "Export profile")

; addProfileButton.OnEvent("Click", addProfileButton_Click)
; importProfileButton.OnEvent("Click", importProfileButton_Click)
; exportProfileButton.OnEvent("Click", exportProfileButton_Click)

; MyBtn.OnEvent("Click", MyBtn_Click)  ; Call MyBtn_Click when clicked.


Tab := MyGui.AddTab3(, ["Keyboards","Change Functions Settings","Third Tab"])
Tab.UseTab(1)
MyGui.AddGroupBox("w200 h100", "Geographic Criteria")

MyGui.AddHotkey("vChosenHotkey")
MyGui.Add("CheckBox", "vMyCheckBox", "Win key") 
Tab.UseTab(2)

; TODO: ability to search

; TODO: for treeview, perhaps it would be a good idea to pass object registry to the treeview.
; Then a function or something is called which creates the treeview.
; This would rely on object registry perhaps needing some added functionality

; ImageListID := IL_Create(10)  ; Create an ImageList with initial capacity for 10 icons.
; Loop 10  ; Load the ImageList with some standard system icons.
;     IL_Add(ImageListID, "shell32.dll", A_Index)
; TV := MyGui.Add("TreeView", "ImageList" . ImageListID)
; TV.Add("Name of Item", 0, "Icon4")  ; Add an item to the TreeView and give it a folder icon.

; CreateTreeViewFromIniFile()

iniFile := "..\config\UserProfiles\Profile1\ClassObjects.ini"
SectionNames := IniRead(iniFile)

NewTreeView := TreeViewFromIniFile(iniFile)
NewTreeView.CreateTreeView(MyGui)


NewListView := ListViewMaker()
NewListView.CreateListView(MyGui, ["Key","Value"], iniFile)


CreateListViewItems := ObjBindMethod(NewListView, "SetNewListViewItemsByIniFileSection", iniFile)
NewTreeView.AddEventAction("ItemSelect", CreateListViewItems)

    

Tab.UseTab(3)
MyGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.

; OkButton := MyGui.Add("Button", "default xm", "OK")  ; xm puts it at the bottom left corner.
; OkButton.OnEvent("Click", ProcessUserInput)
; MyGui.OnEvent("Close", ProcessUserInput)
; MyGui.OnEvent("Escape", ProcessUserInput)
MyGui.Show()
