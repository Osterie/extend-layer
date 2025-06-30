#Requires AutoHotkey v2.0

class FilePaths {

    ; TODO convert some relative paths to absolute paths. using utlitiy method in UnZipper.ahk
    static PATH_TO_THEMES := "..\..\config\Themes.json"
    
    static PATH_TO_BACKUPS := "..\..\backups"

    static PATH_TO_LOGS := "..\..\logs"

    static PATH_TO_UPDATE_MANIFEST := "..\..\update-manifest.json"

    static PATH_TO_VERSION := "..\..\config\Version.json"

    static PATH_TO_META_INI_FILE := "..\..\config\meta.ini"

    static DEFAULT_PROFILE := "Default"
    
    static PATH_TO_TEMPORARY_LOCATION := A_Temp . "\extend-layer"

    static ABSOLUTE_PATH_TO_ROOT := A_ScriptDir . "\..\..\"

    
    static ACTION_GROUPS_INFO := "..\..\config\ActionGroupsInfo.json"
    
    static KEY_NAMES := "..\..\resources\keyNames.txt"

    static PATH_TO_PRESET_PROFILES := "..\..\config\PresetProfiles"
    static PATH_TO_PROFILES := "..\..\config\UserProfiles"

    static PATH_TO_EMPTY_PROFILE := "..\..\config\PresetProfiles\EmptyProfile"
    static PATH_TO_EMPTY_KEYBOARD_PROFILE := "..\..\config\PresetProfiles\EmptyProfile\Keyboards.json"
    static PATH_TO_EMPTY_SETTINGS_PROFILE := "..\..\config\PresetProfiles\EmptyProfile\ClassObjects.ini"

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

    static GetThemes() {
        return this.PATH_TO_THEMES
    }

    static GetDefaultTheme() {
        DEFAULT_THEME := iniRead(this.GetPathToMetaFile(), "Themes", "defaultTheme")
        return DEFAULT_THEME
    }

    static SetCurrentTheme(currentTheme) {
        iniWrite(currentTheme, this.PATH_TO_META_INI_FILE, "Themes", "activeTheme")
    }

    ; TODO this should not be like this! move to repository for themes or something.
    static GetCurrentTheme() {
        try {
            CURRENT_THEME := iniRead(this.GetPathToMetaFile(), "Themes", "activeTheme")
        }
        catch OSError {
            this.SetCurrentTheme(this.GetDefaultTheme())
            CURRENT_THEME := this.GetDefaultTheme()
        }

        return CURRENT_THEME
    }

    static SetCloseScriptOnGuiClose(closeScript) {
        if (closeScript != 1 && closeScript != 0) {
            MsgBox("Invalid value for exitAppOnGuiClose. Must be either true or false")
            return
        }
        iniWrite(closeScript, this.PATH_TO_META_INI_FILE, "Gui Settings", "closeScriptOnGuiClose")
    }

    static GetCloseScriptOnGuiClose() {
        try {
            closeScript := iniRead(this.GetPathToMetaFile(), "Gui Settings", "closeScriptOnGuiClose")
        }
        catch OSError {
            MsgBox("Could not read closeScriptOnGuiClose from meta.ini. Action setting to default value.")
            this.SetCloseScriptOnGuiClose(0)
            closeScript := 0
        }
        return closeScript
    }

    static GetPathToCurrentKeyboardLayout() {
        PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.GetPathToCurrentProfile() . "\Keyboards.json"
        if (FileExist(PATH_TO_CURRENT_KEYBOARD_LAYOUT) = false) {
            PATH_TO_CURRENT_KEYBOARD_LAYOUT := this.GetPathToEmptyKeyboardProfile()
        }
        return PATH_TO_CURRENT_KEYBOARD_LAYOUT
    }

    static GetPathToCurrentSettings() {
        PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.GetPathToCurrentProfile() . "\ClassObjects.ini"
        if (FileExist(PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE) = false) {
            PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE := this.GetPathToEmptySettingsProfile()
        }
        return PATH_TO_CLASS_OBJECTS_FOR_CURRENT_PROFILE
    }

    static SetCurrentProfile(currentProfileName) {
        iniWrite(currentProfileName, this.PATH_TO_META_INI_FILE, "Profiles", "activeUserProfile")
    }

    ; TODO file paths should not do this. Also add error logging.
    static GetCurrentProfile() {
        try {
            CURRENT_PROFILE := iniRead(this.GetPathToMetaFile(), "Profiles", "activeUserProfile")
        }
        catch OSError {
            this.SetCurrentProfile(this.DEFAULT_PROFILE)
            CURRENT_PROFILE := this.DEFAULT_PROFILE
        }
        finally {
            if (FileExist(this.PATH_TO_PROFILES . "\" . CURRENT_PROFILE)) {
                ; do nothing
            }
            else if (!FileExist(this.PATH_TO_PROFILES . "\" . CURRENT_PROFILE)) {
                CURRENT_PROFILE := this.DEFAULT_PROFILE
            }
            else {
                CURRENT_PROFILE := "EmptyProfile"
            }
        }

        return CURRENT_PROFILE
    }

    static GetPathToCurrentProfile() {
        PATH_TO_CURRENT_PROFILE := this.getPathToProfiles() . "\" . this.GetCurrentProfile()
        if (!FileExist(PATH_TO_CURRENT_PROFILE)) {
            PATH_TO_CURRENT_PROFILE := this.GetPathToEmptyProfile()
        }
        else if (!FileExist(PATH_TO_CURRENT_PROFILE . "*")) {
            PATH_TO_CURRENT_PROFILE := this.GetPathToEmptyProfile()
        }

        return PATH_TO_CURRENT_PROFILE
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

    static GetPathToMetaFile() {
        return this.PATH_TO_META_INI_FILE
    }

    static GetPathToActionGroupsInfo() {
        return this.ACTION_GROUPS_INFO
    }

    static GetPathToProfiles() {
        return this.PATH_TO_PROFILES
    }
}
