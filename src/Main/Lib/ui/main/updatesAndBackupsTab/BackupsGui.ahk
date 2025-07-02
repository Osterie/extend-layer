#Requires AutoHotkey v2.0

#Include <ui\main\util\DomainSpecificGui>

#Include <Util\BackupManager>
#Include <Util\Formaters\TimestampConverter>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class BackupsGui extends DomainSpecificGui {

    BackupManager := BackupManager()
    TimestampConverter := TimestampConverter()

    __New() {
        super.__New("", "Backups")
        ; super.__New("+Resize +MinSize300x280", "Backups")

        this.create()
    }

    create() {

        backups := this.BackupManager.getBackups()

        backups.push(Backup("v10.0.1", "asdf", 20270101154326))  ; For testing purposes, add a backup manually.
        backups.push(Backup("v0.0.1", "asdf", 20230101154326))  ; For testing purposes, add a backup manually.
        backups.push(Backup("v1.3.4", "asdf", 20240630154326))  ; For testing purposes, add a backup manually.


        ; Create the ListView with two columns, Version and Size:
        LV := this.Add("ListView", "r20 w500", ["Version", "Timestamp"])

        ; Notify the script whenever the user double clicks a row:
        LV.OnEvent("DoubleClick", LV_DoubleClick)

        ; Gather a list of file names from a folder and put them into the ListView:
        for Backup_ in backups {
            LV.Add("", Backup_.getName(), FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss"))
        }

        ; LV.ModifyCol()  ; Auto-size each column to fit its contents.
        LV.ModifyCol(1, "80 Center") ; Make column 1 (Version) 80 pixels wide.
        LV.ModifyCol(2, "Auto Text Center SortDesc")
        
        if (backups.Length == 0) {
            LV.ModifyCol(2, "80") ; If there are no backups, set the second column (Timestamp) to 80 pixels wide.
        }

        ; ; Display the window:
        ; MyGui.Show()

        LV_DoubleClick(LV, RowNumber)
        {
            RowText := LV.GetText(RowNumber)  ; Get the text from the row's first field.
            ToolTip("You double-clicked row number " RowNumber ". Text: '" RowText "'")
        }
        
        ; versions := []
        ; for release in releases {
        ;     versions.Push(release.getVersion())
        ; }


        ; ; Join versions into a newline-delimited string
        ; versionList := ""
        ; for version in versions {
        ;     versionList .= version "`n"
        ; }

        ; this.SetFont("w700",)
        ; this.Add("Text", "Section", "🔧 Release Notes")
        
        ; this.SetFont("w400",)
        ; this.Add("Text", "xs y+10", "Select a version to view release notes:")

        ; ; Add ListBox with versions
        ; this.versionListBox := this.Add("ListBox", "xs y+5 w600 r10", versions)

        ; ; Optionally add a placeholder for release notes content
        ; this.Add("Text", "xs y+15", "Release notes:")
        ; this.notesEdit := this.Add("Edit", "xs y+5 w600 r20 ReadOnly")

        ; ; Add event to load release notes when version is selected
        ; this.versionListBox.OnEvent("Change", (*) => this.showNotes(releases[this.versionListBox.Value]))
    }

    ; showNotes(release) {
    ;     notes := release.getBody()
    ;     this.notesEdit.Value := notes != "" ? notes : "No release notes available for this version."
    ; }

}