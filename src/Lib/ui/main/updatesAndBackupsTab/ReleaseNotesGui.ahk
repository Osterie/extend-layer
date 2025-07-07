#Requires AutoHotkey v2.0

#Include <ui\main\util\DomainSpecificGui>

#Include <Updater\GithubApiInterface>

#Include <Util\NetworkUtils\NetworkChecker>
#Include <Util\Errors\NetworkError>

class ReleaseNotesGui extends DomainSpecificGui {

    GithubApiInterface := GithubApiInterface("osterie", "extend-layer")

    __New() {
        super.__New("", "Release Notes")
        ; super.__New("+Resize +MinSize300x280", "Release Notes")

        if (!NetworkChecker.isConnectedToInternet()){
            this.SetFont("s16 w700")
            this.Add("Text", "", "No Internet connection")
            return
        }

        this.create()
    }

    create() {

        try{
            releases := this.GithubApiInterface.getReleases()
        }
        catch NetworkError as e {
            this.SetFont("s16 w700")
            this.Add("Text", "", "Failed to fetch release notes. " e.message)
            return
        }
        catch Error as e {
            this.SetFont("s16 w700")
            this.Add("Text", "", "An error occurred while fetching release notes: " e.message)
            return
        }
        versions := []
        for release in releases {
            versions.Push(release.getVersion())
        }


        ; Join versions into a newline-delimited string
        versionList := ""
        for version in versions {
            versionList .= version "`n"
        }

        this.SetFont("w700",)
        this.Add("Text", "Section", "🔧 Release Notes")
        
        this.SetFont("w400",)
        this.Add("Text", "xs y+10", "Select a version to view release notes:")

        ; Add ListBox with versions
        this.versionListBox := this.Add("ListBox", "xs y+5 w600 r10", versions)

        ; Optionally add a placeholder for release notes content
        this.Add("Text", "xs y+15", "Release notes:")
        this.notesEdit := this.Add("Edit", "xs y+5 w600 r20 ReadOnly")

        ; Add event to load release notes when version is selected
        this.versionListBox.OnEvent("Change", (*) => this.showNotes(releases[this.versionListBox.Value]))
    }

    showNotes(release) {
        notes := release.getBody()
        this.notesEdit.Value := notes != "" ? notes : "No release notes available for this version."
    }

}