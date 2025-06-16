#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>

#Include <Util\Version>
#Include <Util\Downloader>
#Include <Util\Logging\Logger>
#Include <Util\FileOverwriteManager>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

class AutoUpdater {
    static instance := false
    Version := Version.getInstance()
    Logger := Logger.getInstance()
    releaseChecker := ""  ; Instance of GithubReleaseChecker to check for updates

    LATEST_RELEASE_DOWNLOAD_LOCATION := A_Temp "\extend-layer-update"  ; Default download location for the latest release
    CURRENT_VERSION_TEMPORARY_LOCATION := A_Temp "\extend-layer-temporary"  ; Temporary location for the current version

    ; Paths to original updater and location to copy it to. Updater is launched from the temporary location.
    ; Since it is not possible to update the running script, we need to copy the updater to a temporary location and run it from there.
    ORIGINAL_UPDATER_LOCATION := A_ScriptDir "\Lib\Updater\Updater.exe"
    TEMPORARY_UPDATER_LOCATION := A_Temp "\Updater.exe"

    __New() {
        currentVersion := this.Version.GetCurrentVersion()
        this.releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
    }

    static getInstance() {
        if (!AutoUpdater.instance) {
            AutoUpdater.instance := AutoUpdater()
        }
        return AutoUpdater.instance
    }

    checkForUpdates() {
        updateAvailable := this.releaseChecker.updateAvailable()
        if (!updateAvailable) {
            return false ; No updates available
        }

        try{
            this.updateExtendLayer()
        }
        catch Error as e {
            this.Logger.logError("Failed to update current version: " e.Message, "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to update current version: " e.Message)
        }
    }

    updateExtendLayer() {
        this.downloadLatestRelease()
        this.copyCurrentVersionToTemporaryLocation()
        this.updateVersionInTemporaryLocation()
        this.updateCurrentVersion()
    }

    downloadLatestRelease() {
        downloadUrl := this.releaseChecker.GetDownloadUrl()
        zipDownloadLocation := this.LATEST_RELEASE_DOWNLOAD_LOCATION . ".zip" ; Ensure the download location has a .zip extension
        unzippedDownloadLocation := this.LATEST_RELEASE_DOWNLOAD_LOCATION ; Location where the ZIP will be unzipped

        Downloader_ := Downloader()
        ; Downloads and unzips the latest release from the provided URL
        Downloader_.DownloadZip(downloadUrl, zipDownloadLocation, unzippedDownloadLocation, true)
    }

    copyCurrentVersionToTemporaryLocation() {
        if (DirExist(this.CURRENT_VERSION_TEMPORARY_LOCATION)) {
            DirDelete(this.CURRENT_VERSION_TEMPORARY_LOCATION, true) ; true = recursive delete
        }

        ; Copy the current version to the temporary location
        DirCopy(FilePaths.GetAbsolutePathToRoot(), this.CURRENT_VERSION_TEMPORARY_LOCATION, true) ; true = overwrite
    }

    updateVersionInTemporaryLocation() {
        FileOverwriteManager_ := FileOverwriteManager()
        pathToUnzippedFiles := this.GetPathToUnzippedFiles(this.LATEST_RELEASE_DOWNLOAD_LOCATION)

        try {
            ; TODO try catch to handle recursion errors and other errors. If fail, then dont merge temporary files into new version.
            FileOverwriteManager_.copyIntoNewLocation(pathToUnzippedFiles, this.CURRENT_VERSION_TEMPORARY_LOCATION, FilePaths.getPathToUpdateManifest())
        }
        catch {
            errorMessage := "Failed to overwrite files from unzipped location: " this.LATEST_RELEASE_DOWNLOAD_LOCATION " to temporary location: " this.CURRENT_VERSION_TEMPORARY_LOCATION
            this.Logger.logError(errorMessage, "AutoUpdater.ahk", A_LineNumber)
            throw Error(errorMessage . " Line: " . A_LineNumber)
        }
    }

