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

    GetCurrentVersion() {
        if (this.currentVersion = "") {
            try{
                this.currentVersion := this.GetVersionFromFile()
            }
            catch{
                this.Logger.logError("Could not read the current version from the file. Using default version.")
                throw ValueError("Could not read the current version from the file. Using default version.")
            }
        }
        return this.currentVersion
    }

    GetVersionFromFile() {

        jsonVersionObject := this.ReadVersionFromFile()

        currentVersion := ""

        try {
            currentVersion := jsonVersionObject["version"]
        }
        catch {
            this.Logger.logError("Could not read the version from the JSON object. Ensure the 'version' key exists.")
            throw ValueError("Could not read the version from the JSON object. Ensure the 'version' key exists.")
        }
        return currentVersion
    }

    ReadVersionFromFile() {
        versionFilePath := FilePaths.getPathToVersion()
        if (!FileExist(versionFilePath)) {
            this.Logger.logError("Version file does not exist at: " . versionFilePath)
            throw Error("Version file does not exist at: " . versionFilePath)
        }
        
        jsonVersionObject := ""
        try {
            jsonStringCurrentVersion := FileRead(versionFilePath, "UTF-8")
        }
        catch {
            this.Logger.logError("Could not read the file: " . versionFilePath)
            throw ValueError("Could not read the file: " . versionFilePath)
        }
        jsonVersionObject := jxon_load(&jsonStringCurrentVersion)

        if (jsonVersionObject = "") {
            this.Logger.logError("The version file is empty or could not be parsed: " . versionFilePath)
            throw ValueError("The version file is empty or could not be parsed.")
        }

        return jsonVersionObject
    }

    UpdateVersion(newVersion) {
        if (newVersion = "") {
            this.Logger.logError("New version cannot be empty.")
            throw ValueError("New version cannot be empty.")
        }
        this.currentVersion := newVersion


        jsonVersionObject := Map()
        jsonVersionObject["version"] := newVersion

        try {
            FileDelete(FilePaths.getPathToVersion())
            FileAppend(jxon_dump(jsonVersionObject), FilePaths.getPathToVersion(), "UTF-8")
        }
        catch {
            this.Logger.logError("Could not write the new version to the file: " . FilePaths.getPathToVersion())
            throw ValueError("Could not write the new version to the file: " . FilePaths.getPathToVersion())
        }
    }
}
