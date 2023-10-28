#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\src\library\IniFileReading\IniFileReader.ahk"

; TODO add event for DropFiles, so that user can drag and drop exported user profiles into the program to load them.
; TODO add a mouse section also, so user can change mouse easily

iniFileRead := IniFileReader()

MyGui := Gui()
MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("Text", , "Current Profile:")
MyGui.Add("DropDownList", "vColorChoice ym+1", ["Black","White","Red"])


; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
addProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Add profile")
importProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Import profile")
exportProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Export profile")


Tab := MyGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Documentation"])
Tab.UseTab(1)

; DifferentKeyboardsTab := MyGui.AddTab3(, ["Primary Keyboard","Secondary Keyboard","Tertiary Keyboard"])

RadioButtonKeybindsTextView := MyGui.Add("Radio", "Checked vRadioButtonKeybindsTextView", "Text View")
RadioButtonKeybindsKeyboardView := MyGui.Add("Radio", "vRadioButtonKeybindsKeyboardView", "Keyboard View")

RadioButtonKeybindsTextView.OnEvent("Click", (*) => MsgBox("Text view"))
RadioButtonKeybindsKeyboardView.OnEvent("Click", (*) => MsgBox("Keyboard view"))


iniFileKeyboards := "..\config\UserProfiles\Profile1\Keyboards.ini"
; SectionNames := IniRead(iniFileKeyboards)

TreeViewKeyboards := TreeViewFromIniFile(iniFileKeyboards)

TreeViewKeyboards.CreateTreeView(MyGui)


ListViewKeyboards := ListViewMaker()
ListViewKeyboards.CreateListView(MyGui, ["Key","Value"], iniFileKeyboards)


CreateListViewItems := ObjBindMethod(ListViewKeyboards, "SetNewListViewItemsByIniFileSection", iniFileKeyboards)
TreeViewKeyboards.AddEventAction("ItemSelect", CreateListViewItems)
; CreateListViewItems := ObjBindMethod(ListViewKeybinds, "SetNewListViewItemsByIniFileSection", iniFileKeyboards)
; TreeViewKeyboards.AddEventAction("ItemSelect", CreateListViewItems)

; MyGui.AddHotkey("vChosenHotkey")
; MyGui.Add("CheckBox", "vMyCheckBox", "Win key") 


Tab.UseTab(2)

; TODO: ability to search

; TODO: for treeview, perhaps it would be a good idea to pass object registry to the treeview.

iniFileClassObjects := "..\config\UserProfiles\Profile1\ClassObjects.ini"
; SectionNames := IniRead(iniFileClassObjects)

NewTreeView := TreeViewFromIniFile(iniFileClassObjects)

NewTreeView.CreateTreeView(MyGui)


NewListView := ListViewMaker()
NewListView.CreateListView(MyGui, ["Key","Value"], iniFileClassObjects)


CreateListViewItems := ObjBindMethod(NewListView, "SetNewListViewItemsByIniFileSection", iniFileClassObjects)
NewTreeView.AddEventAction("ItemSelect", CreateListViewItems)

    

Tab.UseTab(3)
MyGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.

; OkButton := MyGui.Add("Button", "default xm", "OK")  ; xm puts it at the bottom left corner.
; OkButton.OnEvent("Click", ProcessUserInput)
; MyGui.OnEvent("Close", ProcessUserInput)
; MyGui.OnEvent("Escape", ProcessUserInput)
MyGui.Show()
