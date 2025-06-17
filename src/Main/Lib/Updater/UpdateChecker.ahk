#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>

#Include <Util\Logging\Logger>
#Include <Util\Version>


class UpdateChecker {
    ReleaseChecker := ""

    Version := Version.getInstance()
    Logger := Logger.getInstance()

    __New(){
        this.ReleaseChecker := GithubReleaseChecker("Osterie", "extend-layer", this.getCurrentVersion())
    }

    updateAvailable() {
        return this.ReleaseChecker.updateAvailable()
    }

    getCurrentVersion() {
        return this.Version.getCurrentVersion()
    }

    getLatestVersionInfo() {
        try {
            return this.ReleaseChecker.getLatestVersionInfo()
        }
        catch {
            this.Logger.logError("Failed to get new version from GitHub. Using default version: unknown_latest", "AutoUpdater.ahk", A_LineNumber)
            return "unknown_latest"  ; Default version if new version cannot be retrieved
        }
    }
}