#Requires AutoHotkey v2.0

#Include <Shared\MetaInfo>
#Include <Infrastructure\IO\IniFileReader>

class FilePaths {


    static KEYBOARD_LAYOUT_FILE_NAME := "Keyboards.json"
    static KEYBOARD_LAYOUT_SETTINGS_FILE_NAME := "ClassObjects.ini"

    ; TODO convert some relative paths to absolute paths. using utlitiy method in UnZipper.ahk
    static PATH_TO_THEMES := "..\config\Themes.json"
    
    static PATH_TO_BACKUPS := "..\backups"

    static PATH_TO_LOGS := "..\logs"

    static PATH_TO_UPDATE_MANIFEST := "..\update-manifest.json"

    static PATH_TO_VERSION := "..\config\Version.json"

    static PATH_TO_META_INI_FILE := "..\config\meta.ini"
    
    static PATH_TO_TEMPORARY_LOCATION := A_Temp . "\EL"

    static ABSOLUTE_PATH_TO_ROOT := A_ScriptDir . "\..\"

    
    static ACTION_GROUPS_INFO := "..\config\ActionGroupsInfo.json"
    
    static KEY_NAMES := "..\resources\keyNames.txt"

    static PATH_TO_PRESET_PROFILES := "..\config\PresetProfiles"
    static PATH_TO_PROFILES := "..\config\UserProfiles"

    static PATH_TO_EMPTY_PROFILE := "..\config\PresetProfiles\EmptyProfile"
    static PATH_TO_EMPTY_KEYBOARD_PROFILE := "..\config\PresetProfiles\EmptyProfile\Keyboards.json"
    static PATH_TO_EMPTY_SETTINGS_PROFILE := "..\config\PresetProfiles\EmptyProfile\ClassObjects.ini"

    static GetPathToLogs() {
        return this.PATH_TO_LOGS
    }

    static getPathToBackups() {
        if (!DirExist(this.PATH_TO_BACKUPS)) {
            DirCreate(this.PATH_TO_BACKUPS)
        }
        return this.PATH_TO_BACKUPS
    }

    static getPathToTemporaryLocation() {
        if (!DirExist(this.PATH_TO_TEMPORARY_LOCATION)) {
            DirCreate(this.PATH_TO_TEMPORARY_LOCATION)
        }
        return this.PATH_TO_TEMPORARY_LOCATION
    }

    static GetAbsolutePathToRoot() {
        return this.ABSOLUTE_PATH_TO_ROOT
    }

    static getPathToVersion() {
        return this.PATH_TO_VERSION
    }

    static getPathToUpdateManifest() {
        return this.PATH_TO_UPDATE_MANIFEST
    }

    static getPathToThemes() {
        return this.PATH_TO_THEMES
    }


    static getPathToCurrentProfile() {
        return FilePaths.getPathToProfiles() . "\" . MetaInfo.getCurrentProfile()
    }

    static getPathToCurrentKeyboardLayout() {
        PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.getPathToCurrentProfile() . "\" . this.KEYBOARD_LAYOUT_FILE_NAME
        if (!FileExist(PATH_TO_CURRENT_KEYBOARD_LAYOUT)) {
            PATH_TO_CURRENT_KEYBOARD_LAYOUT := FilePaths.getPathToEmptyKeyboardProfile()
        }
        return PATH_TO_CURRENT_KEYBOARD_LAYOUT
    }

    static getPathToCurrentSettings() {
        PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.getPathToCurrentProfile() . "\" . this.KEYBOARD_LAYOUT_SETTINGS_FILE_NAME
        if (!FileExist(PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE)) {
            PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := FilePaths.getPathToEmptySettingsProfile()
        }
        return PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE
    }





    static GetPathToEmptyKeyboardProfile() {
        return this.PATH_TO_EMPTY_KEYBOARD_PROFILE
    }

    static GetPathToEmptySettingsProfile() {
        return this.PATH_TO_EMPTY_SETTINGS_PROFILE
    }

    static GetPathToKeyNames() {
        return this.KEY_NAMES
    }

    static GetPathToEmptyProfile() {
        return this.PATH_TO_EMPTY_PROFILE
    }

    static GetPathToPresetProfiles() {
        return this.PATH_TO_PRESET_PROFILES
    }

    static getPathToMetaFile() {
        return this.PATH_TO_META_INI_FILE
    }

    static GetPathToActionGroupsInfo() {
        return this.ACTION_GROUPS_INFO
    }

    static GetPathToProfiles() {
        return this.PATH_TO_PROFILES
    }
}
