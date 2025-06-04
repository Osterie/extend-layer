#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Logging\Logger>

class UpdateManifest {
    static theSingleInstance := 0

    updateManifestInfo := ""

    Logger := Logger.getInstance()

    __New() {
    }

    static getInstance() {
        if (IsObject(UpdateManifest.theSingleInstance) = 0) {
            UpdateManifest.theSingleInstance := UpdateManifest() ; Default UpdateManifest
        }
        return UpdateManifest.theSingleInstance
    }

    GetOverwritePaths() {
        updateManifest := this.GetUpdateManifest()
        if (updateManifest = "") {
            this.Logger.logError("UpdateManifest is empty or could not be read.")
            throw ValueError("UpdateManifest is empty or could not be read.")
        }

        overwritePaths := ""

        try{
            overwritePaths := updateManifest["overwrite"]
        }
        catch {
            this.Logger.logError("Could not read 'overwrite' paths from UpdateManifest.")
            throw ValueError("Could not read 'overwrite' paths from UpdateManifest.")
        }

        if (overwritePaths = "") {
            this.Logger.logError("No 'overwrite' paths found in UpdateManifest.")
            throw ValueError("No 'overwrite' paths found in UpdateManifest.")
        }

        if (IsObject(overwritePaths) = false) {
            this.Logger.logError("'overwrite' paths in UpdateManifest are not an object.")
            throw ValueError("'overwrite' paths in UpdateManifest are not an object.")
        }

        return overwritePaths
    }

    GetSkipPaths() {
        updateManifest := this.GetUpdateManifest()
        if (updateManifest = "") {
            this.Logger.logError("UpdateManifest is empty or could not be read.")
            throw ValueError("UpdateManifest is empty or could not be read.")
        }

        skipPaths := ""

        try{
            skipPaths := updateManifest["skip"]
        }
        catch {
            this.Logger.logError("Could not read 'skip' paths from UpdateManifest.")
            throw ValueError("Could not read 'skip' paths from UpdateManifest.")
        }

        if (skipPaths = "") {
            this.Logger.logError("No 'skip' paths found in UpdateManifest.")
            throw ValueError("No 'skip' paths found in UpdateManifest.")
        }

        if (IsObject(skipPaths) = false) {
            this.Logger.logError("'skip' paths in UpdateManifest are not an object.")
            throw ValueError("'skip' paths in UpdateManifest are not an object.")
        }

        return skipPaths
    }

    GetUpdateManifest() {
        if (this.updateManifestInfo = "") {
            try{
                this.updateManifestInfo := this.ReadUpdateManifestFromFile()
            }
            catch{
                this.Logger.logError("Could not read the current UpdateManifest from file.")
                throw ValueError("Could not read the current UpdateManifest from file.")
            }
        }
        return this.updateManifestInfo
    }

    ReadUpdateManifestFromFile() {
        UpdateManifestFilePath := FilePaths.getPathToUpdateManifest()
        if (!FileExist(UpdateManifestFilePath)) {
            this.Logger.logError("UpdateManifest file does not exist at: " . UpdateManifestFilePath)
            throw Error("UpdateManifest file does not exist at: " . UpdateManifestFilePath)
        }

        try {
            updateManifestAsString := FileRead(UpdateManifestFilePath, "UTF-8")
        }
        catch {
            this.Logger.logError("Could not read the file: " . UpdateManifestFilePath)
            throw ValueError("Could not read the file: " . UpdateManifestFilePath)
        }

        jsonUpdateManifestAsJson := jxon_load(&updateManifestAsString)

        if (jsonUpdateManifestAsJson = "") {
            this.Logger.logError("The UpdateManifest file is empty or could not be parsed: " . UpdateManifestFilePath)
            throw ValueError("The UpdateManifest file is empty or could not be parsed.")
        }

        return jsonUpdateManifestAsJson
    }
}
