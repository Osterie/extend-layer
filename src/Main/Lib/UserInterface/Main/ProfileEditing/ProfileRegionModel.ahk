#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FolderManager>

; TODO rename this class, it should be a class pertaining to folders/files
class ProfileRegionModel{

    ; Used to manage the preset user profiles, the user is only allowed to add a preset profile as a new profile
    PresetProfilesManager := ""
    ; Used to manage the existing user profiles, the user is allowed to edit, delete, and add new profiles
    ExistingProfilesManager := ""
    ; A constant which is the path to the preset profiles

    __New(){

        this.ExistingProfilesManager := FolderManager()
        this.PresetProfilesManager := FolderManager()

        this.PresetProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToPresetProfiles())
        this.PresetProfilesManager.addFolderToRegistry("EmptyProfile", FilePaths.GetPathToEmptyProfile())
        this.ExistingProfilesManager.addSubFoldersToRegistryFromFolder(FilePaths.GetPathToProfiles())

    }

    getProfiles(){
        return this.ExistingProfilesManager.getFolderNames()
    }

    getPresetProfiles(){
        return this.PresetProfilesManager.getFolderNames()
    }

    getCurrentProfileIndex(){
        currentProfileIndex := -1
        profiles := this.getProfiles()
        Loop profiles.Length{
            if (profiles[A_Index] = FilePaths.GetCurrentProfile()){
                currentProfileIndex := A_Index
            }
        }
        return currentProfileIndex
    }

    renameProfile(profileName, newProfileName){
        renamedSuccesfully := false
        
        if (this.ExistingProfilesManager.RenameFolder(profileName, newProfileName)){
            if (profileName = FilePaths.GetCurrentProfile()){
                this.setCurrentProfile(newProfileName)
            }

            renamedSuccesfully := true
        }
        else{
            msgbox("failed to change profile name, perhaps name already exists or illegal characters were used.")
            renamedSuccesfully := false
        }
        return renamedSuccesfully
    }

    DeleteProfile(profileToDelete){

        deletedProfile := false

        if (this.ExistingProfilesManager.DeleteFolder(profileToDelete)){
            ; Deleted profile succesfully
            profiles := this.getProfiles()
            if (profiles.Length != 0){
                if (profileToDelete = FilePaths.GetCurrentProfile()){
                    this.setCurrentProfile(profiles[1])
                }
            }

            deletedProfile := true

        }
        else{
            deletedProfile := false
        }
        return deletedProfile
    }

    AddProfile(profile, profileName){
        profileAdded := false
        if (this.ExistingProfilesManager.hasFolder(profileName)){
            profileAdded := false
        }
        else{
            try{
                presetProfileName := profileName
                profilePath := this.PresetProfilesManager.getFolderPathByName(profile)
                this.ExistingProfilesManager.CopyFolderToNewLocation(profilePath, FilePaths.GetPathToProfiles() . "/" . profileName, profileName, profileName)
                profileAdded := true
            }
            catch{
                profileAdded := false
            }
        }
        return profileAdded
    }
}