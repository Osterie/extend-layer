#Requires AutoHotkey v2.0

class ProfilesRegistry {
    
    profiles := {}
    
    __New() {
        this.profiles := {}
    }

    addProfile(profileName, profilePath) {
        profileAdded := false
        if (this.isAlreadyInRegistry(profileName)) {
            profileAdded := false
        }
        else{
            this.profiles[profileName] := profilePath
            profileAdded := true
        }
        return profileAdded
    }

    GetProfileByName(name) {
        return this.profiles[name]
    }

    ; Returns true if the given profile is already in the registry
    isAlreadyInRegistry(profile){
        return this.profiles.HasKey(profile.Name)
    }

}