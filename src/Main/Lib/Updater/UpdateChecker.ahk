#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>

#Include <Util\Logging\Logger>
#Include <Util\Version>


class UpdateChecker {
    ReleaseChecker := ""

    Version := Version.getInstance()
    Logger := Logger.getInstance()

    __New(){
        currentVersion := ""
        try{
            currentVersion := this.GetCurrentVersion()
        }
        catch{
            this.Logger.logError("Failed to get current version. Using default version: unknown", "AutoUpdater.ahk", A_LineNumber)
            currentVersion := "unknown"  ; Default version if current version cannot be retrieved
        }
        this.ReleaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
    }

    UpdateAvailable() {
        return this.ReleaseChecker.updateAvailable()
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

    GetLatestVersionInfo() {
        try {
            return this.ReleaseChecker.GetLatestVersionInfo()
        }
        catch {
            this.Logger.logError("Failed to get new version from GitHub. Using default version: unknown", "AutoUpdater.ahk", A_LineNumber)
            return "unknown"  ; Default version if new version cannot be retrieved
        }
    }
}