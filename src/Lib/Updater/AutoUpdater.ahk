#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>
#Include <Updater\UpdaterRunner>

#Include <Infrastructure\Repositories\VersionRepository>
#Include <Infrastructure\IO\FileOverwriteManager>

#Include <Util\Errors\NetworkError>
#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\NetworkUtils\Downloading\Downloader>
#Include <Backups\BackupManager>

#Include <ui\util\ProgressBar>

#Include <Shared\Logger>
#Include <Shared\FilePaths>


class AutoUpdater {
    static instance := false
    Version := VersionRepository()
    Logger := Logger.getInstance()
    releaseChecker := ""  ; Instance of GithubReleaseChecker to check for updates

    BackupManager := BackupManager()  ; Instance of BackupManager to handle backups

    LATEST_RELEASE_DOWNLOAD_LOCATION := FilePaths.getPathToTemporaryLocation() . "\ELU"  ; Default download location for the latest release. Shortened from "\extend-layer-update" to "\ELU"
    CURRENT_VERSION_TEMPORARY_LOCATION := FilePaths.getPathToTemporaryLocation() . "\ELT"  ; Temporary location for the current version. Shortened from "\extend-layer-temporary" to "\ELT"

    ; Throws NetworkError if no internet connection is available
    __New() {
        this.releaseChecker := GithubReleaseChecker("Osterie", "extend-layer")
    }

    static getInstance() {
        if (!AutoUpdater.instance) {
            AutoUpdater.instance := AutoUpdater()
        }
        return AutoUpdater.instance
    }

    updateAvailable() {
        return this.releaseChecker.updateAvailable(this.Version.getCurrentVersion())
    }

    updateExtendLayer() {
        ProgressBar_ := ProgressBar("Preparing Extend Layer update...")

        ProgressBar_.updateProgress("Downloading latest release...", 20)
        this.downloadLatestRelease()
        
        ProgressBar_.updateProgress("Creating backup...", 40)
        this.BackupManager.createBackup()

        ProgressBar_.updateProgress("Copying current version to temporary location...", 60)
        this.copyCurrentVersionToTemporaryLocation()

        ProgressBar_.updateProgress("Updating version in temporary location...", 80)
        this.updateVersionInTemporaryLocation()

        ProgressBar_.updateProgress("Updating current version...", 100)
        this.updateCurrentVersion()
        ProgressBar_.destroy()
    }
    
    downloadLatestRelease() {
        if (!NetworkChecker.isConnectedToInternet()){
            throw NetworkError()
        }
        downloadUrl := this.releaseChecker.getDownloadUrl()
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
        pathToUnzippedFiles := this.getPathToUnzippedFiles(this.LATEST_RELEASE_DOWNLOAD_LOCATION)

        try {
            FileOverwriteManager_.copyIntoNewLocation(pathToUnzippedFiles, this.CURRENT_VERSION_TEMPORARY_LOCATION, FilePaths.getPathToUpdateManifest(), true)
        }
        catch Error as e{
            errorMessage := "Failed to overwrite files from unzipped location: " this.LATEST_RELEASE_DOWNLOAD_LOCATION " to temporary location: " this.CURRENT_VERSION_TEMPORARY_LOCATION
            this.Logger.logError(
                errorMessage 
                . e.Message
                , "AutoUpdater.ahk"
                , e.Line
            )
            throw Error(errorMessage . " " . e.Message . " at line: " . e.Line)
        }
    }

    updateCurrentVersion(){
        UpdaterRunner_ := UpdaterRunner()
        ; Merges changes from the updated temporary location into the current version directory.
        UpdaterRunner_.runUpdater(this.CURRENT_VERSION_TEMPORARY_LOCATION, FilePaths.GetAbsolutePathToRoot(), true, this.releaseChecker.getLatestVersionInfo())
    }

    getPathToUnzippedFiles(unzipLocation) {
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