    updateCurrentVersion(){
        this.prepareUpdaterExecutable()
        this.runUpdaterExe() ; Run updater from temporary location and exit current app
    }

    prepareUpdaterExecutable(){
        if (!FileExist(this.ORIGINAL_UPDATER_LOCATION)) {
            this.Logger.logError("Updater.exe does not exist in the expected location: " this.ORIGINAL_UPDATER_LOCATION)
            throw Error("Updater.exe does not exist in the expected location: " this.ORIGINAL_UPDATER_LOCATION)
        }
        
        processSuccessfullyClosed := closeProcess("Updater.exe")
        if (!processSuccessfullyClosed) {
            this.Logger.logError("Failed to close Updater.exe before copying.")
            throw Error("Failed to close Updater.exe before copying.")
        }
        
        try {
            ; Delete the temporary updater if it exists
            if (FileExist(this.TEMPORARY_UPDATER_LOCATION)) {
                FileDelete(this.TEMPORARY_UPDATER_LOCATION)
            }
            FileCopy(this.ORIGINAL_UPDATER_LOCATION, this.TEMPORARY_UPDATER_LOCATION, true) ; true = overwrite if exists
        }
        catch Error as e {
            this.Logger.logError("Failed to copy Updater.exe to temporary location: " e.Message, "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to copy Updater.exe to temporary location: " e.Message)
        }

        ; Confirm updater was copied successfully to the temporary location
        if !FileExist(this.TEMPORARY_UPDATER_LOCATION) {
            this.Logger.logError("Failed to copy Updater.exe to temp directory.")
            throw Error("Failed to copy Updater.exe to temp directory.")
        }
    }

    ; This method is used to run the updater executable with the provided arguments.
    runUpdaterExe() {

        if !FileExist(this.TEMPORARY_UPDATER_LOCATION) {
            this.Logger.logError("Failed to copy Updater.exe to temp directory.")
            throw Error("Failed to copy Updater.exe to temp directory.")
        }
        
        ; Command line arguments to pass to the updater executable
        temporaryLocation := this.CURRENT_VERSION_TEMPORARY_LOCATION
        mainScript := A_ScriptFullPath
        rootPath := FilePaths.GetAbsolutePathToRoot()
        version := this.releaseChecker.GetLatestVersionInfo()
        
        pathToVersionFile := FilePaths.GetAbsolutePathToRoot() . "config\Version.json"
        pathToControlScript := FilePaths.GetAbsolutePathToRoot() . "src\controlScript.exe"
        
        pid := DllCall("GetCurrentProcessId", "UInt")

        ; Build command-line arguments
        args := '"' temporaryLocation '" "' rootPath '" "' pid '" "' mainScript '" "' version '" "' pathToVersionFile '" "' pathToControlScript '"'

        ; Run updater from temporary location with given argumetns
        Run '"' this.TEMPORARY_UPDATER_LOCATION '" ' args

        ; Exit the current script after running the updater, which is responsible for updating the current version.
        ExitApp
    }

    GetPathToUnzippedFiles(unzipLocation) {
        if (!FileExist(unzipLocation)) {
            this.Logger.logError("Unzipped location does not exist: " unzipLocation)
            throw Error("Unzipped location does not exist: " unzipLocation)
        }

        foundPath := ""
        index := 1
        loop files, unzipLocation . "\*", "D" {
            foundPath := A_LoopFileFullPath
            index += 1
        }

        if (index > 2) {
            this.Logger.logError("Multiple directories found in unzipped location: " unzipLocation)
            throw Error("Multiple directories found in unzipped location: " unzipLocation)
        }

        return foundPath
    }
}

; TODO move, to processmanager.ahk?
closeProcess(process) {
    DetectHiddenWindows(true)
    tries := 0
    while (ProcessExist(process) && tries < 10) {
        pid := ProcessExist(process)
        if pid {
            ProcessClose(pid)
            Sleep 500 ; Wait for 0.5 seconds
            tries++
            if !ProcessExist(process) {
                return true
            }
        }
    }
    if !ProcessExist(process) {
        return true
    }
    return false
}
