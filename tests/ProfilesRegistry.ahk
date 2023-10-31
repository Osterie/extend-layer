#Requires AutoHotkey v2.0

class ProfilesRegistry {

    profiles := ""
    
    __New() {
        this.profiles := Map()
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
                this.profiles.Delete(oldName)
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
            this.profiles.Delete(profileName)
            profileDeleted := true
        }
        else{
            profileDeleted := false
        }
        return profileDeleted
    }

    getProfilePathByName(profileName) {
        return this.profiles[profileName]
    }

    getProfileNames() {
        profileNames := []
        for key in this.profiles {
            profileNames.Push(key)
        }
        return profileNames
    }

    ; Returns true if the given profile is already in the registry
    isInRegistry(profileName){
        return this.profiles.Has(profileName)
    }

}