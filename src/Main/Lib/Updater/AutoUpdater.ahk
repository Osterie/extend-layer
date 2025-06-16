#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Util\UpdateManifest>
#Include <Util\Downloader>
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

    LATEST_RELEASE_DOWNLOAD_LOCATION := A_Temp "\extend-layer-update"  ; Default download location for the latest release
    TEMPORARY_LOCATION_FOR_CURRENT_VERSION := A_Temp "\extend-layer-temporary"  ; Temporary location for the current version

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
        if (!updateAvailable) {
            return false ; No updates available
        }

        this.updateCurrentVersion()
    }

    ; 1. Download a copy of the current version to a temporary location.
    ; 2. Use the updater to change the files in that temporary location incase any errors occur.
    ; 3. If fail, throw an error and dont change the current version.
    ; If not fail, then copy the files from the temporary location to the current version location.
    updateCurrentVersion() {
        ; TODO maybe need admin permissions

        this.downloadLatestRelease()
        this.copyCurrentVersionToTemporaryLocation()
        success := this.updateVersionInTemporaryLocation()

        if (!success) {
            pathToUnzippedFiles := this.GetPathToUnzippedFiles(this.LATEST_RELEASE_DOWNLOAD_LOCATION)
            this.Logger.logError("Failed to update current version from: " pathToUnzippedFiles " to: " FilePaths.GetAbsolutePathToRoot())
            throw Error("Failed to update current version from: " pathToUnzippedFiles " to: " FilePaths.GetAbsolutePathToRoot())
        }
        ; If the overwrite was successful, then copy the files from the temporary location to the current version location.

        ; Paths to original updater and location to copy it to. Updater is launched from the temporary location.
        ; Since it is not possible to update the running script, we need to copy the updater to a temporary location and run it from there.
        originalUpdater := A_ScriptDir "\Lib\Updater\Updater.exe"
        tempUpdater := A_Temp "\Updater.exe"

        if (!FileExist(originalUpdater)) {
            this.Logger.logError("Updater.exe does not exist in the expected location: " originalUpdater)
            throw Error("Updater.exe does not exist in the expected location: " originalUpdater)
        }

        try {
            DetectHiddenWindows true
            result := closeProcess("Updater.exe")
            if (!result) {
                this.Logger.logError("Failed to close Updater.exe before copying.")
                throw Error("Failed to close Updater.exe before copying.")
            }

            if (FileExist(tempUpdater)) {
                FileDelete tempUpdater ; Delete the temporary updater if it exists
            }

            FileCopy originalUpdater, tempUpdater, true ; true = overwrite if exists
        }
        catch Error as e {
            this.Logger.logError("Failed to copy Updater.exe to temporary location: " e.Message, "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to copy Updater.exe to temporary location: " e.Message)
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

        pathToVersionFile := FilePaths.GetAbsolutePathToRoot() . "config\Version.json"
        pathToControlScript := FilePaths.GetAbsolutePathToRoot() . "src\controlScript.exe"
        pid := DllCall("GetCurrentProcessId", "UInt")

        ; Run updater from temporary location and exit current app
        this.OnExitMethod := (ExitReason?, ExitCode?) => this.runUpdaterExe(
            tempUpdater, this.TEMPORARY_LOCATION_FOR_CURRENT_VERSION, rootPath, pid,
            mainScript, version, pathToVersionFile, pathToControlScript
        )
        OnExit this.OnExitMethod
        ExitApp
    }

    downloadLatestRelease() {
        downloadUrl := this.releaseChecker.GetDownloadUrl()
        zipDownloadLocation := this.LATEST_RELEASE_DOWNLOAD_LOCATION . ".zip" ; Ensure the download location has a .zip extension
        Downloader_ := Downloader() ; Create an instance of Downloader to handle the download
        
        Downloader_.DownloadZip(downloadUrl, zipDownloadLocation, this.LATEST_RELEASE_DOWNLOAD_LOCATION, true) ; Download the ZIP file
    }

    copyCurrentVersionToTemporaryLocation() {

        if (DirExist(this.TEMPORARY_LOCATION_FOR_CURRENT_VERSION)) {
            DirDelete(this.TEMPORARY_LOCATION_FOR_CURRENT_VERSION, true) ; true = recursive delete
        }

        ; Copy the current version to the temporary location
        DirCopy(FilePaths.GetAbsolutePathToRoot(), this.TEMPORARY_LOCATION_FOR_CURRENT_VERSION, true) ; true = overwrite
    }

    updateVersionInTemporaryLocation() {
        pathToUnzippedFiles := this.GetPathToUnzippedFiles(this.LATEST_RELEASE_DOWNLOAD_LOCATION)

        relativeWritePaths := this.UpdateManifest.GetOverwritePaths()
        relativeSkipPaths := this.UpdateManifest.GetSkipPaths()

        fullSkipPaths := Array()
        loop relativeSkipPaths.Length {
            fullSkipPaths.Push(pathToUnzippedFiles . "\" . relativeSkipPaths[A_Index])
        }

        success := false
        try {
            ; TODO try catch to handle recursion errors and other errors. If fail, then dont merge temporary files into new version.
            this.OverwriteFiles(pathToUnzippedFiles, this.TEMPORARY_LOCATION_FOR_CURRENT_VERSION, relativeWritePaths,
                fullSkipPaths)
            success := true
        }
        catch {
            success := false
            this.Logger.logError("Failed to overwrite files from unzipped location: " this.LATEST_RELEASE_DOWNLOAD_LOCATION " to temporary location: " this
                .TEMPORARY_LOCATION_FOR_CURRENT_VERSION,
                "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to overwrite files from unzipped location: " this.LATEST_RELEASE_DOWNLOAD_LOCATION " to temporary location: " this
                .TEMPORARY_LOCATION_FOR_CURRENT_VERSION " Line: " A_LineNumber
            )
        }

        return success
    }

    ; This function is used to run the updater executable with the provided arguments.
    runUpdaterExe(tempUpdater, temporaryLocation, rootPath, pid, mainScript, version, pathToVersionFile,
        pathToControlScript) {

        ; Build command-line arguments
        args := '"' temporaryLocation '" "' rootPath '" "' pid '" "' mainScript '" "' version '" "' pathToVersionFile '" "' pathToControlScript '"'

        ; Run updater from temporary location with given argumetns
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

                if (DirExist(fullOverwritePath)) {
                    DirCopy(fullOverwritePath, copyDestination, true) ; true = overwrite
                }
                else if (FileExist(fullOverwritePath)) {
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

; TODO move, to processmanager.ahk?
closeProcess(process) {
    tries := 0
    while (ProcessExist(process) && tries < 10) {
        pid := ProcessExist(process)
        if pid {
            ProcessClose(pid)
            Sleep 500 ; Wait for 0.5 seconds
            tries++
            if !ProcessExist(process) {
                return true
            }
        }
    }
    if !ProcessExist(process) {
        return true
    }
    return false
}
