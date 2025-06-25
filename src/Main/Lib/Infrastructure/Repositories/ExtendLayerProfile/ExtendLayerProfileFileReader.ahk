#Requires AutoHotkey v2.0

#Include <DataModels\KeyboardLayouts\ExtendLayerProfile>
#Include <Infrastructure\Repositories\ExtendLayerProfile\ExtendLayerProfileMapper>

#Include <Util\JsonParsing\JXON>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class ExtendLayerProfileFileReader {

    Logger := Logger.getInstance()

    ; TODO does not need to be field probably.
    ExtendLayerProfile := ExtendLayerProfile()

    readExtendLayerProfile(profilePath) {
        if (!FileExist(profilePath)) {
            throw ValueError("The specified profile path does not exist: " . profilePath)
        }

        ; TOOO make method for converting to json object.
        jsonString := ""

        try {
            jsonString := FileRead(profilePath, "UTF-8")
        } catch {
            FilePaths.SetCurrentProfile("Empty")
            emptyProfilePath := FilePaths.GetPathToCurrentKeyboardLayout()
            jsonString := FileRead(emptyProfilePath, "UTF-8")
            msgbox("Unable to read information for the current profile. Defaulting to an empty profile.")
        }

        extendLayerProfileJsonObject := jxon_load(&jsonString)

        ExtendLayerProfileMapper_ := ExtendLayerProfileMapper()
        this.ExtendLayerProfile := ExtendLayerProfileMapper_.MapToDomainClass(extendLayerProfileJsonObject)

        return this.ExtendLayerProfile

    }

    writeExtendLayerProfile(ExtendLayerProfile, profilePath) {
        if (Type(ExtendLayerProfile) != "ExtendLayerProfile") {
            this.Logger.logError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
            throw TypeError("The provided ExtendLayerProfile must be an instance of ExtendLayerProfile.")
        }
        if (!FileExist(profilePath)) {
            this.Logger.logError("The specified profile path does not exist: " . profilePath)
            throw ValueError("The specified profile path does not exist: " . profilePath)
        }
        formatterForJson := JsonFormatter()
        jsonString := formatterForJson.FormatJsonObject(ExtendLayerProfile.toJson())

        FileRecycle(profilePath)
        FileAppend(jsonString, profilePath, "UTF-8")
    }
}
