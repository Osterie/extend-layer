#Requires AutoHotkey v2.0

#Include <ui\util\DomainSpecificGui>

#Include <Backups\BackupManager>
#Include <Backups\RestoreBackupDialog>
#Include <Backups\Backup>

#Include <Shared\Logger>

class BackupsGui extends DomainSpecificGui {

    Logger := Logger.getInstance()

    BackupManager := BackupManager()

    backupsListView := ""
    selectedBackupText := ""

    __New() {
        super.__New("", "Backups")
        this.create()
    }

    create() {
        this.selectedBackupText := this.Add("Text", "xs y+10 w600", "Selected Backup: None")
        this.createBackupListView()
        this.createBackupControls()
    }

    createBackupListView() {
        this.backupsListView := this.Add("ListView", "r20 w600", ["Path", "Version", "Timestamp", "Size"])
        this.backupsListView.OnEvent("ItemFocus", this.handleBackupSelected.Bind(this))
        this.populateListView()
    }

    populateListView() {
        this.backupsListView.Delete()

        backups := this.BackupManager.getBackups()
        for Backup_ in backups {
            this.addBackupToListView(Backup_)
        }

        this.modifyListViewColumns(backups)
    }

    addBackupToListView(Backup_) {
        formattedTime := FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss")
        this.backupsListView.Add("", Backup_.getPath(), Backup_.getName(), formattedTime, Backup_.getSize("K") " KB")
    }

    modifyListViewColumns(backups) {

        this.backupsListView.ModifyCol(1, "0") ; Hides the first column (Path), can be used when a column is selected.
        this.backupsListView.ModifyCol(2, "80 Center") ; Version
        this.backupsListView.ModifyCol(3, "400 Text Center SortDesc") ; Timestamp
        this.backupsListView.ModifyCol(4, "Auto Text Center") ; Size

        if (backups.Length = 0) {
            this.backupsListView.ModifyCol(3, "80")
        }
    }

    handleBackupSelected(GuiCtrlObj, selected) {
        if selected {
            version := this.backupsListView.GetText(selected, 2)
            timestamp := this.backupsListView.GetText(selected, 3)
            size := this.backupsListView.GetText(selected, 4)
            this.selectedBackupText.Value := "Selected Backup: " version " - " timestamp . " - Size: " size " KB"
        } else {
            this.selectedBackupText.Value := "Selected Backup: None"
        }
    }

    createBackupControls() {
        this.Add("Button", "xs y+5 w150", "🔁 Restore Backup").OnEvent("Click", (*) => this.restoreBackup())
        this.Add("Button", "x+10 w150", "➕ Create Backup").OnEvent("Click", (*) => this.createBackup())
        this.Add("Button", "x+10 w150", "❌ Delete Backup").OnEvent("Click", (*) => this.deleteBackup())
        this.Add("Button", "Default x+10 w120", "Cancel").OnEvent("Click", (*) => this.destroy())
    }

    restoreBackup() {
        selected := this.backupsListView.GetNext(, "Focused")

        if !selected {
            MsgBox("Please select a backup to restore.")
            return
        }

        path := this.backupsListView.GetText(selected, 1)
        Backup_ := Backup(path)

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

        this.Logger.logInfo("Backup created successfully.")
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
        size := this.backupsListView.GetText(selected, 4)

        confirm := MsgBox("Are you sure you want to delete backup: " version ", created at " . timestamp . "? Backup size: " . size . " KB",
            "Confirm", "YesNo")

        if (confirm = "Yes") {
            this.BackupManager.deleteBackup(path)
            ; Refresh list
            this.populateListView()
            this.Logger.logInfo("Backup deleted successfully: " version . " - " . path . " - Size " . size . " KB")
        }
    }
}
