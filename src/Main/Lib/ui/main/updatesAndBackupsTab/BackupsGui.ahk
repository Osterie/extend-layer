#Requires AutoHotkey v2.0

#Include <ui\main\util\DomainSpecificGui>

#Include <Util\BackupManager>
#Include <Util\Formaters\TimestampConverter>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class BackupsGui extends DomainSpecificGui {

    BackupManager := BackupManager()
    TimestampConverter := TimestampConverter()

    backupsListView := ""
    selectedBackupText := ""

    backups := [] ; Array to hold Backup objects

    __New() {
        super.__New("", "Backups")
        ; super.__New("+Resize +MinSize300x280", "Backups")

        this.create()
    }

    create() {

        this.backupsListView := this.Add("ListView", "r20 w500", ["Path", "Version", "Timestamp"])
        this.backupsListView.OnEvent("ItemFocus", this.LV_Click.Bind(this))
        ; this.backupsListView.OnEvent("Click", this.LV_Click.Bind(this))
        this.backupsListView.OnEvent("DoubleClick", this.LV_DoubleClick.Bind(this))

        this.populateListView()  ; Populate the ListView with backups

        this.backupsListView.ModifyCol(2, "80 Center")
        this.backupsListView.ModifyCol(3, "Auto Text Center SortDesc")

        ; --- New: Selected backup display
        this.selectedBackupText := this.Add("Text", "xs y+10 w500", "Selected Backup: None")

        ; --- Buttons below the label
        this.Add("Button", "xs y+5 w150", "🔁 Restore Backup").OnEvent("Click", this.RestoreBackup.Bind(this))
        this.Add("Button", "x+10 w150", "➕ Create Backup").OnEvent("Click", this.CreateBackup.Bind(this))
        this.Add("Button", "x+10 w150", "❌ Delete Backup").OnEvent("Click", this.DeleteBackup.Bind(this))
    }

    populateListView() {
        this.backupsListView.Delete()  ; Clear the list view before populating it

        backups := this.BackupManager.getBackups()

        ; TODO remove
        ; Test backups 
        backups.push(Backup("v10.0.1", "asdf", 20240106154326))
        backups.push(Backup("v0.0.1", "asdf", 20230101154326))
        backups.push(Backup("v1.3.4", "asdf", 20240630154326))

        Loop backups.Length {
            Backup_ := backups[A_Index]
            this.backupsListView.Add("", Backup_.getPath(), Backup_.getName(), FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss"))
        }

        this.backupsListView.ModifyCol(1, "0") ; Hides the first column (Path), can be used when a column is selected.
        this.backupsListView.ModifyCol(2, "80 Center")
        this.backupsListView.ModifyCol(3, "Auto Text Center SortDesc")
    }

    LV_Click(GuiCtrlObj, selected) {
        if selected {
            path := this.backupsListView.GetText(selected, 1)
            version := this.backupsListView.GetText(selected, 2)
            timestamp := this.backupsListView.GetText(selected, 3)
            this.selectedBackupText.Value := "Selected Backup: " version " - " timestamp
        } else {
            this.selectedBackupText.Value := "Selected Backup: None"
        }
    }

    LV_DoubleClick(GuiCtrlObj, selected) {
        RowText := GuiCtrlObj.GetText(selected)
        ToolTip("You double-clicked: " RowText)
    }

    RestoreBackup(*) {
        selected := this.backupsListView.GetNext( , "Focused")
        MsgBox(selected)

        if !selected {
            MsgBox("Please select a backup to restore.")
            return
        }
        version := this.backupsListView.GetText(selected, 2)
        timestamp := this.backupsListView.GetText(selected, 3)
        formattedTimestamp := FormatTime(timestamp, "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss")
        MsgBox("Restore logic for version: " version ", created at " . formattedTimestamp)
        ; this.BackupManager.restoreBackup(version)
    }

    CreateBackup(*) {
        ; Create Backup
        this.BackupManager.createBackup()

        ; Refresh the list of backups
        this.populateListView()

        ; TODO instead of refreshing the list, add the new backup directly to the ListView
        ; this.backupsListView.Add("", Backup_.getName(), FormatTime(Backup_.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss"))
    }

    DeleteBackup(*) {
        selected := this.backupsListView.GetNext( , "Focused")
        if !selected {
            MsgBox("Please select a backup to delete.")
            return
        }

        path := this.backupsListView.GetText(selected, 1)
        version := this.backupsListView.GetText(selected, 2)
        timestamp := this.backupsListView.GetText(selected, 3)

        confirm := MsgBox("Are you sure you want to delete backup: " version ", created at " . timestamp .  "?", "Confirm", "YesNo")
        if confirm = "Yes" {
            this.BackupManager.deleteBackup(path)
            ; Refresh list
            this.populateListView()
        }
    }
}
