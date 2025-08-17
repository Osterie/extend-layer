#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\VersionRepository>

#Include <Util\NetworkUtils\Downloading\UnZipper>
#Include <Util\Backup>
#Include <Util\BackupFilePathCreator>

#Include <ui\util\ProgressBar>

#Include <Updater\UpdaterRunner>

#Include <Shared\FilePaths>
#Include <Shared\Logger>

class BackupManager {

    Version := VersionRepository()
    Logger := Logger.getInstance()

    UpdaterRunner := UpdaterRunner()

    UnZipper := UnZipper()

    PROJECT_ROOT := FilePaths.GetAbsolutePathToRoot()

    BACKUP_DIR := FilePaths.getPathToBackups()

    PATH_TO_CURRENT_PROFILES := FilePaths.GetPathToProfiles()

    TEMPORARY_DIR_CREATION := FilePaths.getPathToTemporaryLocation() . "\ELBC" ; Temporary location for the backup creation. Shortened from "\extend-layer-backup-creation" to "\ELBC"
    TEMPORARY_DIR_RESTORATION := FilePaths.getPathToTemporaryLocation() . "\ELBR" ; Temporary location for the backup restoration. Shortened from "\extend-layer-backup-restoration" to "\ELBR"

    __New() {
        ; Empty
    }

    ; Returns a list of all backups in the backups directory. Returned as a list of Backup objects.
    getBackups() {
        backups := []

        loop files, this.BACKUP_DIR "\*.zip", "FD" {
            path := A_LoopFileFullPath

            if (FileExist(path)) {
                backups.Push(Backup(path))
            }
        }

        return backups
    }

    ; Checks if the current version of Extend Layer is backed up.
    ; Returns true if the current version is backed up, false otherwise.
    currentVersionIsBackedUp() {
        currentVersion := this.Version.getCurrentVersion()

        loop files, this.BACKUP_DIR "\*.zip", "FD" {
            backupZipFilePath := A_LoopFileFullPath
            Backup_ := Backup(backupZipFilePath)
            if (Backup_.getName() = currentVersion) {
                return true
            }
        }

        return false
    }

    ; Creates a backup of the current version of Extend Layer by copying the files to the backup directory. 
    ; Zip file is saved in the backups directory.
    createBackup() {

        ProgressBar_ := ProgressBar("Creating Extend Layer backup...")

        steps := 4
        stepSize := 100 / steps

        ; Delete the backup in the temporary location if it exists
        ProgressBar_.updateProgress("Deleting existing temporary backup ...", 1 * stepSize)
        if (DirExist(this.TEMPORARY_DIR_CREATION)) {
            DirDelete(this.TEMPORARY_DIR_CREATION, true) ; true = recursive delete
        }
        ; Create a temporary directory for the backup
        DirCreate(this.TEMPORARY_DIR_CREATION)

        ; Copy to temporary location
        ProgressBar_.updateProgress("Creating backup in temporary location...", 2 * stepSize)
        DirCopy(this.PROJECT_ROOT, this.TEMPORARY_DIR_CREATION, true) ; true = overwrite

        ; Delete the backups directory in the temporary location if it exists, avoids storing backups in backups, which would use double the space each time a backup is created.
        ProgressBar_.updateProgress("Readying backup in temporary location", 3 * stepSize)
        if (DirExist(this.TEMPORARY_DIR_CREATION . "\backups")) {
            DirDelete(this.TEMPORARY_DIR_CREATION . "\backups", true) ; true = recursive delete
        }

        ; Copy and zip the temporary location to the backups directory in the root of the project
        ProgressBar_.updateProgress("Copying and zipping backup from temporary location...", 4 * stepSize)
        backupLocation := this.createBackupFilePath()
        this.UnZipper.zip(this.TEMPORARY_DIR_CREATION, backupLocation)

        ; Done
        Sleep(1000)
        ProgressBar_.destroy()
    }

    ; Creates a backup file path based on the current version and the current time.
    ; Looks something like ".../extend-layer/backups/v0.5.0__20250708213715.zip"
    createBackupFilePath() {
        currentVersion := this.Version.getCurrentVersion()
        timestamp := A_Now

        BackupFilePathCreator_ := BackupFilePathCreator()
        backupLocation := BackupFilePathCreator_.createBackupFilePath(currentVersion, timestamp)
        return backupLocation
    }

    ; Restores everything except user profiles
    restoreBackupKeepCurrentProfiles(backupZipPath) {

        ProgressBar_ := ProgressBar("Restoring Extend Layer backup...")

        steps := 3
        stepSize := 100 / steps

        ; Creates a backup of the current version if it is not already backed up
        ; This is to ensure that the current version is backed up before restoring a backup, incase something goes wrong.
        if (!this.currentVersionIsBackedUp()) {
            ProgressBar_.updateProgress("Backing up current version...", 0)
            this.createBackup()
        }

        ; Unzips the backup to a temporary location
        ProgressBar_.updateProgress("Unzipping backup to temporary location...", 1 * stepSize)
        this.unZipBackup(backupZipPath)

        ; Adds the current profiles to the backup
        ProgressBar_.updateProgress("Adding current profiles to the backup...", 2 * stepSize)
        this.addCurrentProfilesToBackup(backupZipPath)

        ; Updates the current version to the version in the backup
        ProgressBar_.updateProgress("Replacing current version with backup...", 3 * stepSize)
        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)
    }

    ; Restores everything including user profiles
    restoreBackupIncludingProfiles(backupZipPath) {

        ProgressBar_ := ProgressBar("Restoring Extend Layer backup...")

        steps := 2
        stepSize := 100 / steps

        ; Creates a backup of the current version if it is not already backed up
        ; This is to ensure that the current version is backed up before restoring a backup, incase something goes wrong.
        if (!this.currentVersionIsBackedUp()) {
            ProgressBar_.updateProgress("Backing up current version...", 0)
            this.createBackup()
        }

        ; Unzips the backup to a temporary location
        ProgressBar_.updateProgress("Unzipping backup to temporary location...", 1 * stepSize)
        this.unZipBackup(backupZipPath)

        ; Updates the current version to the version in the backup
        ProgressBar_.updateProgress("Replacing current version with backup...", 2 * stepSize)
        this.UpdaterRunner.runUpdater(this.TEMPORARY_DIR_RESTORATION, this.PROJECT_ROOT, true)
    }

    ; Deletes the backup zip file.
    deleteBackup(backupZipPath) {
        if (!FileExist(backupZipPath)) {
            this.Logger.logError("Backup directory does not exist: " backupZipPath)
            throw Error("Backup directory does not exist: " backupZipPath)
        }

        ; Delete the backup
        FileDelete(backupZipPath)
    }

    ; Unzips the backup zip file to a temporary location.
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

    ; Waits for the unzipping to complete by checking if the temporary directory exists.
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

    ; Adds the current profiles to the backup zip file.
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
        DirCopy(this.PATH_TO_CURRENT_PROFILES, this.TEMPORARY_DIR_RESTORATION . "\config\UserProfiles", true) ; true = overwrite

        this.UnZipper.zip(this.TEMPORARY_DIR_RESTORATION, backupZipPath)
    }
}
