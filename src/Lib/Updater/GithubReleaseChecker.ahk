#Requires AutoHotkey v2.0

#Include <Updater\GithubRelease>

#Include <Util\JsonParsing\JXON>
#Include <Util\NetworkUtils\Http\RestClient>
#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\Errors\NetworkError>

#Include <Shared\Logger>

class GithubReleaseChecker {

    RestClient := RestClient()  ; Handles HTTP requests
    Logger := Logger.getInstance()
    GithubRelease := ""  ; Instance of GithubRelease to handle release information

    owner := ""
    repo := ""  ; The GitHub repository owner and name

    __New(owner, repo) {
        this.owner := owner
        this.repo := repo

        if (this.owner = "" || this.repo = "") {
            throw Error("Owner, repo, and current version must be provided.")
        }
        this.GithubRelease := this.getLatestReleaseInfo()
    }

    ; If the current version is not the same as the latest version, we assume an update is available.
    ; Although it would be possible that the latest release is an update of an older version, although this is unlikely.
    updateAvailable(currentVersion) {
        latestVersion := this.getLatestVersionInfo()
        return (currentVersion != latestVersion)
    }

    getDownloadUrl(){
        return this.GithubRelease.getZipDownloadUrl()
    }

    getLatestVersionInfo() {
        return this.GithubRelease.getVersion()
    }

    getLatestReleaseInfo() {

        if (!NetworkChecker.isConnectedToInternet()){
            throw NetworkError()
        }

        response := this.RestClient.Get("https://api.github.com/repos/" this.owner "/" this.repo "/releases/latest")
        
        if (response.status != 200) {
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw NetworkError("Failed to fetch release information. Status: " response.status)
        }
        
        releaseInfo := response.objectAsMap
        return GithubRelease(releaseInfo)
    }
}