#Requires AutoHotkey v2.0

#Include <Updater\GithubRelease>

#Include <Util\JsonParsing\JXON>
#Include <Util\NetworkUtils\Http\RestClient>
#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\Errors\NetworkError>

#Include <Shared\Logger>

; TODO use in GithubReleaseChecker.ahk
class GithubApiInterface {
    
    RestClient := RestClient()  ; Handles HTTP requests
    Logger := Logger.getInstance()

    owner := ""
    repo := ""

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
            if (response.status = 403) {
                this.Logger.logError("Rate limit exceeded. Please try again later.")
                throw NetworkError("Rate limit exceeded. Please try again later.")
            }
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw NetworkError("Failed to fetch release information. Status: " response.status)
        }
        
        releases := response.objectAsMap

        githubReleases := []
        for release in releases {
            githubReleases.push(GithubRelease(release))
        }

        return githubReleases
    }

}