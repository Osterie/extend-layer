#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\ExtendLayerProfileFileReader>

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotkeyLayer>

#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayElement>
#Include <DataModels\KeyboardLayouts\KeyboardOverlayLayer\KeyboardOverlayLayer>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

; Handles operations for the current ExtendLayerProfile, such as changing hotkeys, getting layers, getting hotkeys for layers, etc.
; Also handles reading from and writing to file.
class ExtendLayerProfileRepository {

    static instance := false
    
    Logger := Logger.getInstance()
    ExtendLayerProfile := ExtendLayerProfile()
    ExtendLayerProfileFileReader := ExtendLayerProfileFileReader()

    __New() {
        this.load()
    }

    static getInstance() {
        if (ExtendLayerProfileRepository.instance = false) {
            ExtendLayerProfileRepository.instance := true
            ExtendLayerProfileRepository.instance := ExtendLayerProfileRepository()
        }
        return ExtendLayerProfileRepository.instance
    }

    getProfile(profileName) {
        profilePath := FilePaths.GetPathToProfiles() . "\" . profileName . "\Keyboards.json"
        return this.ExtendLayerProfileFileReader.readExtendLayerProfile(profilePath)
    }

    ; ---------------------------------------------
    ; ----- Read from file / write to file --------
    ; ---------------------------------------------

    load() {
        currentProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
        this.ExtendLayerProfile := this.ExtendLayerProfileFileReader.readExtendLayerProfile(currentProfilePath)
    }

    save(ExtendLayerProfile) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }
        currentProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
        this.ExtendLayerProfileFileReader.writeExtendLayerProfile(ExtendLayerProfile, currentProfilePath)
    }
}
