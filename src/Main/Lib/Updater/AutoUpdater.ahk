#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Updater\GithubReleaseChecker>
#Include <Util\Logging\Logger>


class AutoUpdater {
    static instance := false
    version := Version.getInstance()
    Logger := Logger.getInstance()

    
    __New() {
    }

    static getInstance() {
        if !AutoUpdater.instance
            AutoUpdater.instance := AutoUpdater()
        return AutoUpdater.instance
    }

    checkForUpdates() {

        currentVersion := ""

        try {
            currentVersion := this.Version.GetCurrentVersion()
        }
        catch {
            this.Logger.logError("Failed to get current version. Using provided version: " currentVersion)
            throw Error("Failed to get current version. Using provided version: " currentVersion)
        }

        releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)

        ; releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", "v0.4.3-alpha")



    }

    getLatestVersionFromManifest() {
        ; Logic to read the latest version from the update manifest
        return "1.0.1" ; Placeholder for actual implementation
    }

    notifyUpdateAvailable(latestVersion) {
        MsgBox("An update is available: " latestVersion)
    }

    notifyNoUpdatesAvailable() {
        MsgBox("You are using the latest version.")
    }
}