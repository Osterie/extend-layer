#Requires AutoHotkey v2.0

#Include <Util\NetworkUtils\Downloading\UnZipper>

#Include <Shared\FilePaths>

class BackupManager {

    UnZipper := UnZipper()

    PROJECT_ROOT := FilePaths.GetAbsolutePathToRoot()

    BACKUP_DIR := FilePaths.getPathToBackups()

    TEMPORARY_DIR := FilePaths.getPathToTemporaryLocation() . "\extend-layer-backup-creation" 

    __New(){

    }

    ; Creates a backup of the current version of Extend Layer by copying the files to the backup directory.
    createBackup() {
        if (DirExist(this.TEMPORARY_DIR)) {
            DirDelete(this.TEMPORARY_DIR, true) ; true = recursive delete
        }
        DirCreate(this.TEMPORARY_DIR)
        ; Copy to temporary location
        DirCopy(this.PROJECT_ROOT, this.TEMPORARY_DIR, true) ; true = overwrite
        ; Delete the backup directory in the temporary location if it exists
        if (DirExist(this.TEMPORARY_DIR . "\backups")){
            DirDelete(this.TEMPORARY_DIR . "\backups", true) ; true = recursive delete
        }
        ; Copy and zip the temporary location to the backup directory
        this.UnZipper.zip(this.TEMPORARY_DIR, this.BACKUP_DIR . "\extend-layer-backup" . A_Now . ".zip")
    }

    ; Restores the backup by copying the files from the backup directory to the source directory.
    restoreBackup(backupDir) {

        ; FileOverwriteManager_ := FileOverwriteManager()
        ; pathToBackup := this.getPathToBackup(backupDir)

        ; try {
        ;     FileOverwriteManager_.copyIntoNewLocation(pathToBackup, this.PROJECT_ROOT, FilePaths.getPathToUpdateManifest(), true)
        ; }
        ; catch Error as e{
        ;     errorMessage := "Failed to restore backup from: " backupDir " to project root: " this.PROJECT_ROOT
        ;     this.Logger.logError(
        ;         errorMessage 
        ;         . e.Message
        ;         , "AutoUpdater.ahk"
        ;         , e.Line
        ;     )
        ;     throw Error(errorMessage . " " . e.Message . " at line: " . e.Line)
        ; }
    }

    restore(){
        ; this.copyCurrentVersionToTemporaryLocation()
        ; this.updateVersionInTemporaryLocation()
        ; this.updateCurrentVersion()
    }

    ; updateVersionInTemporaryLocation() {
    ;     FileOverwriteManager_ := FileOverwriteManager()
    ;     pathToUnzippedFiles := this.getPathToUnzippedFiles(this.LATEST_RELEASE_DOWNLOAD_LOCATION)

    ;     try {
    ;         FileOverwriteManager_.copyIntoNewLocation(pathToUnzippedFiles, this.CURRENT_VERSION_TEMPORARY_LOCATION, FilePaths.getPathToUpdateManifest(), true)
    ;     }
    ;     catch Error as e{
    ;         errorMessage := "Failed to overwrite files from unzipped location: " this.LATEST_RELEASE_DOWNLOAD_LOCATION " to temporary location: " this.CURRENT_VERSION_TEMPORARY_LOCATION
    ;         this.Logger.logError(
    ;             errorMessage 
    ;             . e.Message
    ;             , "AutoUpdater.ahk"
    ;             , e.Line
    ;         )
    ;         throw Error(errorMessage . " " . e.Message . " at line: " . e.Line)
    ;     }
    ; }
}