#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>
#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Logging\Logger>

class Version {
    static theSingleInstance := 0
    currentVersion := ""
    latestVersion := ""
    Logger := Logger.getInstance()

    __New() {
    }

    static getInstance() {
        if (IsObject(Version.theSingleInstance) = 0) {
            Version.theSingleInstance := Version() ; Default version
        }
        return Version.theSingleInstance
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
        versionFilePath := FilePaths.getPathToVersion()
        if (!FileExist(versionFilePath)) {
            this.Logger.logError("Version file does not exist at: " . versionFilePath)
            this.writeVersionToFile("unknown")
            return this.createUnknownVersionObject()
        }
        
        jsonVersionObject := ""
        try {
            jsonStringCurrentVersion := FileRead(versionFilePath, "UTF-8")
            jsonVersionObject := this.convertFileContentsToObject(jsonStringCurrentVersion)
        }
        catch {
            this.Logger.logError("Could not read the file: " . versionFilePath . " Writing default version, unknown.")
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
            FileDelete(FilePaths.getPathToVersion())
            FileAppend(jxon_dump(jsonVersionObject), FilePaths.getPathToVersion(), "UTF-8")
        }
        catch {
            this.Logger.logError("Could not write the version to the file: " . FilePaths.getPathToVersion())
            throw Error("Could not write the version to the file: " . FilePaths.getPathToVersion())
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
