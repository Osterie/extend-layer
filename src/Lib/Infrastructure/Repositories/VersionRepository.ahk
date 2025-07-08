#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Util\JsonParsing\JXON>
#Include <Shared\Logger>

class VersionRepository {

    currentVersion := ""
    latestVersion := ""
    Logger := Logger.getInstance()
    versionFilePath := ""

    __New(versionFilePath := FilePaths.getPathToVersion()) {
        this.versionFilePath := versionFilePath
    }

    updateVersion(newVersion) {
        this.writeVersionToFile(newVersion)
        this.currentVersion := newVersion
    }

    getCurrentVersion() {
        if (this.currentVersion = "") {
            this.currentVersion := this.getVersionFromFile()
        }
        return this.currentVersion
    }

    getVersionFromFile() {

        currentVersion := ""
        jsonVersionObject := this.readVersionFromFile()

        try {
            currentVersion := jsonVersionObject["version"]
        }
        catch {
            this.Logger.logError("Could not read the version from the JSON object. Ensure the 'version' key exists.")
            throw ValueError("Could not read the version from the JSON object. Ensure the 'version' key exists.")
        }
        return currentVersion
    }

    readVersionFromFile() {
        
        if (!FileExist(this.versionFilePath)) {
            this.Logger.logError("Version file does not exist at: " . this.versionFilePath)
            this.writeVersionToFile("unknown")
            return this.createUnknownVersionObject()
        }
        
        jsonVersionObject := ""
        try {
            jsonStringCurrentVersion := FileRead(this.versionFilePath, "UTF-8")
            jsonVersionObject := this.convertFileContentsToObject(jsonStringCurrentVersion)
        }
        catch {
            this.Logger.logError("Could not read the file: " . this.versionFilePath . " Writing default version, unknown.")
            this.writeVersionToFile("unknown")
            jsonVersionObject := this.createUnknownVersionObject()
        }

        return jsonVersionObject
    }

    convertFileContentsToObject(versionFileContents) {
        if (versionFileContents = "") {
            this.Logger.logError("The version file is empty.")
            throw ValueError("The version file is empty.")
        }
        jsonVersionObject := jxon_load(&versionFileContents)
        return jsonVersionObject
    }

    writeVersionToFile(version) {
        jsonVersionObject := this.createJsonVersionObject(version)

        try {
            FileDelete(this.versionFilePath)
            FileAppend(jxon_dump(jsonVersionObject), this.versionFilePath, "UTF-8")
        }
        catch {
            this.Logger.logError("Could not write the version to the file: " . this.versionFilePath)
            throw Error("Could not write the version to the file: " . this.versionFilePath)
        }
    }

    createJsonVersionObject(version) {
        if (version = "") {
            this.Logger.logError("Version cannot be empty.")
            throw ValueError("Version cannot be empty.")
        }
        
        jsonVersionObject := Map()
        jsonVersionObject["version"] := version
        return jsonVersionObject
    }

    createUnknownVersionObject() {
        return this.createJsonVersionObject("unknown")
    }
}
