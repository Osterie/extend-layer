class FilePaths{

    static OBJECT_INFO := "..\..\config\ObjectInfo.json"

    static PATH_TO_META_INI_FILE := "..\..\config\meta.ini"

    static PATH_TO_PROFILES := "../../config/UserProfiles/"

    static PATH_TO_EMPTY_KEYBOARD_PROFILE := "../../config/PresetProfiles/EmptyProfile/Keyboards.json"

    static PATH_TO_EMPTY_SETTINGS_PROFILE := "../../config/PresetProfiles/EmptyProfile/ClassObjects.ini"

    static PATH_TO_KEYNAMES_FILE := "..\..\resources\keyNames.txt"


    ; PATH_TO_META_INI_FILE := "..\..\config\meta.ini"
    ; PATH_TO_KEYNAMES_FILE := "..\..\resources\keyNames.txt"

    ; CURRENT_PROFILE_NAME := ""
    ; PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := ""
    ; PATH_TO_CURRENT_KEYBOARD_LAYOUT := ""


    static GetObjectInfo(){
        return this.OBJECT_INFO
    }

    static GetPathToMetaFile(){
        return this.PATH_TO_META_INI_FILE
    }

    static GetPathToCurrentKeyboardLayout(currentProfileName){
        PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.PATH_TO_PROFILES . currentProfileName . "/Keyboards.json"
        return PATH_TO_CURRENT_KEYBOARD_LAYOUT
    }

    static GetPathToCurrentSettings(currentProfileName){
        PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.PATH_TO_PROFILES . currentProfileName . "/ClassObjects.ini"
        return PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE
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