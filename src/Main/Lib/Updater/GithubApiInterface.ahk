#Requires AutoHotkey v2.0

#Include <Updater\GithubRelease>

#Include <Util\JsonParsing\JXON>
#Include <Util\NetworkUtils\Http\RestClient>
#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\Errors\NetworkError>
#Include <Util\Formaters\TimestampConverter>

#Include <Shared\Logger>

; TODO use in GithubReleaseChecker.ahk
class GithubApiInterface {
    
    RestClient := RestClient()  ; Handles HTTP requests
    Logger := Logger.getInstance()
    TimestampConverter := TimestampConverter()  ; Handles timestamp formatting

    owner := ""
    repo := ""  ; The GitHub repository owner and name

    __New(owner, repo) {
        this.owner := owner
        this.repo := repo

        if (this.owner = "" || this.repo = "") {
            throw Error("Owner, repo, and current version must be provided.")
        }
    }

    getLatestReleaseInfo() {

        if (!NetworkChecker.isConnectedToInternet()){
            throw NetworkError()
        }

        response := this.RestClient.Get("https://api.github.com/repos/" this.owner "/" this.repo "/releases/latest")
        
        if (response.status != 200) {
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw Error("Failed to fetch release information. Status: " response.status)
        }
        
        releaseInfo := response.objectAsMap
        return GithubRelease(releaseInfo)
    }

    getReleases() {
        if (!NetworkChecker.isConnectedToInternet()){
            throw NetworkError()
        }

        response := this.RestClient.Get("https://api.github.com/repos/" this.owner "/" this.repo "/releases")
        
        if (response.status != 200) {
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw Error("Failed to fetch release information. Status: " response.status)
        }
        
        releases := response.objectAsMap

        githubReleases := []
        for release in releases {
            githubReleases.push(GithubRelease(release))
        }

        return githubReleases
    }

}