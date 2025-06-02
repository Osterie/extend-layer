#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Updater\GithubReleaseChecker>
#Include <Util\Logging\Logger>

#Include <Util\UnZipper>


class AutoUpdater {
    static instance := false
    version := Version.getInstance()
    Logger := Logger.getInstance()
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
        this.UnZipper.Unzip(downloadPath, unzipLocation) ; Unzip to the script directory

        ; Download(downloadUrl, downloadPath)
        ; Download(downloadUrl, A_ScriptDir)

        ; A_Temp
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