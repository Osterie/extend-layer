#Requires AutoHotkey v2.0

#Include <Updater\GithubRelease>

#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Http\RestClient>
#Include <Util\Logging\Logger>

#Include <Util\Formaters\TimestampConverter>


class GithubReleaseChecker {

    RestClient := RestClient()  ; Instance of RestClient to handle HTTP requests
    Logger := Logger.getInstance()
    TimestampConverter := TimestampConverter()  ; Instance of TimestampConverter to handle timestamp formatting

    __New(owner, repo, currentVersion) {
        this.CheckForUpdates(owner, repo, currentVersion)
    }

    CheckForUpdates(owner, repo, currentVersion) {
        release := this.getLatestReleaseInfo(owner, repo)

        currentVersion := "v0.4.3-alpha"  ; Example current version, replace with actual current version retrieval logic
        latestVersion := release.getVersion()

        if (currentVersion = latestVersion) {
            MsgBox("You are using the latest version: " currentVersion)
            return true
        }
        else{
            MsgBox("A new version is available: " latestVersion " (current: " currentVersion ")")
        }
    }

    GetLatestReleaseInfo(owner, repo) {
        response := this.RestClient.Get("https://api.github.com/repos/" owner "/" repo "/releases/latest")
        if (response.status != 200) {
            this.Logger.logError("Failed to fetch release information. Status: " response.status)
            throw Error("Failed to fetch release information. Status: " response.status)
        }
        
        releaseInfo := response.objectAsMap
        return GithubRelease(releaseInfo)
    }

    ; Example of version format: "v0.4.3-alpha"
    CompareVersions(currentVersion, latestVersion) {
        ; Compare two version strings
        currentParts := StrSplit(currentVersion, ".")
        latestParts := StrSplit(latestVersion, ".")

        for index, part in currentParts {
            if (index > latestParts.Length()) {
                return false  ; Current version has more parts than latest
            }
            if (part < latestParts[index]) {
                return false  ; Current version is older
            } else if (part > latestParts[index]) {
                return true  ; Current version is newer
            }
        }
        return true  ; Versions are equal
    }
}