#Requires AutoHotkey v2.0

#Include <Infrastructure\Repositories\UpdateManifestRepository>
#Include <Shared\Logger>

class FileOverwriteManager {

    Logger := Logger.getInstance()

    __New(){
        ; Empty constructor
    }

    copyIntoNewLocation(sourceBaseLocation, destinationBaseLocation, updateManifestPath, removeOldFiles := true) {
        UpdateManifestRepository_ := UpdateManifestRepository(updateManifestPath)

        relativeOverwritePaths := UpdateManifestRepository_.getOverwritePaths()
        fullSkipPaths := this.createFullSkipPaths(sourceBaseLocation, UpdateManifestRepository_)
        this.overwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeOverwritePaths, fullSkipPaths, removeOldFiles)
    }

    overwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeOverwritePaths, fullSkipPaths, removeOldFiles) {
        loop relativeOverwritePaths.Length {
            relativeOverwritePath := relativeOverwritePaths[A_Index]

            fullOverwritePath := this.constructPath(sourceBaseLocation, relativeOverwritePath)
            skippedPath := this.getSkippedPath(fullOverwritePath, fullSkipPaths)
            copyDestination := this.constructPath(destinationBaseLocation, relativeOverwritePath)
            
            if (skippedPath == "") {
                ; No skipped files/directories, so we can overwrite the files or directories.
                this.replaceFiles(fullOverwritePath, copyDestination, removeOldFiles)
            }
            else {
                ; Some files or directories in the current overwrite path are skipped, so we need to go deeper into the relative path.
                this.overwriteDeeper(sourceBaseLocation, destinationBaseLocation, relativeOverwritePath, fullSkipPaths, removeOldFiles)
            }
        }
    }

    replaceFiles(copySource, copyDestination, removeOldFiles) {
        if (removeOldFiles){
            this.removeOldFiles(copyDestination) ; Remove old files or directories if they exist
        }

        this.copyFiles(copySource, copyDestination) ; Copy the files or directories
    }

    removeOldFiles(location){
        if (DirExist(location)) {
            DirDelete(location, true) ; true = delete all files and subdirectories
        }
        else if (FileExist(location)) {
            FileDelete(location)
        }
        else {
            this.Logger.logInfo("Could not remove old file/directory, file or directory does not exist: " . location)
        }
    }

    copyFiles(copySource, copyDestination) {
        if (DirExist(copySource)) { ; If directory.
            DirCopy(copySource, copyDestination, true) ; true = overwrite
        }
        else if (FileExist(copySource)) { ; If file.
            FileCopy(copySource, copyDestination, true) ; true = overwrite
        }
        else {
            this.Logger.logInfo("Could not copy file/directory, file or directory does not exist: " . copySource)
        }
    }

    overwriteDeeper(sourceBaseLocation, destinationBaseLocation, relativeOverwritePath, fullSkipPaths, removeOldFiles){

        fullOverwritePath := this.constructPath(sourceBaseLocation, relativeOverwritePath)
        skippedPath := this.getSkippedPath(fullOverwritePath, fullSkipPaths)

        ; There are no skipped files/directories in the current overwrite path.
        copyDestination := this.constructPath(destinationBaseLocation, relativeOverwritePath)
        
        ; Skip, but we need to ensure the directory structure exists in the destination location.
        ; For example "...\src\Main\Lib\Directory" might not exist, so we need to create it if it does not exist.
        ; If not, we would get an error when trying to write to the file "...\src\Main\Lib\Directory\file.txt" because the directory does not exist.
        this.createMissingDirectory(copyDestination)


        ; If the skippedPath is the same as the current overwritePath, then skip it.
        ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
        if (fullOverwritePath == skippedPath) { ; Skip
            ; The current overwrite path is skipped, so we do not overwrite it.
            this.Logger.logInfo("Skipping file or directory: " fullOverwritePath)
        }
        else { ; Go deeper 
            ; Some files or directories in the current overwrite path are skipped, so we need to go deeper.
            ; For example: overwritePath = "src\Main\Lib\Directory"
            ; skipPaths = ["src\Main\Lib\Directory\file.txt", "src\Main\Lib\Directory\subdirectory"]
            ; We need to go deeper into the "src\Main\Lib\Directory" directory and overwrite the files in it, but skip the files and directories that are in the skipPaths.
            deeperOverwritePaths := this.getFilesInDirectory(fullOverwritePath, relativeOverwritePath)
            this.overwriteFiles(sourceBaseLocation, destinationBaseLocation, deeperOverwritePaths, fullSkipPaths, removeOldFiles)
        }
    }

    createFullSkipPaths(sourceBaseLocation, UpdateManifestRepository_){
        relativeSkipPaths := UpdateManifestRepository_.getSkipPaths()

        fullSkipPaths := Array()
        loop relativeSkipPaths.Length {
            fullSkipPath := this.constructPath(sourceBaseLocation, relativeSkipPaths[A_Index])
            fullSkipPaths.Push(fullSkipPath)
        }
        return fullSkipPaths
    }

    constructPath(baseLocation, relativePath) {
        if (relativePath == "") {
            return baseLocation
        }
        return baseLocation . "\" . relativePath
    }

    getSkippedPath(overwritePath, skipPaths) {
        if (skipPaths.Length == 0) {
            return "" ; No skip paths, so no skipped file or directory.
        }
        loop skipPaths.Length {
            if (InStr(skipPaths[A_Index], overwritePath)) {
                return skipPaths[A_Index]
            }
        }
    }

    getFilesInDirectory(directoryPath, directoryName) {
        files := Array()
        loop files, directoryPath . "\*", "FD" { ; "F" means include files, "D" means include directories
            files.Push(directoryName . "\" . A_LoopFileName)
        }
        return files
    }

    createMissingDirectory(directoryPath) {
        if (FileExist(directoryPath)) {
            return ; The directory already exists, or the given directory path is an existin file.
        }

        SplitPath(directoryPath, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt, &OutDrive)
        if (OutExtension != "") {
            return ; The given path is a file, not a directory.
        }

        DirCreate(directoryPath)
    }
}