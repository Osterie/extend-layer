#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\VersionRepository>

#Include <Util\NetworkUtils\Downloading\UnZipper>
#Include <Util\Backup>
#Include <Util\FilePath>

#Include <Updater\UpdaterRunner>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class BackupManager {

    Version := VersionRepository()
    Logger := Logger.getInstance()

    UpdaterRunner := UpdaterRunner()

    UnZipper := UnZipper()

    PROJECT_ROOT := FilePaths.GetAbsolutePathToRoot()

    DELIMITER := "__"

    BACKUP_DIR := FilePaths.getPathToBackups()

    TEMPORARY_DIR_CREATION := FilePaths.getPathToTemporaryLocation() . "\ELBC" ; Temporary location for the backup creation. Shortened from "\extend-layer-backup-creation" to "\ELBC"
    TEMPORARY_DIR_RESTORATION := FilePaths.getPathToTemporaryLocation() . "\ELBR" ; Temporary location for the backup restoration. Shortened from "\extend-layer-backup-restoration" to "\ELBR"

    __New() {
        ; Empty
    }

    ; Returns a Backup object from the given backup path.
    getBackupFromPath(backupPath) {
        if (!FileExist(backupPath)) {
            this.Logger.logError("Backup does not exist: " backupPath)
            throw Error("Backup does not exist: " backupPath)
        }

        return this.createBackupDataModel(backupPath)
    }

    ; Returns a list of all backups in the backups directory. Returned as a list of Backup objects.
    getBackups() {
        backups := []

        loop files, this.BACKUP_DIR "\*.zip", "FD" {
            path := A_LoopFileFullPath

            if (FileExist(path)) {
                backups.Push(this.createBackupDataModel(path))
            }
        }

        return backups
    }

    ; Checks if the current version of Extend Layer is backed up.
    ; Returns true if the current version is backed up, false otherwise.
    currentVersionIsBackedUp() {
        currentVersion := this.Version.getCurrentVersion()

        loop files, this.BACKUP_DIR "\*.zip", "FD" {
            Backup_ := this.createBackupDataModel(A_LoopFileFullPath)
            if (Backup_.getName() = currentVersion) {
                return true
            }
        }

        return false
    }

    ; Creates a backup of the current version of Extend Layer by copying the files to the backup directory. Zip file is saved in the backups directory.
    createBackup() {
        ; Delete the backup in the temporary location if it exists
        if (DirExist(this.TEMPORARY_DIR_CREATION)) {
            DirDelete(this.TEMPORARY_DIR_CREATION, true) ; true = recursive delete
        }
        ; Create a temporary directory for the backup
        DirCreate(this.TEMPORARY_DIR_CREATION)

        ; Copy to temporary location
        DirCopy(this.PROJECT_ROOT, this.TEMPORARY_DIR_CREATION, true) ; true = overwrite
        
        ; Delete the backups directory in the temporary location if it exists, avoids storing backups in backups, which would use double the space each time a backup is created.
        if (DirExist(this.TEMPORARY_DIR_CREATION . "\backups")) {
            DirDelete(this.TEMPORARY_DIR_CREATION . "\backups", true) ; true = recursive delete
        }

        ; Copy and zip the temporary location to the backups directory in the root of the project
        currentVersion := this.Version.getCurrentVersion()
        backupLocation := this.BACKUP_DIR . "\" . currentVersion . this.DELIMITER . A_Now . ".zip"
        this.UnZipper.zip(this.TEMPORARY_DIR_CREATION, backupLocation)
        Sleep(1000)
    }

    ; Restores everything except user profiles
    restoreBackupKeepCurrentProfiles(backupZipPath) {

        if (!this.currentVersionIsBackedUp()) {
            this.createBackup()
        }

        ; Unzips the backup to a temporary location
        this.unZipBackup(backupZipPath)
        
        ; Adds the current profiles to the backup
        this.addCurrentProfilesToBackup(backupZipPath)
        
        ; Updates the current version to the version in the backup
        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)
    }
    
    ; Restores everything including user profiles
    restoreBackupIncludingProfiles(backupZipPath) {

        if (!this.currentVersionIsBackedUp()) {
            this.createBackup()
        }

        ; Unzips the backup to a temporary location
        this.unZipBackup(backupZipPath)

        ; Updates the current version to the version in the backup
        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)
    }

    deleteBackup(backupZipPath) {
        if (!FileExist(backupZipPath)) {
            this.Logger.logError("Backup directory does not exist: " backupZipPath)
            throw Error("Backup directory does not exist: " backupZipPath)
        }

        ; Delete the backup directory
        FileDelete(backupZipPath)
    }

    unZipBackup(backupZipPath) {
        if (!FileExist(backupZipPath)) {
            this.Logger.logError("Backup does not exist: " backupZipPath)
            throw Error("Backup does not exist: " backupZipPath)
        }

        ; unzip the backup directory to a temporary location
        if (DirExist(this.TEMPORARY_DIR_RESTORATION)) {
            DirDelete(this.TEMPORARY_DIR_RESTORATION, true)
        }
        DirCreate(this.TEMPORARY_DIR_RESTORATION)
        this.UnZipper.unzip(backupZipPath, this.TEMPORARY_DIR_RESTORATION)

        this.waitForUnzipCompletion(backupZipPath)

        DirCopy(this.BACKUP_DIR, this.TEMPORARY_DIR_RESTORATION . "\backups", true) ; true = overwrite
    }

    waitForUnzipCompletion(backupZipPath) {
        ; Wait for the unzipping to complete
        waitTime := 0
        while (!DirExist(this.TEMPORARY_DIR_RESTORATION) && waitTime < 10000) {
            Sleep 100
            waitTime += 100
        }

        if (waitTime >= 10000) {
            this.Logger.logError("Failed to unzip the backup directory: " backupZipPath)
            throw Error("Failed to unzip the backup directory: " backupZipPath)
        }
    }

    addCurrentProfilesToBackup(backupZipPath) {
        if (!FileExist(backupZipPath)) {
            this.Logger.logError("Backup directory does not exist: " backupZipPath)
            throw Error("Backup directory does not exist: " backupZipPath)
        }

        ; Delete the old profiles in the backup
        profilesInBackup := this.TEMPORARY_DIR_RESTORATION . "\config\UserProfiles"
        if (DirExist(profilesInBackup)) {
            DirDelete(profilesInBackup, true) ; true = recursive delete
        }
        
        ; Copy the current profiles to the backup
        currentProfiles := FilePaths.GetPathToProfiles()
        DirCopy(currentProfiles, this.TEMPORARY_DIR_RESTORATION . "\config\UserProfiles", true) ; true = overwrite

        this.UnZipper.zip(this.TEMPORARY_DIR_RESTORATION, backupZipPath)
    }

    createBackupDataModel(backupZipPath){
        fileName := this.getBackupFileName(backupZipPath)
        parts := StrSplit(fileName, this.DELIMITER)

        if (parts.Length != 2) {
            this.Logger.logError("Backup directory name is not in the expected format: " backupZipPath)
            throw Error("Backup directory name is not in the expected format: " backupZipPath)
        }

        version := parts[1]  ; The version is the second part of the name
        timestamp := parts[2]  ; The timestamp is the third part of the name
        
        if (version = "" || timestamp = "") {
            this.Logger.logError("Version or timestamp is empty in backup directory: " backupZipPath)
            throw Error("Version or timestamp is empty in backup directory: " backupZipPath)
        }

        return Backup(version, backupZipPath, timestamp)
    }

    getBackupFileName(backupZipPath) {
        file := ""
        try {
            file := FilePath(backupZipPath)
        } catch Error as e {
            this.Logger.logError(e.Message)
            throw e
        }

        return file.getFileName()
    }
}
