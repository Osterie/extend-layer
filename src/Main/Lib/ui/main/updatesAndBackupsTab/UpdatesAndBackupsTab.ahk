#Requires AutoHotkey v2.0

#Include <ui\main\UpdatesAndBackupsTab\ReleaseNotesGui>

class UpdatesAndBackupsTab {
    guiToAddTo := ""

    __New(guiToAddTo) {
        this.guiToAddTo := guiToAddTo
    }

    createTab() {
        ; Add heading
        this.guiToAddTo.SetFont("w700")
        this.guiToAddTo.Add("Text", "Section", "🔧 Updates & Backups")
        this.guiToAddTo.SetFont("w400")
        
        ; Current Version
        this.guiToAddTo.Add("Text", "xs y+10", "Current Version:")
        this.guiToAddTo.Add("Text", "x+5 yp", "v0.4.3.0-alpha")

        ; Latest Version
        this.guiToAddTo.Add("Text", "xs y+10", "Latest Available Version:")
        this.guiToAddTo.Add("Text", "x+5 yp", "v0.5.0")

        ; Release Notes Button
        this.createReleaseNotesButton()


        ; Backup Now
        this.guiToAddTo.Add("Button", "xs y+20 w200", "💾 Backup Now").OnEvent("Click", (*) => MsgBox("Backup created at: C:\Backups\extend-layer-backup.zip"))

        ; Restore Previous Backup
        this.guiToAddTo.Add("Button", "xs y+10 w200", "♻️ Restore Backup").OnEvent("Click", (*) => MsgBox("Restore from: C:\Backups\extend-layer-backup.zip"))

        ; Open Backup Folder
        this.guiToAddTo.Add("Button", "xs y+10 w200", "📂 Open Backup Folder").OnEvent("Click", (*) => MsgBox("explorer.exe C:\Backups"))
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
}
