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
    ExtendLayerProfileFileReader := ExtendLayerProfileFileReader()

    static getInstance() {
        if (ExtendLayerProfileRepository.instance = false) {
            ExtendLayerProfileRepository.instance := true
            ExtendLayerProfileRepository.instance := ExtendLayerProfileRepository()
        }
        return ExtendLayerProfileRepository.instance
    }

    getProfile(profileName) {
        return this.ExtendLayerProfileFileReader.readExtendLayerProfile(profileName)
    }

    ; ---------------------------------------------
    ; --------------- Write to file ---------------
    ; ---------------------------------------------

    save(ExtendLayerProfile, profileName) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }

        this.ExtendLayerProfileFileReader.writeExtendLayerProfile(ExtendLayerProfile, profileName)
    }
}
