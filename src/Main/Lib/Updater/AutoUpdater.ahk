#Requires AutoHotkey v2.0

#Include <Util\Version>
#Include <Util\UpdateManifest>
#Include <Updater\GithubReleaseChecker>
#Include <Util\Logging\Logger>

#Include <Util\UnZipper>


class AutoUpdater {
    static instance := false
    version := Version.getInstance()
    Logger := Logger.getInstance()
    UpdateManifest := UpdateManifest.getInstance()  ; Instance of UpdateManifest to read update manifest
    UnZipper := UnZipper()  ; Instance of UnZipper to handle ZIP extraction

    
    __New() {
    }

    static getInstance() {
        if !AutoUpdater.instance
            AutoUpdater.instance := AutoUpdater()
        return AutoUpdater.instance
    }

    checkForUpdates() {

        currentVersion := this.GetCurrentVersion()

        

        releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", currentVersion)
        
        updateAvailable := releaseChecker.updateAvailable()

        if (updateAvailable) {
            ; MsgBox("Update available! Current")

            ; this.Logger.logInfo("Update available! Current version: " currentVersion ", Latest version: " latestVersion)
            ; Here you can add code to handle the update, like downloading and installing it
        } else {
            ; MsgBox("Up to date!")
            ; this.Logger.logInfo("No updates available. Current version: " currentVersion)
        }

        ; releaseChecker := GithubReleaseChecker("Osterie", "extend-layer", "v0.4.3-alpha")

        downloadUrl := releaseChecker.GetDownloadUrl()
        ; MsgBox(downloadUrl)

        downloadPath := A_Temp "\extend-layer-update.zip" ; or any safe temp/local dir
        unzipLocation := A_Temp "\extend-layer-update" ; or any safe local dir
        ; Download(downloadUrl, downloadPath)
        ; this.UnZipper.Unzip(downloadPath, unzipLocation, true) ; Unzip to the script directory

        ; 1. Download a copy of the current version to a temporary location.
        ; 2. Use the updater to change the files in that temporary location incase any errors occur.
        ; 3. If fail, throw an error and dont change the current version.
        ; If not fail, then copy the files from the temporary location to the current version location.
        ; try{
            this.UpdateCurrentVersion(unzipLocation)
        ; }
        ; catch{
        ;     this.Logger.logError("Failed to update current version: ", "AutoUpdater.ahk", A_LineNumber)
        ;     throw Error("Failed to update current version: " A_LineFile " Line: " A_LineNumber)
        ; }

        ; Download(downloadUrl, A_ScriptDir)

        ; A_Temp
    }

    UpdateCurrentVersion(unzipLocation) {
        ; TODO maybe need admin permissions

        pathToUnzippedFiles := this.GetPathToUnzippedFiles(unzipLocation)
        ; MsgBox(pathToUnzippedFiles)


        overWritePaths := this.UpdateManifest.GetOverwritePaths()
        skipPaths := this.UpdateManifest.GetSkipPaths()

        fullOverWritePaths := Array()
        Loop overWritePaths.Length {
            fullOverWritePaths.Push(pathToUnzippedFiles . "\" . overWritePaths[A_Index])
        }

        fullSkipPaths := Array()
        Loop skipPaths.Length {
            fullSkipPaths.Push(pathToUnzippedFiles . "\" . skipPaths[A_Index]) 
        }

        ; TODO try catch to handle recursion errors and other errors. If fail, then dont merge temporary files into new version.
        this.OverwriteFiles(fullOverWritePaths, fullSkipPaths)



        ; Loop Files, pathToUnzippedFiles . "\*", "FDR" { ; "R" means "Recursively, F means include files, D means include directories"
        ;     MsgBox("Found or folder: " A_LoopFileShortName)
        ; }
        ; Read from update-manifest.json
        ; AttributeString := FileExist(FilePattern)
    }

    

    OverwriteFiles(overwritePaths, skipPaths) {
        Loop overwritePaths.Length {
            skippedPath := this.GetSkippedFile(overwritePaths[A_Index], skipPaths)

            if (skippedPath == "") {
                ; Overwrite
                MsgBox("Overwriting file: " overwritePaths[A_Index])
            }
            else{
                ; Go deeper if possible, else go back.
                MsgBox("Skipping file: " overwritePaths[A_Index] . " GOING DEEPER: " this.GetFilesInDirectory(overwritePaths[A_Index]).Length)

                ; If the skippedPath is the same as the current overwritePath, then skip it.
                ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
                if (overwritePaths[A_Index] == skippedPath) {
                    MsgBox("Skipping path: " overwritePaths[A_Index] . " because the fil/directory is designated to be skipped.")
                }
                else{ ; If only part of the path is present in the skipPaths, then we need to go deeper.
                    this.OverwriteFiles(this.GetFilesInDirectory(overwritePaths[A_Index]), skipPaths)
                }

            }

            ; else {
            ;     this.Logger.logInfo("Overwriting file: " overwritePaths[A_Index])
            ;     FileCopy(overwritePaths[A_Index], A_ScriptDir . "\" . StrSplit(overwritePaths[A_Index], "\")[-1], 1) ; 1 means overwrite
            ; }


            ; MsgBox("Skipping path: " overwritePaths[A_Index])
            ; skip := true
        }
    }



    GetSkippedFile(overwritePath, skipPaths){
        Loop skipPaths.Length {
            if (InStr(skipPaths[A_Index], overwritePath)) {
                return skipPaths[A_Index]
            }
        }

        return ""
    }

    GetFilesInDirectory(directory) {
        files := Array()
        Loop Files, directory . "\*", "FD" { ; "F" means include files, "D" means include directories
            files.Push(A_LoopFileFullPath)
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
        Loop Files, unzipLocation . "\*", "D" {
            foundPath  := A_LoopFileFullPath
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