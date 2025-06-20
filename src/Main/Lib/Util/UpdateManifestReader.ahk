#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Logging\Logger>
#Include <Util\Formaters\PathFormatter>

class UpdateManifestReader {

    updateManifestInfo := ""
    Logger := Logger.getInstance()
    PathFormatter := PathFormatter()

    __New(pathToUpdateManifest) {
        if (!FileExist(pathToUpdateManifest)) {
            this.Logger.logError("UpdateManifest file does not exist at: " . pathToUpdateManifest)
            throw Error("UpdateManifest file does not exist at: " . pathToUpdateManifest)
        }

        this.updateManifestInfo := this.readUpdateManifestFromFile(pathToUpdateManifest)
    }

    getUpdateManifest() {
        return this.updateManifestInfo
    }

    getOverwritePaths() {
        this.getUpdateManifestValue("overwrite")
    }

    getSkipPaths() {
        return this.getUpdateManifestValue("skip")
    }

    getUpdateManifestValue(key) {
        if (this.updateManifestInfo = "") {
            this.Logger.logError("UpdateManifest is empty or could not be read.")
            throw ValueError("UpdateManifest is empty or could not be read.")
        }

        if (!this.updateManifestInfo.HasKey(key)) {
            this.Logger.logError("Key '" . key . "' does not exist in UpdateManifest.")
            throw ValueError("Key '" . key . "' does not exist in UpdateManifest.")
        }

        updateManifestPaths := this.updateManifestInfo[key]
        updateManifestPaths := this.PathFormatter.formatPaths(updateManifestPaths)

        if (updateManifestPaths = []) {
            this.Logger.logWarning("No " . key . " paths found in UpdateManifest.")
        }

        if (Type(updateManifestPaths) != "Array") {
            this.Logger.logError(key . " paths in UpdateManifest are not an array.")
            throw ValueError(key . " paths in UpdateManifest are not an array.")
        }

        return updateManifestPaths
    }

    readUpdateManifestFromFile(updateManifestPath) {
        if (!FileExist(updateManifestPath)) {
            this.Logger.logError("UpdateManifest file does not exist at: " . updateManifestPath)
            throw Error("UpdateManifest file does not exist at: " . updateManifestPath)
        }

        try {
            updateManifestAsString := FileRead(updateManifestPath, "UTF-8")
        }
        catch {
            this.Logger.logError("Could not read the file: " . updateManifestPath)
            throw ValueError("Could not read the file: " . updateManifestPath)
        }

        jsonUpdateManifestAsJson := jxon_load(&updateManifestAsString)

        if (jsonUpdateManifestAsJson = "") {
            this.Logger.logError("The UpdateManifest file is empty or could not be parsed: " . updateManifestPath)
            throw ValueError("The UpdateManifest file is empty or could not be parsed.")
        }

        return jsonUpdateManifestAsJson
    }
}