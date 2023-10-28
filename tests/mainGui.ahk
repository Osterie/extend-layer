#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\src\library\IniFileReading\IniFileReader.ahk"


iniFileRead := IniFileReader()

MyGui := Gui()
MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("Text", , "Current Profile:")
MyGui.Add("DropDownList", "vColorChoice ym+1", ["Black","White","Red"])


; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
addProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Add profile")
importProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Import profile")
exportProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Export profile")


Tab := MyGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Third Tab"])
Tab.UseTab(1)

; DifferentKeyboardsTab := MyGui.AddTab3(, ["Primary Keyboard","Secondary Keyboard","Tertiary Keyboard"])
MyGui.Add("Radio", "vMyRadio", "Text View")
MyGui.Add("Radio",, "Keyboard View")

; ProcessUserInput(*)
; {
;     Saved := MyGui.Submit()  ; Save the contents of named controls into an object.
;     MsgBox("You entered:`n" Saved.MyCheckBox "`n" Saved.MyRadio "`n" Saved.MyEdit)
; }

; MyGui.AddHotkey("vChosenHotkey")
; MyGui.Add("CheckBox", "vMyCheckBox", "Win key") 


Tab.UseTab(2)

; TODO: ability to search

; TODO: for treeview, perhaps it would be a good idea to pass object registry to the treeview.

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
