#Requires AutoHotkey v2.0

#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Logging\Logger>

class UpdateManifestReader {

    updateManifestInfo := ""
    Logger := Logger.getInstance()
    updateManifestPath := ""

    __New(pathToUpdateManifest) {
        if (!FileExist(pathToUpdateManifest)) {
            this.Logger.logError("UpdateManifest file does not exist at: " . pathToUpdateManifest)
            throw Error("UpdateManifest file does not exist at: " . pathToUpdateManifest)
        }

        this.updateManifestPath := pathToUpdateManifest
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
            overwritePaths := this.FormatPaths(overwritePaths)
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

        skipPaths := []

        try{
            skipPaths := updateManifest["skip"]
            skipPaths := this.FormatPaths(skipPaths)
        }
        catch {
            this.Logger.logError("Could not read 'skip' paths from UpdateManifest.")
            throw ValueError("Could not read 'skip' paths from UpdateManifest.")
        }

        if (skipPaths = []) {
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
        if (!FileExist(this.updateManifestPath)) {
            this.Logger.logError("UpdateManifest file does not exist at: " . this.updateManifestPath)
            throw Error("UpdateManifest file does not exist at: " . this.updateManifestPath)
        }

        try {
            updateManifestAsString := FileRead(this.updateManifestPath, "UTF-8")
        }
        catch {
            this.Logger.logError("Could not read the file: " . this.updateManifestPath)
            throw ValueError("Could not read the file: " . this.updateManifestPath)
        }

        jsonUpdateManifestAsJson := jxon_load(&updateManifestAsString)

        if (jsonUpdateManifestAsJson = "") {
            this.Logger.logError("The UpdateManifest file is empty or could not be parsed: " . this.updateManifestPath)
            throw ValueError("The UpdateManifest file is empty or could not be parsed.")
        }

        return jsonUpdateManifestAsJson
    }

    FormatPaths(paths){
        Loop paths.Length {
            paths[A_Index] := this.NormalizePath(paths[A_Index])
        }
        return paths
    }

    ; Remove trailing backslashes (except for root like "C:\")
    ; Replace forward slashes with backslashes
    ; Replace double backslashes with single backslash
    NormalizePath(path) {
        pathLengthBefore := StrLen(path)
        if (InStr(path, "/")){
            this.Logger.logInfo("Path contains forward slashes, normalizing: " . path)
        }
        path := StrReplace(path, "/", "\") ; Replace forward slashes with backslashes
        path := StrReplace(path, "\\", "\") ; Replace double backslashes with single backslash

        while (StrLen(path) > 3 && SubStr(path, -1) == "\"){
            path := SubStr(path, 1, -1)
        }
        
        pathLengthAfter := StrLen(path)
        if (pathLengthAfter < pathLengthBefore) {
            this.Logger.logInfo("Normalized path: " . path)
        }
        return path
    }
}