#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>

#Include <Util\JsonParsing\JXON>
#Include <Util\Formaters\JsonFormatter>

#Include <Shared\FilePaths>
#Include <Shared\MetaInfo>
#Include <Shared\Logger>

class ExtendLayerProfileFileReader {

    Logger := Logger.getInstance()

    PATH_TO_PROFILES := ""

    __New(userProfilesMode := true){

        if (userProfilesMode){
            this.PATH_TO_PROFILES := FilePaths.GetPathToProfiles() . "\"
        } 
        else {
            this.PATH_TO_PROFILES := FilePaths.GetPathToPresetProfiles() . "\"
        }
    }


    readExtendLayerProfile(profileName) {

        profilePath := this.constructProfilePath(profileName)

        if (!FileExist(profilePath)) {
            throw ValueError("The specified profile path does not exist: " . profilePath)
        }

        ; TOOO make method for converting to json object.
        jsonString := ""

        try {
            jsonString := FileRead(profilePath, "UTF-8")
        } catch {
            MetaInfo.setCurrentProfile("Empty")
            emptyProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
            jsonString := FileRead(emptyProfilePath, "UTF-8")
            msgbox("Unable to read information for the current profile. Defaulting to an empty profile.")
        }

        extendLayerProfileJsonObject := jxon_load(&jsonString)

        if (extendLayerProfileJsonObject.Has("Description")) {
            description := extendLayerProfileJsonObject["Description"]
        } else {
            extendLayerProfileJsonObject["Description"] := ""
            this.writeExtendLayerProfile(ExtendLayerProfile.fromJson(extendLayerProfileJsonObject, profileName), profileName)
        }

        return ExtendLayerProfile.fromJson(extendLayerProfileJsonObject, profileName)

    }

    writeExtendLayerProfile(ExtendLayerProfile, profileName) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }
        profilePath := this.constructProfilePath(profileName)

        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(ExtendLayerProfile.toJson())

        if (FileExist(profilePath)) {
            FileRecycle(profilePath)
        }
        FileAppend(jsonString, profilePath, "UTF-8")
    }

    constructProfilePath(profileName) {
        return this.PATH_TO_PROFILES . profileName . "\Keyboards.json"
    }
}
