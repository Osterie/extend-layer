#Requires AutoHotkey v2.0

#Include <Shared\Logger>

class GithubRelease {

    Logger := Logger.getInstance()

    ; TODO dont need to store these as variables.
    releaseInfo := ""  ; The release information from GitHub api
    version := ""  ; The version string, e.g., "v0.4.3-alpha"
    releaseDate := ""  ; The release date in YYYYMMDDhhmmss format

    __New(releaseInfo) {
        this.releaseInfo := releaseInfo
        this.setVersion(releaseInfo)
        this.setReleaseDate(releaseInfo)
    }

    setVersion(releaseInfo) {
        try {
            this.version := releaseInfo["tag_name"]
        } catch Error as e {
            this.Logger.logError("Error retrieving release tag: " e.message, e.file, e.line)
            throw ValueError("Error retrieving release tag: " e.message)
        }
    }

    getVersion() {
        return this.version
    }

    setReleaseDate(releaseInfo) {
        try {
            this.releaseDate := releaseInfo["published_at"]
        } catch Error as e {
            this.Logger.logError("Error retrieving release date: " e.message, e.file, e.line)
            throw ValueError("Error retrieving release date: " e.message)
        }
    }

    getReleaseDate() {
        return this.releaseDate
    }

    getZipDownloadUrl() {
        try {
            return this.releaseInfo["zipball_url"]
        } catch Error as e {
            this.Logger.logError("Error retrieving zip download URL: " e.message, e.file, e.line)
            throw ValueError("Error retrieving zip download URL: " e.message)
        }
    }

    getBody() {
        try {
            return this.releaseInfo["body"]
        } catch Error as e {
            this.Logger.logError("Error retrieving release body: " e.message, e.file, e.line)
            throw ValueError("Error retrieving release body: " e.message)
        }
    }
}
