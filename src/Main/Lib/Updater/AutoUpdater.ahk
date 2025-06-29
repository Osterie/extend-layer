#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>
#Include <Updater\UpdaterRunner>

#Include <Infrastructure\Repositories\VersionRepository>
#Include <Infrastructure\IO\FileOverwriteManager>

#Include <Util\Errors\NetworkError>
#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\NetworkUtils\Downloading\Downloader>

#Include <Shared\Logger>
#Include <Shared\FilePaths>

class AutoUpdater {
    static instance := false
    Version := VersionRepository()
    Logger := Logger.getInstance()
    releaseChecker := ""  ; Instance of GithubReleaseChecker to check for updates

    LATEST_RELEASE_DOWNLOAD_LOCATION := FilePaths.getPathToTemporaryLocation() . "\extend-layer-update"  ; Default download location for the latest release
    CURRENT_VERSION_TEMPORARY_LOCATION := FilePaths.getPathToTemporaryLocation() . "\extend-layer-temporary"  ; Temporary location for the current version

    __New() {
        currentVersion := this.Version.getCurrentVersion()
        this.releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
    }

    static getInstance() {
        if (!AutoUpdater.instance) {
            AutoUpdater.instance := AutoUpdater()
        }
        return AutoUpdater.instance
    }

    updateAvailable() {
        return this.releaseChecker.updateAvailable()
    }

    updateExtendLayer() {
        this.downloadLatestRelease()
        this.copyCurrentVersionToTemporaryLocation()
        this.updateVersionInTemporaryLocation()
        this.updateCurrentVersion()
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
