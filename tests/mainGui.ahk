#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\src\library\IniFileReading\IniFileReader.ahk"

; TODO add event for DropFiles, so that user can drag and drop exported user profiles into the program to load them.
; TODO add a mouse section also, so user can change mouse easily

; iniWrite

currentProfile := iniRead("..\config\meta.ini", "General", "activeUserProfile")
iniFileRead := IniFileReader()

MyGui := Gui()
MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("Text", , "Current Profile:")


profiles := []
pathToProfiles := "..\config\UserProfiles"

currentProfileIndex := 0


Loop Files pathToProfiles . "\*", "D"
{
    if (currentProfile == A_LoopFileName)
    {
        currentProfileIndex := A_index
    }
    profiles.push(A_LoopFileName)
}



profilesDropDownMenu := MyGui.Add("DropDownList", "ym+1 Choose" . currentProfileIndex, profiles)

; If for some reason a profile is not selected, then select the first one.
if (profilesDropDownMenu.Text == "")
{
    msgbox("error, profile not found, selecting first existing profile")
    profilesDropDownMenu.Value := 1
    currentProfile := profilesDropDownMenu.Text
}

profilesDropDownMenu.OnEvent("Change", ProfileChangedFromDropDownMenu)

ProfileChangedFromDropDownMenu(*){
    iniWrite(profilesDropDownMenu.Text, "..\config\meta.ini", "General", "activeUserProfile")
    ; TODO after changing profile, need to reload EVERYTHING, or perhaps not.
    Run("*RunAs " A_ScriptDir "\..\src\Main.ahk")
    reload

}



; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
addProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Add profile")
importProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Import profile")
exportProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Export profile")

addProfileButton.OnEvent("Click", AddProfile)

AddProfile(button, test2){
    MsgBox("Add profile")
}



Tab := MyGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Documentation"])
Tab.UseTab(1)

; DifferentKeyboardsTab := MyGui.AddTab3(, ["Primary Keyboard","Secondary Keyboard","Tertiary Keyboard"])

RadioButtonKeybindsTextView := MyGui.Add("Radio", "Checked vRadioButtonKeybindsTextView", "Text View")
RadioButtonKeybindsKeyboardView := MyGui.Add("Radio", "vRadioButtonKeybindsKeyboardView", "Keyboard View")

RadioButtonKeybindsTextView.OnEvent("Click", (*) => MsgBox("Text view"))
RadioButtonKeybindsKeyboardView.OnEvent("Click", (*) => MsgBox("Keyboard view"))




iniFileKeyboards := "..\config\UserProfiles\" . profilesDropDownMenu.Text . "\Keyboards.ini"
; SectionNames := IniRead(iniFileKeyboards)

TreeViewKeyboards := TreeViewFromIniFile(iniFileKeyboards)

TreeViewKeyboards.CreateTreeView(MyGui)


ListViewKeyboards := ListViewMaker()
ListViewKeyboards.CreateListView(MyGui, ["Key","Value"], iniFileKeyboards, "Keyboards")


CreateListViewItems := ObjBindMethod(ListViewKeyboards, "SetNewListViewItemsByIniFileSection", iniFileKeyboards)
TreeViewKeyboards.AddEventAction("ItemSelect", CreateListViewItems)
; CreateListViewItems := ObjBindMethod(ListViewKeybinds, "SetNewListViewItemsByIniFileSection", iniFileKeyboards)
; TreeViewKeyboards.AddEventAction("ItemSelect", CreateListViewItems)

; MyGui.AddHotkey("vChosenHotkey")
; MyGui.Add("CheckBox", "vMyCheckBox", "Win key") 


Tab.UseTab(2)

; TODO: ability to search

; TODO: for treeview, perhaps it would be a good idea to pass object registry to the treeview.

iniFileClassObjects := "..\config\UserProfiles\" . profilesDropDownMenu.Text . "\ClassObjects.ini"
; SectionNames := IniRead(iniFileClassObjects)

NewTreeView := TreeViewFromIniFile(iniFileClassObjects)

NewTreeView.CreateTreeView(MyGui)


NewListView := ListViewMaker()
NewListView.CreateListView(MyGui, ["Key","Value"], iniFileClassObjects, "Objects")


CreateListViewItems := ObjBindMethod(NewListView, "SetNewListViewItemsByIniFileSection", iniFileClassObjects)
NewTreeView.AddEventAction("ItemSelect", CreateListViewItems)

    

Tab.UseTab(3)
MyGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.

Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.

OkButton := MyGui.Add("Button", "default xm", "OK")  ; xm puts it at the bottom left corner.
; OkButton.OnEvent("Click", ProcessUserInput)
; MyGui.OnEvent("Close", ProcessUserInput)
; MyGui.OnEvent("Escape", ProcessUserInput)
MyGui.Show()