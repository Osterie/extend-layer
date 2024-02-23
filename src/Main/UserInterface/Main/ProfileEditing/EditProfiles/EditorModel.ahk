#Requires AutoHotkey v2.0
; TODO inheritance with ProfileRegionModel perhaps
class EditorModel{
    currentProfile := ""
    profiles := []

    __New(profiles, currentProfile){
        this.profiles := profiles
        this.currentProfile := currentProfile
    }

    setProfiles(profiles){
        this.profiles := profiles
        if (this.profiles.Length != 0){
            try{
                this.currentProfile := profiles[this.getCurrentProfileIndex()]
            }
            catch{
                this.currentProfile := profiles[1]
            }
        }
    }

    getProfiles(){
        return this.profiles
    }

    getCurrentProfile(){
        return this.currentProfile
    }

    getCurrentProfileIndex(){
        currentProfileIndex := -1
        Loop this.profiles.Length{
            if (this.profiles[A_Index] = this.currentProfile){
                currentProfileIndex := A_Index
            }
        }
        return currentProfileIndex
    }

    SetCurrentProfile(profileName){
        this.currentProfile := profileName
    }
}