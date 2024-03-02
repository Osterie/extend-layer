class FilePaths{

    static CURRENT_PROFILE := "EmptyProfile"

    static OBJECT_INFO := "../../config/ObjectInfo.json"

    static PATH_TO_META_INI_FILE := "../../config/meta.ini"

    static PATH_TO_PROFILES := "../../config/UserProfiles/"

    static PATH_TO_EMPTY_KEYBOARD_PROFILE := "../../config/PresetProfiles/EmptyProfile/Keyboards.json"

    static PATH_TO_EMPTY_SETTINGS_PROFILE := "../../config/PresetProfiles/EmptyProfile/ClassObjects.ini"

    static PATH_TO_KEYNAMES_FILE := "../../resources/keyNames.txt"

    static PATH_TO_EMPTY_PROFILE := "..\..\config\EmptyProfile"

    static PATH_TO_PRESET_PROFILES := "..\..\config\PresetProfiles"

    ; PATH_TO_META_INI_FILE := "../../config/meta.ini"
    ; PATH_TO_KEYNAMES_FILE := "../../resources/keyNames.txt"

    ; CURRENT_PROFILE_NAME := ""
    ; PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := ""
    ; PATH_TO_CURRENT_KEYBOARD_LAYOUT := ""


    static GetObjectInfo(){
        return this.OBJECT_INFO
    }

    static GetPathToMetaFile(){
        return this.PATH_TO_META_INI_FILE
    }

    static GetPathToProfiles(){
        return this.PATH_TO_PROFILES
    }

    static GetPathToEmptyProfile(){
        return this.PATH_TO_EMPTY_PROFILE
    }

    static GetPathToPresetProfiles(){
        return this.PATH_TO_PRESET_PROFILES
    }

    static GetPathToCurrentKeyboardLayout(currentProfileName := ""){
        if (currentProfileName = ""){
            currentProfileName := this.CURRENT_PROFILE
        }

        PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.PATH_TO_PROFILES . this.CURRENT_PROFILE . "/Keyboards.json"
        return PATH_TO_CURRENT_KEYBOARD_LAYOUT
    }

    static GetPathToCurrentSettings(currentProfileName := ""){
        if (currentProfileName = ""){
            currentProfileName := this.CURRENT_PROFILE
        }
        PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.PATH_TO_PROFILES . this.CURRENT_PROFILE . "/ClassObjects.ini"
        return PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE
    }

    static SetCurrentProfile(currentProfileName){
        this.CURRENT_PROFILE := currentProfileName
        iniWrite(this.CURRENT_PROFILE, this.PATH_TO_META_INI_FILE, "General", "activeUserProfile")
    }

    static GetCurrentProfile(){
        return this.CURRENT_PROFILE
    }

    static GetPathToEmptyKeyboardProfile(){
        return this.PATH_TO_EMPTY_KEYBOARD_PROFILE
    }
    
    static GetPathToEmptySettingsProfile(){
        return this.PATH_TO_EMPTY_SETTINGS_PROFILE
    }

    static GetPathToKeyNames(){
        return this.PATH_TO_KEYNAMES_FILE
    }

}