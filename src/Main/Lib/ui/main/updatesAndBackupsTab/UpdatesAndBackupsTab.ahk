#Requires AutoHotkey v2.0

#Include <ui\main\UpdatesAndBackupsTab\ReleaseNotesGui>
#Include <ui\main\UpdatesAndBackupsTab\BackupsGui>

#Include <Infrastructure\Repositories\VersionRepository>

class UpdatesAndBackupsTab {
    guiToAddTo := ""

    __New(guiToAddTo) {
        this.guiToAddTo := guiToAddTo
    }

    createTab() {
        ; Add heading
        this.guiToAddTo.SetFont("w700")
        this.guiToAddTo.Add("Text", "Section", "🔧 Updates && Backups")
        this.guiToAddTo.SetFont("w400")
        
        VersionRepository_ := VersionRepository()
        ; Current Version
        this.guiToAddTo.Add("Text", "xs y+10", "Current Version:")
        this.guiToAddTo.Add("Text", "x+5 yp", VersionRepository_.getCurrentVersion())

        ; ; Latest Version
        ; this.guiToAddTo.Add("Text", "xs y+10", "Latest Available Version:")
        ; this.guiToAddTo.Add("Text", "x+5 yp", "v0.5.0")

        ; Release Notes Button
        this.createReleaseNotesButton()

        ; Backups Button
        this.createBackupsButton()
    }

    ; Release Notes Button
    createReleaseNotesButton() {
        button := this.guiToAddTo.Add("Button", "xs y+10 w200", "📃 View Release Notes")
        button.OnEvent("Click", (*) => this.showReleaseNotes())
    }

    showReleaseNotes() {
        ReleaseNotesGui_ := ReleaseNotesGui()
        ReleaseNotesGui_.show()
    }

    createBackupsButton() {
        button := this.guiToAddTo.Add("Button", "xs y+10 w200", "📂 View Backups")
        button.OnEvent("Click", (*) => this.showBackups())
    }

    showBackups() {
        BackupsGui_ := BackupsGui()
        BackupsGui_.show()
    }
}
