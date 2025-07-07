#Requires AutoHotkey v2.0

#Include <Util\BackupManager>

#Include <ui\Main\util\DomainSpecificGui>

; TODO refactor
class RestoreBackupDialog extends DomainSpecificGui {

    BackupManager := BackupManager()

    __New(Backup) {
        if (Type(Backup) != "Backup") {
            throw TypeError("Invalid argument: Expected Backup object.")
        }
        super.__New("+Resize +MinSize300x180", "Restore Backup")
        this.create(Backup)
    }

    create(Backup) {
        formattedTimestamp := FormatTime(Backup.getTimestamp(), "'Date:' yyyy/MM/dd 'Time:' HH:mm:ss")

        this.Add("Text", "xm", 
            "Backup Path: " . Backup.getPath() . "`n" .
            "Version: " . Backup.getName() . "`n" .
            "Timestamp: " . formattedTimestamp)
        this.Add("Text", "", "Note! Newer profiles might have functionality which is not supported by the backup version.")


        this.Add("Button", "xs w100", "Restore backup, but keep current profiles").OnEvent("Click", (*) => this.restoreBackupKeepCurrentProfiles(Backup))
        this.Add("Text", "xp+100 yp w300", "Restores the backup, but keeps your current profiles. This means that your current profiles will not be replaced by the profiles in the backup, if you have edited any or have created your own. An example of a profile is the 'Default' profile")
        this.Add("Button", "xs w100", "Restore backup, including backup's profiles").OnEvent("Click", (*) => this.restoreBackupWithOldProfiles(Backup))
        this.Add("Text", "xp+100 yp w300", "Restores the backup and replaces your current profiles with the as they were in this backup. This means that any changes you made to your current profiles after this backup will be lost. (or you can restore them from another backup)")
        this.Add("Button", "xs w100", "Cancel").OnEvent("Click", (*) => this.close())
    }

    restoreBackupKeepCurrentProfiles(Backup) {
        this.BackupManager.restoreBackupKeepCurrentProfiles(Backup.getPath())
        this.close()
    }


    restoreBackupWithOldProfiles(Backup) {
        this.BackupManager.restoreBackupIncludingProfiles(Backup.getPath())
        this.close()
    }

    close() {
        this.Destroy()
    }
}