#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\VersionRepository>

#Include <Util\NetworkUtils\Downloading\UnZipper>

#Include <Updater\UpdaterRunner>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

; TODO refactor
class BackupManager {

    Version := VersionRepository()
    Logger := Logger.getInstance()

    UpdaterRunner := UpdaterRunner()

    UnZipper := UnZipper()

    PROJECT_ROOT := FilePaths.GetAbsolutePathToRoot()

    BACKUP_DIR := FilePaths.getPathToBackups()

    TEMPORARY_DIR_CREATION := FilePaths.getPathToTemporaryLocation() . "\extend-layer-backup-creation" 
    TEMPORARY_DIR_RESTORATION := FilePaths.getPathToTemporaryLocation() . "\extend-layer-backup-restoration" 

    __New(){
        ; Empty
    }

    ; Creates a backup of the current version of Extend Layer by copying the files to the backup directory.
    createBackup() {
        if (DirExist(this.TEMPORARY_DIR_CREATION)) {
            DirDelete(this.TEMPORARY_DIR_CREATION, true) ; true = recursive delete
        }
        DirCreate(this.TEMPORARY_DIR_CREATION)


        ; Copy to temporary location
        DirCopy(this.PROJECT_ROOT, this.TEMPORARY_DIR_CREATION, true) ; true = overwrite
        ; Delete the backup directory in the temporary location if it exists
        if (DirExist(this.TEMPORARY_DIR_CREATION . "\backups")){
            DirDelete(this.TEMPORARY_DIR_CREATION . "\backups", true) ; true = recursive delete
        }

        currentVersion := this.Version.getCurrentVersion()
        ; Copy and zip the temporary location to the backup directory
        this.UnZipper.zip(this.TEMPORARY_DIR_CREATION, this.BACKUP_DIR . "\" . currentVersion . "_" . A_Now . ".zip")
    }

    ; Restores everything except user profiles
    restoreBackupWithoutOldProfiles(backupDir) {

        if (!FileExist(backupDir)) {
            this.Logger.logError("Backup directory does not exist: " backupDir)
            throw Error("Backup directory does not exist: " backupDir)
        }

        ; unzip the backup directory to a temporary location
        if (DirExist(this.TEMPORARY_DIR_RESTORATION)) {
            DirDelete(this.TEMPORARY_DIR_RESTORATION, true)
        }
        DirCreate(this.TEMPORARY_DIR_RESTORATION)
        this.UnZipper.unzip(backupDir, this.TEMPORARY_DIR_RESTORATION)
        ; Wait for the unzipping to complete
        waitTime := 0
        while (!DirExist(this.TEMPORARY_DIR_RESTORATION) && waitTime < 10000) {
            Sleep 100
            waitTime += 100
        }

        if (waitTime >= 10000) {
            this.Logger.logError("Failed to unzip the backup directory: " backupDir)
            throw Error("Failed to unzip the backup directory: " backupDir)
        }

        profiles := FilePaths.GetPathToProfiles()

        oldProfiles := this.TEMPORARY_DIR_RESTORATION . "\config\UserProfiles"

        if (DirExist(oldProfiles)) {
            ; Delete the old profiles directory
            DirDelete(oldProfiles, true) ; true = recursive delete
        }

        DirCopy(profiles, this.TEMPORARY_DIR_RESTORATION . "\config\UserProfiles", true) ; true = overwrite

        
        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)

    }

    
    ; TODO refactor
    ; Restores everything including user profiles
    restoreBackupIncludingProfiles(backupDir) {
        if (!FileExist(backupDir)) {
            this.Logger.logError("Backup directory does not exist: " backupDir)
            throw Error("Backup directory does not exist: " backupDir)
        }

        ; unzip the backup directory to a temporary location
        if (DirExist(this.TEMPORARY_DIR_RESTORATION)) {
            DirDelete(this.TEMPORARY_DIR_RESTORATION, true)
        }
        DirCreate(this.TEMPORARY_DIR_RESTORATION)
        this.UnZipper.unzip(backupDir, this.TEMPORARY_DIR_RESTORATION)
        ; Wait for the unzipping to complete
        waitTime := 0
        while (!DirExist(this.TEMPORARY_DIR_RESTORATION) && waitTime < 10000) {
            Sleep 100
            waitTime += 100
        }

        if (waitTime >= 10000) {
            this.Logger.logError("Failed to unzip the backup directory: " backupDir)
            throw Error("Failed to unzip the backup directory: " backupDir)
        }

        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)
    }
}