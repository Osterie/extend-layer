#Requires AutoHotkey v2.0

#Include <Updater\GithubReleaseChecker>

#Include <Infrastructure\Repositories\VersionRepository>

#Include <Util\Errors\NetworkError>

#Include <Shared\Logger>

class UpdateChecker {
    ReleaseChecker := ""

    Version := VersionRepository()
    Logger := Logger.getInstance()

    __New(){
        try{
            this.ReleaseChecker := GithubReleaseChecker("Osterie", "extend-layer")
        }
        catch NetworkError as e{
            this.Logger.logInfo("Could not check for updates due to network error: " e.message . " UpdateChecker.ahk " . A_LineNumber)
            throw e  ; Re-throw the error to handle it in the calling code
        }
    }

    updateAvailable() {
        return this.ReleaseChecker.updateAvailable(this.getCurrentVersion())
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