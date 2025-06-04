#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Util\UpdateManifest>
#Include <Updater\GithubReleaseChecker>
#Include <Util\Logging\Logger>

#Include <Util\UnZipper>


class AutoUpdater {
    static instance := false
    version := Version.getInstance()
    Logger := Logger.getInstance()
    UpdateManifest := UpdateManifest.getInstance()  ; Instance of UpdateManifest to read update manifest
    UnZipper := UnZipper()  ; Instance of UnZipper to handle ZIP extraction

    
    __New() {
    }

    static getInstance() {
        if !AutoUpdater.instance
            AutoUpdater.instance := AutoUpdater()
        return AutoUpdater.instance
    }

    checkForUpdates() {

        currentVersion := this.GetCurrentVersion()

        

        releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
        
        updateAvailable := releaseChecker.updateAvailable()

        if (updateAvailable) {
            ; MsgBox("Update available! Current")

            ; this.Logger.logInfo("Update available! Current version: " currentVersion ", Latest version: " latestVersion)
            ; Here you can add code to handle the update, like downloading and installing it
        } else {
            ; MsgBox("Up to date!")
            ; this.Logger.logInfo("No updates available. Current version: " currentVersion)
        }

        ; releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", "v0.4.3-alpha")

        downloadUrl := releaseChecker.GetDownloadUrl()
        ; MsgBox(downloadUrl)

        downloadPath := A_Temp "\extend-layer-update.zip" ; or any safe temp/local dir
        unzipLocation := A_Temp "\extend-layer-update" ; or any safe local dir
        ; Download(downloadUrl, downloadPath)
        ; this.UnZipper.Unzip(downloadPath, unzipLocation, true) ; Unzip to the script directory

        this.UpdateCurrentVersion(unzipLocation)

        ; Download(downloadUrl, A_ScriptDir)

        ; A_Temp
    }

    UpdateCurrentVersion(unzipLocation) {
        ; TODO maybe need admin permissions

        pathToUnzippedFiles := this.GetPathToUnzippedFiles(unzipLocation)
        MsgBox(pathToUnzippedFiles)


        overWritePaths := this.UpdateManifest.GetOverwritePaths()
        skipPaths := this.UpdateManifest.GetSkipPaths()

        Loop(overWritePaths.Length){
            MsgBox(overWritePaths[A_Index])
        }

        ; Loop Files, pathToUnzippedFiles . "\*", "FDR" { ; "R" means "Recursively, F means include files, D means include directories"
        ;     MsgBox("Found or folder: " A_LoopFileShortName)
        ; }
        ; Read from update-manifest.json
        ; AttributeString := FileExist(FilePattern)
    }

    GetPathToUnzippedFiles(unzipLocation) {
        if (!FileExist(unzipLocation)) {
            this.Logger.logError("Unzipped location does not exist: " unzipLocation)
            throw Error("Unzipped location does not exist: " unzipLocation)
        }

        foundPath := ""
        index := 1
        Loop Files, unzipLocation . "\*", "D" {
            foundPath  := A_LoopFileFullPath
            index += 1
        }

        if (index > 2) {
            this.Logger.logError("Multiple directories found in unzipped location: " unzipLocation)
            throw Error("Multiple directories found in unzipped location: " unzipLocation)
        }

        return foundPath
    }

    GetCurrentVersion() {

        currentVersion := ""
        try {
            currentVersion := this.Version.GetCurrentVersion()
        }
        catch {
            this.Logger.logError("Failed to get current version. Using provided version: " currentVersion)
            throw Error("Failed to get current version. Using provided version: " currentVersion)
        }

        return currentVersion
    }
}