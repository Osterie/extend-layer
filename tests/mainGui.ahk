#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\src\library\IniFileReading\IniFileReader.ahk"
#Include ".\FolderManager.ahk"

; TODO add event for DropFiles, so that user can drag and drop exported user profiles into the program to load them.
; TODO add a mouse section also, so user can change mouse easily

iniFileRead := IniFileReader()

MyGui := Gui()
MyGui.Opt("+Resize +MinSize640x480")

MyGui.Add("Text", , "Current Profile:")

FolderManagement := FolderManager()
pathToProfiles := "..\config\UserProfiles"

currentProfile := iniRead("..\config\meta.ini", "General", "activeUserProfile")
currentProfileIndex := ""


Loop Files pathToProfiles . "\*", "D"
{
    if (currentProfile == A_LoopFileName)
    {
        currentProfileIndex := A_index
    }
    FolderManagement.addFolder(A_LoopFileName, pathToProfiles . "\" . A_LoopFileName)
}



profilesDropDownMenu := MyGui.Add("DropDownList", "ym+1 Choose" . currentProfileIndex, FolderManagement.getFolderNames())

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
editProfilesButton := MyGui.Add("Button", "Default w80 ym+1", "Edit profiles")
addProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Add profile")
importProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Import profile")
exportProfileButton := MyGui.Add("Button", "Default w80 ym+1", "Export profile")

editProfilesButton.OnEvent("Click", EditProfiles)
addProfileButton.OnEvent("Click", AddProfile)



EditProfiles(*){

    editProfilesGui := Gui()

    editProfilesGui.OnEvent("Close", (*) => editProfilesGui.Destroy())

    editProfilesGui.Opt("+Resize +MinSize320x240")
    editProfilesGui.Add("Text", , "Selected Profile:")
    profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . currentProfileIndex, FolderManagement.getFolderNames())
    
    renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")
    indexOfProfile := ""
    renameProfileButton.OnEvent("Click", (*) => 

        
        RenameProfile(profilesToEditDropDownMenu.Text)

        profilesToEditDropDownMenu.Delete()
        profilesToEditDropDownMenu.Add(FolderManagement.getFolderNames())
        profilesToEditDropDownMenu.Choose(FolderManagement.getMostRecentlyAddedFolder())
        
        profilesDropDownMenu.Delete()
        profilesDropDownMenu.Add(FolderManagement.getFolderNames())
        profilesDropDownMenu.Choose(FolderManagement.getMostRecentlyAddedFolder())

    )



    ; TODO should ask the user if they are really sure they want to delete the profile
    deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
    deleteProfileButton.OnEvent("Click", (*) =>
        DeleteProfile(profilesToEditDropDownMenu.Text)
    )

    editProfilesGui.Show()
}

RenameProfile(currentProfile){
    inputPrompt := InputBox("Please write the new name for the profile!", "Edit object value",, currentProfile)

    if inputPrompt.Result = "Cancel"{
        ; Do nothing
    }
    else if(inputPrompt.Value = ""){
        ; Do Nothing
    }
    else{

        if (FolderManagement.RenameFolder(currentProfile, inputPrompt.Value)){
            ; Changed profile name succesfully
            iniWrite(inputPrompt.Value, "..\config\meta.ini", "General", "activeUserProfile")
        }
        else{
            msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
        }
    }
} 

DeleteProfile(*){
    inputPrompt := InputBox("Are you sure you want to delete this profile? Deleted profiles cannot be resuscitated. Type yes to confirm", "Edit object value",, currentProfile)

    if inputPrompt.Result = "Cancel"{
        ; Do nothing
    }
    else if(inputPrompt.Value = ""){
        ; Do Nothing
    }
    else if (StrLower(inputPrompt.Value) = "yes"){

        if (FolderManagement.DeleteFolder(currentProfile)){
            ; Deleted profile succesfully
            iniWrite(inputPrompt.Value, "..\config\meta.ini", "General", "activeUserProfile")
        }
        else{
            msgbox("failed to delete profile")
        }
    }
}

AddProfile(*){
    addProfileGui := Gui()

    addProfileGui.OnEvent("Close", (*) => addProfileGui.Destroy())

    addProfileGui.Opt("+Resize +MinSize320x240")
    addProfileGui.Add("Text", , "Selected Profile:")

    addPresetProfileButton := addProfileGui.Add("Button", "Default w80 xm+1", "Add preset profile")
    addPresetProfileButton.OnEvent("Click", (*) => 
        msgbox("add preset profile")
    )

    addCustomProfileButton := addProfileGui.Add("Button", "Default w80 xm+1", "Add custom profile")
    addCustomProfileButton.OnEvent("Click", (*) => 
        msgbox("add custom profile")
    )
    
    addProfileGui.Show()
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