#Requires AutoHotkey v2.0

class EditorModel{

    profiles := ""
    currentProfile := ""
    currentProfileIndex := ""


    __New(profiles, currentProfileIndex){
        this.profiles := profiles
        this.currentProfileIndex := currentProfileIndex
        this.currentProfile := profiles[currentProfileIndex]
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
    
}