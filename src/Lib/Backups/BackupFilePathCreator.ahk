#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>

class BackupFilePathCreator {

    BACKUP_NAME_DELIMITER := "__"
    BACKUP_DIR := FilePaths.getPathToBackups()

    __New() {
        ; Empty
    }

    ; Creates a backup file path based on the given version and timestamp.
    ; Looks something like "{path to extend-layer}\extend-layer\backups\v0.5.0__20250708213715.zip"
    createBackupFilePath(version, timestamp) {
        return this.BACKUP_DIR . "\" . version . this.BACKUP_NAME_DELIMITER . timestamp . ".zip"
    }

    ; Extracts the version and timestamp from a backup file name.
    ; Expected format: "{path to backup}\{Version}__{Timestamp}.zip"
    extractInfo(backupZipFilePath) {
        backupName := this.getFileName(backupZipFilePath)

        converted := this.convertIfOldFormat(backupName)
        if (converted != ""){
            backupName := converted
            parts := StrSplit(backupName, this.BACKUP_NAME_DELIMITER)
            newBackupZipPath := this.BACKUP_DIR . "\" . parts[1] . this.BACKUP_NAME_DELIMITER . parts[2] . ".zip"
            DirMove(backupZipFilePath, newBackupZipPath, "R")
            MsgBox(backupName)
            backupZipFilePath := newBackupZipPath
        }


        parts := StrSplit(backupName, this.BACKUP_NAME_DELIMITER)
        if (parts.Length != 2) {
            throw Error("Invalid backup file name format: " backupZipFilePath)
        }
        return { version: parts[1], timestamp: parts[2], path: backupZipFilePath}
    }

    ; Gets the file name from the backup zip path.
    ; For example, if the path is "{path to extend-layer}\extend-layer\backups\v0.5.0__20250708213715.zip"
    ; it returns "v0.5.0__20250708213715". Notice the absence of the ".zip" extension.
    getFileName(backupZipPath) {
        file := FilePath(backupZipPath)
        return file.getFileName()
    }

    convertIfOldFormat(backupName){
        checkv050FormatString := SubStr(backupName, 1 , 7)

        ; Checks if format is like v5.0.0_20251023083401 (with a single underscore)
        ; A valid format could be v5.0.0__20251023083401
        FoundPos := RegExMatch(backupName, "^v5\.0\.0_[^_].*")

        if (FoundPos = 1) {
            MsgBox("converted " . backupName)
            return this.convertFormatFromv050ToCurrentFormat(backupName)
        }

        return ""
    }

    convertFormatFromv050ToCurrentFormat(backupName){
        parts := StrSplit(backupName, "_")

        currentFormat := parts[1] . "__" . parts[2]
        return currentFormat
    }
}