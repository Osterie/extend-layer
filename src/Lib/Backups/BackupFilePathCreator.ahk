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
    extractVersionAndTimestamp(backupZipFilePath) {
        backupName := this.getFileName(backupZipFilePath)

        parts := StrSplit(backupName, this.BACKUP_NAME_DELIMITER)
        if (parts.Length != 2) {
            throw Error("Invalid backup file name format: " backupZipFilePath)
        }
        return { version: parts[1], timestamp: parts[2] }
    }

    ; Gets the file name from the backup zip path.
    ; For example, if the path is "{path to extend-layer}\extend-layer\backups\v0.5.0__20250708213715.zip"
    ; it returns "v0.5.0__20250708213715". Notice the absence of the ".zip" extension.
    getFileName(backupZipPath) {
        file := FilePath(backupZipPath)
        return file.getFileName()
    }
}