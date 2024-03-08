class FilePaths{

    static PATH_TO_META_INI_FILE := "../../config/meta.ini"

    static CURRENT_PROFILE := "EmptyProfile"
    static DEFAULT_PROFILE := "Default"

    static OBJECT_INFO := "../../config/ObjectInfo.json"
    static KEY_NAMES := "../../resources/keyNames.txt"

    static PATH_TO_PRESET_PROFILES := "../../config/PresetProfiles"
    static PATH_TO_PROFILES := "../../config/UserProfiles/"

    static PATH_TO_EMPTY_PROFILE := "../../config/PresetProfiles/EmptyProfile"
    static PATH_TO_EMPTY_KEYBOARD_PROFILE := "../../config/PresetProfiles/EmptyProfile/Keyboards.json"
    static PATH_TO_EMPTY_SETTINGS_PROFILE := "../../config/PresetProfiles/EmptyProfile/ClassObjects.ini"


    static GetPathToCurrentKeyboardLayout(){
        PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.GetPathToCurrentProfile() . "/Keyboards.json"
        if (FileExist(PATH_TO_CURRENT_KEYBOARD_LAYOUT) = false){
            PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.GetPathToEmptyKeyboardProfile()
        }
        return PATH_TO_CURRENT_KEYBOARD_LAYOUT
    }

    static GetPathToCurrentSettings(){
        PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.GetPathToCurrentProfile() . "/ClassObjects.ini"
        if (FileExist(PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE) = false){
            PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.GetPathToEmptySettingsProfile()
        }
        return PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE
    }

    static SetCurrentProfile(currentProfileName){
        iniWrite(currentProfileName, this.PATH_TO_META_INI_FILE, "General", "activeUserProfile")
    }

    static GetCurrentProfile(){
        try{
            this.CURRENT_PROFILE := iniRead(this.GetPathToMetaFile(), "General", "activeUserProfile")
        }
        catch{
            if (FileExist(this.PATH_TO_PROFILES . this.DEFAULT_PROFILE)){
                this.CURRENT_PROFILE := this.DEFAULT_PROFILE
            }
            else{
                this.CURRENT_PROFILE := "EmptyProfile"
            }
        }
        
        return this.CURRENT_PROFILE
    }

    static GetPathToCurrentProfile(){
        PATH_TO_CURRENT_PROFILE := this.getPathToProfiles() . this.GetCurrentProfile()
        if (FileExist(PATH_TO_CURRENT_PROFILE) = false){
            PATH_TO_CURRENT_PROFILE := this.GetPathToEmptyProfile()
        }
        return PATH_TO_CURRENT_PROFILE
    }

    static GetPathToEmptyKeyboardProfile(){
        return this.PATH_TO_EMPTY_KEYBOARD_PROFILE
    }
    
    static GetPathToEmptySettingsProfile(){
        return this.PATH_TO_EMPTY_SETTINGS_PROFILE
    }

    static GetPathToKeyNames(){
        return this.KEY_NAMES
    }

    static GetPathToEmptyProfile(){
        return this.PATH_TO_EMPTY_PROFILE
    }

    static GetPathToPresetProfiles(){
        return this.PATH_TO_PRESET_PROFILES
    }
    
    static GetPathToMetaFile(){
        return this.PATH_TO_META_INI_FILE
    }

    static GetObjectInfo(){
        return this.OBJECT_INFO
    }

    static GetPathToProfiles(){
        return this.PATH_TO_PROFILES
    }
}