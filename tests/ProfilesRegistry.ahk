#Requires AutoHotkey v2.0

class ProfilesRegistry {
    
    profiles := {}
    
    __New() {
        this.profiles := {}
    }

    addProfile(profileName, profilePath) {
        profileAdded := false
        if (this.isInRegistry(profileName)) {
            profileAdded := false
        }
        else{
            this.profiles[profileName] := profilePath
            profileAdded := true
        }
        return profileAdded
    }

    changeProfileName(oldName, newName) {

        profileChanged := false

        if (this.isInRegistry(newName)) {
            profileChanged := false
        }
        else{
            if (this.isInRegistry(oldName)) {
                this.profiles[newName] := this.profiles[oldName]
                this.profiles.DeleteKey(oldName)
                profileChanged := true
            }
            else{
                profileChanged := false
            }
        }
        return profileChanged
    }

    removeProfile(profileName) {
        profileDeleted := false
        if (this.isInRegistry(profileName)) {
            this.profiles.DeleteKey(profileName)
            profileDeleted := true
        }
        else{
            profileDeleted := false
        }
        return profileDeleted
    }

    getProfileByName(name) {
        return this.profiles[name]
    }

    ; Returns true if the given profile is already in the registry
    isInRegistry(profile){
        return this.profiles.HasKey(profile.Name)
    }

}