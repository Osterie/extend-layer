#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Util\UpdateManifest>
#Include <Updater\GithubReleaseChecker>
#Include <Util\Logging\Logger>
#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

#Include <Util\UnZipper>

class AutoUpdater {
    static instance := false
    Version := Version.getInstance()
    Logger := Logger.getInstance()
    UpdateManifest := UpdateManifest.getInstance()  ; Instance of UpdateManifest to read update manifest
    UnZipper := UnZipper()  ; Instance of UnZipper to handle ZIP extraction
    releaseChecker := ""  ; Instance of GithubReleaseChecker to check for updates

    __New() {
        currentVersion := ""
        try {
            currentVersion := this.GetCurrentVersion()
        }
        catch {
            this.Logger.logError("Failed to get current version. Using default version: unknown", "AutoUpdater.ahk",
                A_LineNumber)
            currentVersion := "unknown"  ; Default version if current version cannot be retrieved
        }
        this.releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
    }

    static getInstance() {
        if (!AutoUpdater.instance) {
            AutoUpdater.instance := AutoUpdater()
        }
        return AutoUpdater.instance
    }

    checkForUpdates() {

        updateAvailable := this.releaseChecker.updateAvailable()

        if (updateAvailable) {
            downloadUrl := this.releaseChecker.GetDownloadUrl()
            ; MsgBox(downloadUrl)

            downloadPath := A_Temp "\extend-layer-update.zip"
            unzipLocation := A_Temp "\extend-layer-update"
            if (FileExist(downloadPath)) {
                FileDelete(downloadPath) ; Delete the old download if it exists
            }
            Download(downloadUrl, downloadPath)
            if (FileExist(unzipLocation)) {
                DirDelete(unzipLocation, true) ; Delete the old unzip location if it exists
            }
            this.UnZipper.Unzip(downloadPath, unzipLocation, true) ; Unzip to the script directory

            ; try{
            this.UpdateCurrentVersion(unzipLocation)
            ; }
            ; catch{
            ;     this.Logger.logError("Failed to update current version: ", "AutoUpdater.ahk", A_LineNumber)
            ;     throw Error("Failed to update current version: " A_LineFile " Line: " A_LineNumber)
            ; }

            ; MsgBox("Update available! Current")

            ; this.UpdateCurrentVersion(unzipLocation)

            ; this.Logger.logInfo("Update available! Current version: " currentVersion ", Latest version: " latestVersion)
            ; Here you can add code to handle the update, like downloading and installing it
        } else {
            ; MsgBox("Up to date!")
            ; this.Logger.logInfo("No updates available. Current version: " currentVersion)
        }

        ; this.releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", "v0.4.3-alpha")

        ; 1. Download a copy of the current version to a temporary location.
        ; 2. Use the updater to change the files in that temporary location incase any errors occur.
        ; 3. If fail, throw an error and dont change the current version.
        ; If not fail, then copy the files from the temporary location to the current version location.

        ; Download(downloadUrl, A_ScriptDir)

        ; A_Temp

    }

