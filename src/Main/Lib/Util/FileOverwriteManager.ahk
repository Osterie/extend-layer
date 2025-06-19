#Requires AutoHotkey v2.0

#Include <Util\UpdateManifestReader>
#Include <Util\Logging\Logger>

class FileOverwriteManager {

    Logger := Logger.getInstance()

    __New(){
        ; Empty constructor
    }

    copyIntoNewLocation(sourceBaseLocation, destinationBaseLocation, updateManifestPath, removeOldFiles := true) {
        UpdateManifestReader_ := UpdateManifestReader(updateManifestPath)

        relativeWritePaths := UpdateManifestReader_.GetOverwritePaths()
        relativeSkipPaths := UpdateManifestReader_.GetSkipPaths()

        fullSkipPaths := Array()
        loop relativeSkipPaths.Length {
            fullSkipPaths.Push(sourceBaseLocation . "\" . relativeSkipPaths[A_Index])
        }

        this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeWritePaths, fullSkipPaths, removeOldFiles)
    }

    OverwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeOverwritePaths, fullSkipPaths, removeOldFiles) {
        loop relativeOverwritePaths.Length {

            relativeOverwritePath := relativeOverwritePaths[A_Index]

            fullOverwritePath := this.ConstructPath(sourceBaseLocation, relativeOverwritePath)
            skippedPath := this.GetSkippedFile(fullOverwritePath, fullSkipPaths)

            ; There are no skipped files/directories in the current overwrite path.
            if (skippedPath == "") {

                ; Overwrite
                copyDestination := this.ConstructPath(destinationBaseLocation, relativeOverwritePath)

                ; TODO is it fine to delete the directory if it exists and then copy the new one? 
                if (DirExist(fullOverwritePath)) {
                    if (removeOldFiles && DirExist(copyDestination)) {
                        DirDelete(copyDestination, true)
                    }
                    DirCopy(fullOverwritePath, copyDestination, true) ; true = overwrite
                }
                else if (FileExist(fullOverwritePath)) {
                    if (removeOldFiles && FileExist(copyDestination)) {
                        FileDelete(copyDestination)
                    }
                    FileCopy(fullOverwritePath, copyDestination, true) ; true = overwrite
                }
                else {
                    ; Skip, file or directory does not exist.
                    this.Logger.logInfo("File or directory does not exist: " fullOverwritePath)
                }

            }
            else {
                ; Skip, but we need to ensure the directory structure exists in the destination location.
                ; For example ".../src/Main/Lib/Directory" might not exist, so we need to create it if it does not exist.
                ; If not, we would get an error when trying to write to the file ".../src/Main/Lib/Directory/file.txt" because the directory does not exist.

                if (!DirExist(destinationBaseLocation . "\" . relativeOverwritePath)) {
                    if (!FileExist(destinationBaseLocation . "\" . relativeOverwritePath)) {
                        ; this.Logger.logError("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePath)
                        ; throw Error("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePath)
                        DirCreate(destinationBaseLocation . "\" . relativeOverwritePath)
                    }
                    ; MsgBox(destinationBaseLocation . "\" . relativeOverwritePath)
                }

                ; Go deeper if possible, else go back.

                ; If the skippedPath is the same as the current overwritePath, then skip it.
                ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
                if (fullOverwritePath == skippedPath) {
                    ; The current overwrite path is skipped, so we do not overwrite it.
                    this.Logger.logInfo("Skipping file or directory: " fullOverwritePath)
                }
                else {
                    ; Some files or directories in the current overwrite path are skipped, so we need to go deeper.
                    ; For example: overwritePath = "src\Main\Lib\Directory"
                    ; skipPaths = ["src\Main\Lib\Directory\file.txt", "src\Main\Lib\Directory\subdirectory"]
                    ; We need to go deeper into the "src\Main\Lib\Directory" directory and overwrite the files in it, but skip the files and directories that are in the skipPaths.
                    deeperOverwritePaths := this.GetFilesInDirectory(fullOverwritePath, relativeOverwritePath)
                    this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, deeperOverwritePaths, fullSkipPaths, removeOldFiles)
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
}