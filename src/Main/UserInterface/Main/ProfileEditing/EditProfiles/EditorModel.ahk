#Requires AutoHotkey v2.0

class EditorModel{

    profiles := ""
    currentProfile := ""
    currentProfileIndex := ""
    PATH_TO_META_FILE := ""


    __New(profiles, currentProfileIndex, pathToMetaFile){
        this.profiles := profiles
        this.currentProfileIndex := currentProfileIndex
        this.currentProfile := profiles[currentProfileIndex]
        this.PATH_TO_META_FILE := pathToMetaFile
    }

    getPathToMetaFile(){
        return this.PATH_TO_META_FILE
    }

    getProfiles(){
        return this.profiles
    }

    getCurrentProfile(){
        return this.currentProfile
    }

    getCurrentProfileIndex(){
        return this.currentProfileIndex
    }

    setCurrentProfile(profileName, profileIndex){
        this.currentProfile := profileName
        this.currentProfileIndex := profileIndex
        this.currentProfile := this.profiles[profileIndex]
    }

    hasProfile(profileName){
        hasProfile := false
        Loop this.profiles.Length{
            if (this.profiles[A_Index] = profileName){
                hasProfile := true
            }
        }
        return hasProfile
    }
    
}