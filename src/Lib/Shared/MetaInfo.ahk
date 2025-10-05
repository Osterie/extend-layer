#Requires AutoHotkey v2.0

#Include <Shared\Logger>
#Include <Shared\FilePaths>

#Include <Infrastructure\IO\IniFileReader>

; TODO use MetaInfo class ofr activeTheme, defaultTheme, activeUserProfile, defaultUserProfile and closeScriptOnGuiClose
class MetaInfo {

    static DEFAULT_PROFILE := "Default"
    static FALLBACK_PROFILE := "EmptyProfile"
    
    static GUI_SETTINGS_SECTION := "Gui Settings"
    static CLOSE_SCRIPT_ON_GUI_CLOSE_KEY := "closeScriptOnGuiClose"

    static PROFILES_SECTION := "Profiles"
    static ACTIVE_USER_PROFILE_KEY := "activeUserProfile"

    static DEFAULT_THEME := "GreenIsh"

    static setCurrentProfile(currentProfileName) {
        iniWrite(currentProfileName, FilePaths.getPathToMetaFile(), this.PROFILES_SECTION, this.ACTIVE_USER_PROFILE_KEY)
    }

    static getCurrentProfile() {
        try {
            reader := IniFileReader()
            CURRENT_PROFILE := reader.readOrCreateLine(FilePaths.getPathToMetaFile(), this.PROFILES_SECTION, this.ACTIVE_USER_PROFILE_KEY, this.DEFAULT_PROFILE)
        }
        catch OSError {
            this.setCurrentProfile(this.DEFAULT_PROFILE)
            CURRENT_PROFILE := this.DEFAULT_PROFILE
            Logger.getInstance().logError("Could not read activeUserProfile from meta.ini. Setting to default profile.")
        }
        finally {
            if (FileExist(FilePaths.GetPathToProfiles() . "\" . CURRENT_PROFILE)) {
                ; All good.
            }
            else if (!FileExist(FilePaths.GetPathToProfiles() . "\" . CURRENT_PROFILE)) {
                ; Something went wrong, set current profile to default as a fallback.
                CURRENT_PROFILE := this.DEFAULT_PROFILE
                Logger.getInstance().logWarning("Current profile set in meta.ini does not exist. Setting to default profile.")
            }
            else {
                ; Something went wrong, set current profile to fallback as a last resort.
                CURRENT_PROFILE := this.FALLBACK_PROFILE
                Logger.getInstance().logError("Failed to use default profile. Setting to fallback profile.")
            }
        }

        return CURRENT_PROFILE
    }

    static setCloseScriptOnGuiClose(closeScript) {
        if (closeScript != 1 && closeScript != 0) {
            MsgBox("Invalid value for exitAppOnGuiClose. Must be either 1 or 0")
            return
        }
        iniWrite(closeScript, FilePaths.getPathToMetaFile(), this.GUI_SETTINGS_SECTION, this.CLOSE_SCRIPT_ON_GUI_CLOSE_KEY)
    }

    static getCloseScriptOnGuiClose() {
        reader := IniFileReader()
        return reader.readOrCreateLine(FilePaths.getPathToMetaFile(), this.GUI_SETTINGS_SECTION, this.CLOSE_SCRIPT_ON_GUI_CLOSE_KEY, "1")
    }

    static setCurrentTheme(currentTheme) {
        if (Type(currentTheme) != "String" || currentTheme == "") {
            MsgBox("Invalid value for currentTheme. Must be a non-empty string")
            return
        }
        iniWrite(currentTheme, FilePaths.getPathToMetaFile(), "Themes", "activeTheme")
    }

    static getCurrentTheme() {
        reader := IniFileReader()
        return reader.readOrCreateLine(FilePaths.getPathToMetaFile(), "Themes", "activeTheme", this.DEFAULT_THEME)
    }

    static getDefaultTheme() {
        return this.DEFAULT_THEME
    }
}
