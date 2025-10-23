#Requires AutoHotkey v2.0

#Include <Util\FilePath>
#Include <Backups\BackupFilePathCreator>

#Include <Shared\Logger>

; Creates a backup model from a path to a backup zip file.
; If the path is not a valid backup zip file, it throws an error.
class Backup {

    Logger := Logger.getInstance()
    BackupFilePathCreator := BackupFilePathCreator()

    ; Properties
    name := ""  ; Name of the backup
    path := ""  ; Path to the backup file
    timestamp := ""  ; Timestamp of when the backup was created
    size := 0  ; Size of the backup file in bytes

    ; Creates a backup model from a path to a backup zip file.
    ; If the path is not a valid backup zip file, it throws an error.
    __New(backupZipPath) {
        this.setPropertiesFromBackupPath(backupZipPath)
    }

    getName() {
        return this.name
    }

    getPath() {
        return this.path
    }

    getTimestamp() {
        return this.timestamp
    }

    ; Unit can be "B" for bytes, "K" for kilobytes, "M" for megabytes.
    ; If an incorrect unit is provided, it defaults to bytes.
    getSize(units := "B") {

        ; By default, size is in bytes
        size := this.size

        if (units = "K") {
            size := Round(this.size / 1024, 2)  ; Convert to kilobytes
        } 
        else if (units = "M") {
            size := Round(this.size / (1024 * 1024), 2)  ; Convert to megabytes
        }

        return size
    }

    setPropertiesFromBackupPath(backupZipPath) {
        info := this.extractInfo(backupZipPath)

        this.path := info.path
        this.name := info.version
        this.timestamp := info.timestamp
        this.size := FileGetSize(this.path, "B")
    }

    extractInfo(backupZipPath) {
        if (!FileExist(backupZipPath)) {
            throw Error("Backup does not exist: " backupZipPath)
        }

        parts := this.BackupFilePathCreator.extractInfo(backupZipPath)

        version := parts.version ; The version is the first part of the name
        timestamp := parts.timestamp ; The timestamp is the second part of the name

        if (version = "" || timestamp = "") {
            this.Logger.logError("Backup name does not follow the correct pattern of 'version_timestamp': " backupZipPath)
            throw Error("Backup name does not follow the correct pattern of 'version_timestamp': " backupZipPath)
        }

        return parts
    }
}
