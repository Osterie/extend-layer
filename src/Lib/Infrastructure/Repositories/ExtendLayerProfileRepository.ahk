#Requires AutoHotkey v2.0

#Include <Infrastructure\IO\ExtendLayerProfileFileReader>

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <Shared\Logger>

; Handles operations for the current ExtendLayerProfile, such as changing hotkeys, getting layers, getting hotkeys for layers, etc.
; Also handles reading from and writing to file.
class ExtendLayerProfileRepository {

    Logger := Logger.getInstance()
    ExtendLayerProfileFileReader := ""

    __New(userProfilesMode := true){
        this.ExtendLayerProfileFileReader := ExtendLayerProfileFileReader(userProfilesMode)
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
