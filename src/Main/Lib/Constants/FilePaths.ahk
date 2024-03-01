class FilePaths{

    static OBJECT_INFO := "..\..\config\ObjectInfo.json"

    static PATH_TO_META_INI_FILE := "..\..\config\meta.ini"


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

}