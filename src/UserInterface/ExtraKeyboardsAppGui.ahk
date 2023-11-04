#Requires AutoHotkey v2.0

#Include ".\TreeViewFromIniFile.ahk"
#Include ".\ListViewMaker.ahk"
#Include "..\library\IniFileReading\IniFileReader.ahk"
#Include ".\FolderManager.ahk"

; TODO have a hotkey which sends a given key(or hotkey) after a given delay.
; TODO could also have a hotkey/key which is excecuted if a loud enough sound is caught by the mic.

; TODO make it possible for the user to add own ahk scripts to the program, and then use them as functions. 

Class ExtraKeyboardsAppGui{

    ; Used to read the contents of ini files
    iniFileRead := ""
    ; Used to create the gui
    ExtraKeyboardsAppGui := ""
    ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
    PresetProfilesManager := ""
    ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
    ExistingProfilesManager := ""
    ; A constant which is the path to the preset profiles
    PATH_TO_PRESET_PROFILES := ""

    PATH_TO_EXISTING_PROFILES := ""

    PATH_TO_META_FILE := ""

    currentProfile := ""
    currentProfileIndex := ""


    __New(pathToExistingProfiles, pathToPresetProfiles, pathToMetaFile, pathToMainScript){
        this.iniFileRead := IniFileReader()
        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()



        this.PATH_TO_EXISTING_PROFILES := pathToExistingProfiles
        this.PATH_TO_PRESET_PROFILES := pathToPresetProfiles
        this.PresetProfilesManager.addSubFoldersFromFolder(this.PATH_TO_PRESET_PROFILES)
        this.ExistingProfilesManager.addSubFoldersFromFolder(this.PATH_TO_EXISTING_PROFILES)

        this.PATH_TO_META_FILE := pathToMetaFile

        this.PATH_TO_MAIN_SCRIPT := pathToMainScript

        this.currentProfile := iniRead(this.PATH_TO_META_FILE, "General", "activeUserProfile")

        this.currentProfileIndex := this.ExistingProfilesManager.getFirstFoundFolderIndex(this.currentProfile)

    }

    CreateMain(){

        this.ExtraKeyboardsAppGui := Gui()
        this.ExtraKeyboardsAppGui.Opt("+Resize +MinSize640x480")
        this.ExtraKeyboardsAppGui.Add("Text", , "Current Profile:")
        
        
        profilesDropDownMenu := this.createProfilesDropDownMenu()
        
        
        ; TODO when add profile is clicked, user can choose a pre made profile, or create their own from scratch
        editProfilesButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Edit profiles")
        addProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Add profile")
        importProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Import profile")
        exportProfileButton := this.ExtraKeyboardsAppGui.Add("Button", "Default w80 ym+1", "Export profile")
        

        editProfilesButton.OnEvent("Click", (*) =>  this.EditProfiles())
        addProfileButton.OnEvent("Click", (*) => this.AddProfile())
              
        
        this.CreateTabs(profilesDropDownMenu)        
        
        
        this.ExtraKeyboardsAppGui.Show()
    }

    CreateProfilesDropDownMenu(){

        ; Creates a drop down list of all the profiles, and sets the current profile to the active profile
        profilesDropDownMenu := this.ExtraKeyboardsAppGui.Add("DropDownList", "ym+1 Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
        
        ; If for some reason a profile is not selected, then select the first one.
        if (profilesDropDownMenu.Text == "")
        {
            msgbox("error, profile not found, selecting first existing profile")
            profilesDropDownMenu.Value := 1
            this.currentProfile := profilesDropDownMenu.Text
        }
        
        profilesDropDownMenu.OnEvent("Change", (*) => this.ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu))
        
        return profilesDropDownMenu
    }

    ProfileChangedFromDropDownMenuEvent(profilesDropDownMenu){
        iniWrite(profilesDropDownMenu.Text, this.PATH_TO_META_FILE, "General", "activeUserProfile")
        ; TODO after changing profile, need to reload EVERYTHING, or perhaps not.
        Run("*RunAs " this.PATH_TO_MAIN_SCRIPT)
        reload
    }

    CreateTabs(profilesDropDownMenu){
        
        Tab := this.ExtraKeyboardsAppGui.AddTab3("ys+20 xm", ["Keyboards","Change Functions Settings","Documentation"])
        Tab.UseTab(1)
        this.CreateKeyboardsTab(profilesDropDownMenu)
        Tab.UseTab(2)
        this.CreateObjectsTab(profilesDropDownMenu)
        Tab.UseTab(3)
        this.CreateDocumentationTab()
        Tab.UseTab(0)  ; i.e. subsequently-added controls will not belong to the tab control.

    }

    CreateKeyboardsTab(profilesDropDownMenu){
        iniFileKeyboards := this.PATH_TO_EXISTING_PROFILES . "\" . profilesDropDownMenu.Text . "\Keyboards.ini"
        
        TreeViewKeyboards := TreeViewFromIniFile(iniFileKeyboards)
        TreeViewKeyboards.CreateTreeView(this.ExtraKeyboardsAppGui)
        
        ListViewKeyboards := ListViewMaker()
        ListViewKeyboards.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"], iniFileKeyboards, "Keyboards")
        
        CreateListViewItems := ObjBindMethod(ListViewKeyboards, "SetNewListViewItemsByIniFileSection", iniFileKeyboards)
        TreeViewKeyboards.AddEventAction("ItemSelect", CreateListViewItems)
    }

    CreateObjectsTab(profilesDropDownMenu){
        ; TODO: ability to search
        
        ; TODO: for treeview, perhaps it would be a good idea to pass object registry to the treeview.
        
        iniFileClassObjects := "..\config\UserProfiles\" . profilesDropDownMenu.Text . "\ClassObjects.ini"
        ; SectionNames := IniRead(iniFileClassObjects)
        
        NewTreeView := TreeViewFromIniFile(iniFileClassObjects)
        
        NewTreeView.CreateTreeView(this.ExtraKeyboardsAppGui)
        
        NewListView := ListViewMaker()
        NewListView.CreateListView(this.ExtraKeyboardsAppGui, ["Key","Value"], iniFileClassObjects, "Objects")
        
        
        CreateListViewItems := ObjBindMethod(NewListView, "SetNewListViewItemsByIniFileSection", iniFileClassObjects)
        NewTreeView.AddEventAction("ItemSelect", CreateListViewItems)
        
            
    }

    CreateDocumentationTab(){
        this.ExtraKeyboardsAppGui.Add("Edit", "vMyEdit r20")  ; r20 means 20 rows tall.
    }

    ; CreateTreeView(iniFile){

    ; }

    EditProfiles(*){
        
        editProfilesGui := Gui()
    
        editProfilesGui.OnEvent("Close", (*) => editProfilesGui.Destroy())
    
        editProfilesGui.Opt("+Resize +MinSize320x240")
        editProfilesGui.Add("Text", , "Selected Profile:")
        profilesToEditDropDownMenu := editProfilesGui.Add("DropDownList", "ym Choose" . this.currentProfileIndex, this.ExistingProfilesManager.getFolderNames())
        
        renameProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Change profile name")
        indexOfProfile := ""
        renameProfileButton.OnEvent("Click", (*) => 
    
            
            this.RenameProfile(profilesToEditDropDownMenu.Text)
    
            profilesToEditDropDownMenu.Delete()
            profilesToEditDropDownMenu.Add(this.ExistingProfilesManager.getFolderNames())
            profilesToEditDropDownMenu.Choose(this.ExistingProfilesManager.getMostRecentlyAddedFolder())
            
            ; profilesDropDownMenu.Delete()
            ; profilesDropDownMenu.Add(this.ExistingProfilesManager.getFolderNames())
            ; profilesDropDownMenu.Choose(this.ExistingProfilesManager.getMostRecentlyAddedFolder())
    
        )
    
    
    
        ; TODO should ask the user if they are really sure they want to delete the profile
        deleteProfileButton := editProfilesGui.Add("Button", "Default w80 xm+1", "Delete profile")
        deleteProfileButton.OnEvent("Click", (*) =>
            this.DeleteProfile(profilesToEditDropDownMenu.Text)
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
    
            if (this.PresetProfilesManager.RenameFolder(currentProfile, inputPrompt.Value)){
                ; Changed profile name succesfully
                iniWrite(inputPrompt.Value, this.PATH_TO_META_FILE, "General", "activeUserProfile")
            }
            else{
                msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            }
        }
    } 
    
    DeleteProfile(*){
        inputPrompt := InputBox("Are you sure you want to delete this profile? Deleted profiles cannot be resuscitated. Type yes to confirm", "Edit object value",, this.currentProfile)
    
        if inputPrompt.Result = "Cancel"{
            ; Do nothing
        }
        else if(inputPrompt.Value = ""){
            ; Do Nothing
        }
        else if (StrLower(inputPrompt.Value) = "yes"){
    
            if (this.PresetProfilesManager.DeleteFolder(this.currentProfile)){
                ; Deleted profile succesfully
                iniWrite(inputPrompt.Value, this.PATH_TO_META_FILE, "General", "activeUserProfile")
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
            customProfilesDropDownMenu := addProfileGui.Add("DropDownList", "ym+1 Choose1", this.PresetProfilesManager.getFolderNames())
    
        )
    
        addCustomProfileButton := addProfileGui.Add("Button", "Default w80 xm+1", "Add custom profile")
        addCustomProfileButton.OnEvent("Click", (*) => 
            msgbox("add custom profile")
        )
        
        addProfileGui.Show()
    }
    
}