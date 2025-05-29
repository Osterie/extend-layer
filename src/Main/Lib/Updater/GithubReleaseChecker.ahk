#Requires AutoHotkey v2.0

; https://github.com/cocobelgica/AutoHotkey-JSON

#Include <Util\JsonParsing\JXON\JXON>
#Include <Util\Http\RestClient>
#Include <Util\Logging\Logger>





class GithubReleaseChecker {

    RestClient := RestClient()  ; Instance of RestClient to handle HTTP requests
    Logger := Logger.getInstance()

    __New() {
        this.CheckForUpdates()
    }

    CheckForUpdates() {

        response := this.RestClient.Get("https://api.github.com/repos/Osterie/extend-layer/releases/latest")
        if (response.status != 200) {
            MsgBox("Failed to fetch release information. Status: " response.status)
            return
        }
        responseText := response.text
        releaseInfo := response.objectAsMap

        ; Get release name from tag
        try{
            releaseTag := releaseInfo["tag_nafme"]
            version := releaseInfo["tag_name"]
        } catch Error as e {
            this.Logger.logError("Error retrieving release tag: " e.message, e.file, e.line)
            ; MsgBox("Error retrieving release tag: " e.message)
            return
        }

        
        ; Get release published date (release date)
        releaseDate := RegExReplace(releaseInfo["published_at"], "[T:\-]", "")

        MsgBox("Latest release: " releaseTag "`nPublished on: " releaseDate)
        ; try {
        ;     ; Fetch the latest release information from GitHub
        ;     response := UrlDownloadToVar("https://api.github.com/repos/yourusername/yourrepo/releases/latest")
        ;     releaseInfo := Jxon_Load(response)
            

        ;     ; Compare the current version with the latest version
        ;     currentVersion := "1.0.0"  ; Replace with your current version logic
        ;     latestVersion := releaseInfo.tag_name

        ;     if (currentVersion < latestVersion) {
        ;         MsgBox("A new version is available: " latestVersion)
        ;     } else {
        ;         MsgBox("You are using the latest version: " currentVersion)
        ;     }
        ; } catch e {
        ;     MsgBox("Error checking for updates: " e.message)
        ; }
    }

    getLatestReleaseInfo(owner, repository)
    {
        tmpfile := A_Temp . "\gitinfo-ahk"
        Download("https://api.github.com/repos/Osterie/extend-layer/releases/latest", tmpfile)
                    jsonStringFunctionalityInformation := FileRead(this.PATH_TO_OBJECT_INFO, "UTF-8")

        MsgBox(tmpfile)
        obj := Jxon_Load(&tmpfile)
        FileDelete(tmpfile)
        return obj
    }
}