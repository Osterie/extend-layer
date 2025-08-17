#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGui>

#Include <Util\BackupManager>
#Include <Updater\RestoreBackupDialog>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

; TODO refactor
class BackupsGui extends DomainSpecificGui {

    BackupManager := BackupManager()

    backupsListView := ""
    selectedBackupText := ""

    __New() {
        super.__New("", "Backups")
        this.create()
    }

    create() {
        this.createBackupListView()
        this.createBackupControls()
    }

    createBackupListView() {
        this.backupsListView := this.Add("ListView", "r20 w500", ["Path", "Version", "Timestamp", "Size"])
        this.backupsListView.OnEvent("ItemFocus", this.handleBackupSelected.Bind(this))
        this.populateListView()  ; Populate the ListView with backups
    }

    populateListView() {
        this.backupsListView.Delete()  ; Clear the list view before populating it

        backups := this.BackupManager.getBackups()

        for Backup_ in backups {
            formattedTime := FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss")
            this.backupsListView.Add("", Backup_.getPath(), Backup_.getName(), formattedTime, Backup_.getSize("K") " KB")
        }

        this.backupsListView.ModifyCol(1, "0") ; Hides the first column (Path), can be used when a column is selected.
        this.backupsListView.ModifyCol(2, "80 Center")
        this.backupsListView.ModifyCol(3, "Auto Text Center SortDesc")

        if (backups.Length = 0) {
            this.backupsListView.ModifyCol(3, "80")
        }
    }

    handleBackupSelected(GuiCtrlObj, selected) {
        if selected {
            path := this.backupsListView.GetText(selected, 1)
            version := this.backupsListView.GetText(selected, 2)
            timestamp := this.backupsListView.GetText(selected, 3)
            size := this.backupsListView.GetText(selected, 4)
            this.selectedBackupText.Value := "Selected Backup: " version " - " timestamp . " - Size: " size " KB"
        } else {
            this.selectedBackupText.Value := "Selected Backup: None"
        }
    }

    createBackupControls() {
        this.selectedBackupText := this.Add("Text", "xs y+10 w500", "Selected Backup: None")

        this.Add("Button", "xs y+5 w150", "🔁 Restore Backup").OnEvent("Click", (*) => this.restoreBackup())
        this.Add("Button", "x+10 w150", "➕ Create Backup").OnEvent("Click", (*) => this.createBackup())
        this.Add("Button", "x+10 w150", "❌ Delete Backup").OnEvent("Click", (*) => this.deleteBackup())
    }

    restoreBackup() {
        selected := this.backupsListView.GetNext(, "Focused")

        if !selected {
            MsgBox("Please select a backup to restore.")
            return
        }
        path := this.backupsListView.GetText(selected, 1)

        Backup_ := this.BackupManager.getBackupFromPath(path)

        RestoreBackupDialog_ := RestoreBackupDialog(Backup_)
        RestoreBackupDialog_.show()
    }

    createBackup() {
        result := MsgBox("Are you sure you want to create a backup?", , "YesNo")

        if (result = "No") {
            return
        }

        ; Create Backup
        this.BackupManager.createBackup()

        ; Refresh the list of backups
        this.populateListView()

        ; TODO instead of refreshing the list, add the new backup directly to the ListView
        ; this.backupsListView.Add("", Backup_.getName(), FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss"))
    }

    deleteBackup() {

        selected := this.backupsListView.GetNext(, "Focused")
        if (!selected) {
            MsgBox("Please select a backup to delete.")
            return
        }

        path := this.backupsListView.GetText(selected, 1)
        version := this.backupsListView.GetText(selected, 2)
        timestamp := this.backupsListView.GetText(selected, 3)

        confirm := MsgBox("Are you sure you want to delete backup: " version ", created at " . timestamp . "?",
            "Confirm", "YesNo")

        if (confirm = "Yes") {
            this.BackupManager.deleteBackup(path)
            ; Refresh list
            this.populateListView()
        }
    }
}