    UpdateCurrentVersion(unzipLocation) {
        ; TODO maybe need admin permissions

        temporaryLocation := A_Temp "\extend-layer-temporary"

        if (DirExist(temporaryLocation)) {
            DirDelete(temporaryLocation, true) ; true = recursive delete
        }
        DirCopy(FilePaths.GetAbsolutePathToRoot(), temporaryLocation, true)

        pathToUnzippedFiles := this.GetPathToUnzippedFiles(unzipLocation)
        ; MsgBox(pathToUnzippedFiles)

        relativeWritePaths := this.UpdateManifest.GetOverwritePaths()
        relativeSkipPaths := this.UpdateManifest.GetSkipPaths()

        ; fullOverWritePaths := Array()
        ; Loop overWritePaths.Length {
        ;     fullOverWritePaths.Push(pathToUnzippedFiles . "\" . overWritePaths[A_Index])
        ; }

        fullSkipPaths := Array()
        loop relativeSkipPaths.Length {
            fullSkipPaths.Push(pathToUnzippedFiles . "\" . relativeSkipPaths[A_Index])
        }

        success := false
        try {
            ; TODO try catch to handle recursion errors and other errors. If fail, then dont merge temporary files into new version.
            this.OverwriteFiles(pathToUnzippedFiles, temporaryLocation, relativeWritePaths, fullSkipPaths)
            success := true
        }
        catch {
            success := false
            this.Logger.logError("Failed to overwrite files from unzipped location: " unzipLocation " to temporary location: " temporaryLocation,
                "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to overwrite files from unzipped location: " unzipLocation " to temporary location: " temporaryLocation " Line: " A_LineNumber
            )
        }

        if (success) {
            ; If the overwrite was successful, then copy the files from the temporary location to the current version location.
            ; MsgBox("Copying files from temporary location: " temporaryLocation " to current version location: " FilePaths.GetAbsolutePathToRoot())

            ; todo TRY CATCH. CATCH
            ; DirCopy(temporaryLocation, FilePaths.GetAbsolutePathToRoot(), true) ; true = overwrite
            ; this.Version.UpdateVersion(this.releaseChecker.GetLatestVersionInfo())

            ; updaterExe := FilePaths.GetAbsolutePathToRoot() . "\src\Main\Lib\Updater\AutoUpdater.exe"
            ; Run, "%updaterExe%" "%temporaryLocation%" "% FilePaths.GetAbsolutePathToRoot() %" "%A_ScriptFullPath%"
            ; ExitApp

            ; At end of your update function

            ; if success {
            updaterExe := A_ScriptDir "\Lib\Updater\Updater.exe"
            mainScript := A_ScriptFullPath

            ; MsgBox(updaterExe)
            ; MsgBox(FileExist(updaterExe) ? "Updater executable found." : "Updater executable not found. Please check the path.")
            ; MsgBox(FileExist(temporaryLocation) ? "Temporary location found." : "Temporary location not found. Please check the path.")
            ; MsgBox(FileExist(FilePaths.GetAbsolutePathToRoot()) ? "Current version location found." : "Current version location not found. Please check the path.")
            ; MsgBox(FileExist(mainScript) ? "Main script found." : "Main script not found. Please check the path.")

            ; tempUpdaterPath := A_Temp "\Updater.exe"
            ; FileCopy updaterExe, tempUpdaterPath, true

            ; Run tempUpdaterPath ' "' tempDataPath '" "' currentInstallPath '" "' mainScript '" "' version '"'
            ; ExitApp

            ; Define original and temporary paths
            originalUpdater := A_ScriptDir "\Lib\Updater\Updater.exe"
            tempUpdater := A_Temp "\Updater.exe"

            try {
                DetectHiddenWindows true

                pid := ProcessExist("Updater.exe")
                if pid {

                    ProcessWaitClose("Updater.exe", 2000)

                    ; Check again after waiting
                    if ProcessExist("Updater.exe") {
                        throw Error("Updater did not close in time.")
                    }
                }

                if (FileExist(tempUpdater)) {
                    FileDelete tempUpdater ; Delete the temporary updater if it exists
                }

                FileCopy originalUpdater, tempUpdater, true ; true = overwrite if exists
            }
            catch Error as e {
                throw e
            }

            ; Build command-line arguments
            mainScript := A_ScriptFullPath
            rootPath := FilePaths.GetAbsolutePathToRoot()
            version := this.releaseChecker.GetLatestVersionInfo()

            ; Confirm all critical files exist
            if !FileExist(tempUpdater) {
                this.Logger.logError("Failed to copy Updater.exe to temp directory.")
                throw Error("Failed to copy Updater.exe to temp directory.")
            }

            ; Optional debug
            ; MsgBox "Running updater from: " tempUpdater "`nWith arguments:`n" temporaryLocation "`n" rootPath "`n" mainScript "`n" version

            ; Run updater from temp and exit current app

            pathToVersionFile := FilePaths.GetAbsolutePathToRoot() . "config\Version.json"
            pathToControlScript := FilePaths.GetAbsolutePathToRoot() . "src\controlScript.exe"

            ; this.OnExitMethod := ObjBindMethod(this, "runUpdaterExe",tempUpdater, temporaryLocation, rootPath, mainScript, version, pathToVersionFile, pathToControlScript)
            this.OnExitMethod := (ExitReason?, ExitCode?) => this.runUpdaterExe(
                tempUpdater, temporaryLocation, rootPath,
                mainScript, version, pathToVersionFile, pathToControlScript
            )
            OnExit this.OnExitMethod
            ExitApp

            ; Run updaterExe ' "' temporaryLocation '" "' FilePaths.GetAbsolutePathToRoot() '" "' mainScript '" "' this.releaseChecker.GetLatestVersionInfo() '"'
            ; ExitApp
            ; }

        }
        else {
            this.Logger.logError("Failed to update current version from: " pathToUnzippedFiles " to: " FilePaths.GetAbsolutePathToRoot())
            throw Error("Failed to update current version from: " pathToUnzippedFiles " to: " FilePaths.GetAbsolutePathToRoot())
        }
    }

    runUpdaterExe(tempUpdater, temporaryLocation, rootPath, mainScript, version, pathToVersionFile, pathToControlScript) {
        ; This function is used to run the updater executable with the provided arguments.

        ; Build command-line arguments
        args := '"' temporaryLocation '" "' rootPath '" "' mainScript '" "' version '" "' pathToVersionFile '" "' pathToControlScript '"'

        ; Run updater from temporary location
        Run '"' tempUpdater '" ' args
    }

    OverwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeOverwritePaths, fullSkipPaths) {
        loop relativeOverwritePaths.Length {
            ; TODO use construct method
            fullOverwritePath := sourceBaseLocation . "\" . relativeOverwritePaths[A_Index]

            skippedPath := this.GetSkippedFile(fullOverwritePath, fullSkipPaths)

            if (skippedPath == "") {
                ; Overwrite
                ; TODO use construct method
                copyDestination := destinationBaseLocation . "\" . relativeOverwritePaths[A_Index]
                ; MsgBox("Overwriting file: " fullOverwritePath . " With destination: " destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])
                if (DirExist(fullOverwritePath)) {
                    DirCopy(fullOverwritePath, copyDestination, true) ; true = overwrite
                } else if (FileExist(fullOverwritePath)) {
                    FileCopy(fullOverwritePath, copyDestination, true) ; true = overwrite
                }
                else {
                    ; Skip, file or directory does not exist.
                    this.Logger.logInfo("File or directory does not exist: " fullOverwritePath)
                }

            }
            else {

                if (!DirExist(destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])) {
                    if (!FileExist(destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])) {
                        ; this.Logger.logError("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])
                        ; throw Error("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])
                        DirCreate(destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])
                    }
                    ; MsgBox(destinationBaseLocation . "\" . relativeOverwritePaths[A_Index])
                }
                ; Go deeper if possible, else go back.
                ; MsgBox("Going deeper: " fullOverwritePath . " GOING DEEPER: " this.GetFilesInDirectory(fullOverwritePath, relativeOverwritePaths[A_Index]).Length)

                ; If the skippedPath is the same as the current overwritePath, then skip it.
                ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
                if (fullOverwritePath == skippedPath) {
                    ; MsgBox("Skipping path: " fullOverwritePath . " because the fil/directory is designated to be skipped.")
                }
                else { ; If only part of the path is present in the fullSkipPath, then we need to go deeper.
                    this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, this.GetFilesInDirectory(
                        fullOverwritePath, relativeOverwritePaths[A_Index]), fullSkipPaths)
                }
            }
        }
    }

    ; OverwriteFiles(sourceBaseLocation, destinationBaseLocation, fullOverwritePaths, fullSkipPaths) {
    ;     Loop fullOverwritePaths.Length {
    ;         fullOverwritePath := fullOverwritePaths[A_Index]

    ;         skippedPath := this.GetSkippedFile(fullOverwritePath, fullSkipPaths)

    ;         if (skippedPath == "") {
    ;             ; Overwrite
    ;             MsgBox("Overwriting file: " fullOverwritePath)
    ;             if (DirExist(fullOverwritePath)) {
    ;                 ; DirCopy(fullOverwritePath, sourceBaseLocation . "\" . fullOverwritePath, true) ; true = overwrite
    ;             } else if (FileExist(fullOverwritePath)) {
    ;                 ; FileCopy(fullOverwritePath, sourceBaseLocation . "\" . fullOverwritePath, true)
    ;             }

    ;         }
    ;         else{
    ;             ; Go deeper if possible, else go back.
    ;             MsgBox("Skipping file: " fullOverwritePath . " GOING DEEPER: " this.GetFilesInDirectory(fullOverwritePath).Length)

    ;             ; If the skippedPath is the same as the current overwritePath, then skip it.
    ;             ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
    ;             if (fullOverwritePath == skippedPath) {
    ;                 MsgBox("Skipping path: " fullOverwritePath . " because the fil/directory is designated to be skipped.")
    ;             }
    ;             else{ ; If only part of the path is present in the fullSkipPath, then we need to go deeper.
    ;                 this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, this.GetFilesInDirectory(fullOverwritePath), fullSkipPaths)
    ;             }
    ;         }
    ;     }
    ; }

    ConstructPath(baseLocation, relativePath) {
        if (relativePath == "") {
            return baseLocation
        }
        return baseLocation . "\" . relativePath
    }

    GetSkippedFile(overwritePath, skipPaths) {
        loop skipPaths.Length {
            if (InStr(skipPaths[A_Index], overwritePath)) {
                return skipPaths[A_Index]
            }
        }
        return ""
    }

    GetFilesInDirectory(directoryPath, directoryName) {
        files := Array()
        loop files, directoryPath . "\*", "FD" { ; "F" means include files, "D" means include directories
            files.Push(directoryName . "\" . A_LoopFileName)
        }
        return files
    }
    ; GetFilesInDirectory(directory) {
    ;     files := Array()
    ;     Loop Files, directory . "\*", "FD" { ; "F" means include files, "D" means include directories
    ;         files.Push(A_LoopFileFullPath)
    ;     }
    ;     return files
    ; }

    GetPathToUnzippedFiles(unzipLocation) {
        if (!FileExist(unzipLocation)) {
            this.Logger.logError("Unzipped location does not exist: " unzipLocation)
            throw Error("Unzipped location does not exist: " unzipLocation)
        }

        foundPath := ""
        index := 1
        loop files, unzipLocation . "\*", "D" {
            foundPath := A_LoopFileFullPath
            index += 1
        }

        if (index > 2) {
            this.Logger.logError("Multiple directories found in unzipped location: " unzipLocation)
            throw Error("Multiple directories found in unzipped location: " unzipLocation)
        }

        return foundPath
    }

    GetCurrentVersion() {

        currentVersion := ""
        try {
            currentVersion := this.Version.GetCurrentVersion()
        }
        catch {
            this.Logger.logError("Failed to get current version. Using provided version: " currentVersion)
            throw Error("Failed to get current version. Using provided version: " currentVersion)
        }

        return currentVersion
    }
}
