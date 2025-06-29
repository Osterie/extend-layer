#Requires AutoHotkey v2.0

#Include <Updater\GithubRelease>

#Include <Util\JsonParsing\JXON>
#Include <Util\NetworkUtils\Http\RestClient>
#Include <Shared\Logger>
#Include <Util\Formaters\TimestampConverter>

class GithubReleaseChecker {

    RestClient := RestClient()  ; Handles HTTP requests
    Logger := Logger.getInstance()
    TimestampConverter := TimestampConverter()  ; Handles timestamp formatting
    GithubRelease := ""  ; Instance of GithubRelease to handle release information

    owner := ""
    repo := ""  ; The GitHub repository owner and name
    currentVersion := ""  ; The current version of the software

    __New(owner, repo, currentVersion) {
        this.owner := owner
        this.repo := repo
        this.currentVersion := currentVersion

        if (this.owner = "" || this.repo = "" || this.currentVersion = "") {
            throw Error("Owner, repo, and current version must be provided.")
        }

        this.GithubRelease := this.getLatestReleaseInfo()
    }

    ; If the current version is not the same as the latest version, we assume an update is available.
    ; Although it would be possible that the latest release is an update of an older version, although this is unlikely.
    updateAvailable() {
        latestVersion := this.getLatestVersionInfo()
        return (this.currentVersion != latestVersion)
    }

    getDownloadUrl(){
        return this.GithubRelease.getZipDownloadUrl()
    }

    getLatestVersionInfo() {
        return this.GithubRelease.getVersion()
    }

    getLatestReleaseInfo() {
        response := this.RestClient.Get("https://api.github.com/repos/" this.owner "/" this.repo "/releases/latest")
        
        if (response.status != 200) {
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw Error("Failed to fetch release information. Status: " response.status)
        }
        
        releaseInfo := response.objectAsMap
        return GithubRelease(releaseInfo)
    }

    ; Example of version format: "v0.4.3-alpha"
    ; compareVersions(currentVersion, latestVersion) {
    ;     ; Compare two version strings
    ;     currentParts := StrSplit(currentVersion, ".")
    ;     latestParts := StrSplit(latestVersion, ".")

    ;     for index, part in currentParts {
    ;         if (index > latestParts.Length()) {
    ;             return false  ; Current version has more parts than latest
    ;         }
    ;         if (part < latestParts[index]) {
    ;             return false  ; Current version is older
    ;         } else if (part > latestParts[index]) {
    ;             return true  ; Current version is newer
    ;         }
    ;     }
    ;     return true  ; Versions are equal
    ; }
}