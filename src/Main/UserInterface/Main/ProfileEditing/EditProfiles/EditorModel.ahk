#Requires AutoHotkey v2.0
; TODO inheritance with ProfileRegionModel perhaps
class EditorModel{
    currentProfile := ""
    profiles := []
    currentProfileIndex := 0

    __New(profiles, currentProfileIndex){
        this.profiles := profiles
        this.currentProfileIndex := currentProfileIndex
        this.currentProfile := profiles[currentProfileIndex]
    }

    setProfiles(profiles){
        this.profiles := profiles
        try{
            this.currentProfile := profiles[this.currentProfileIndex]
        }
        catch{
            this.currentProfile := profiles[1]
            this.currentProfileIndex := 1
        }
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

    SetCurrentProfile(currentProfileIndex){
        this.currentProfileIndex := currentProfileIndex
        this.currentProfile := this.profiles[currentProfileIndex]
    }
}