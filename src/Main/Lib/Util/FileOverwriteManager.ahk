#Requires AutoHotkey v2.0

#Include <Util\UpdateManifestReader>
#Include <Util\Logging\Logger>

class FileOverwriteManager {

    Logger := Logger.getInstance()

    __New(){
        ; Empty constructor
    }

    copyIntoNewLocation(sourceBaseLocation, destinationBaseLocation, updateManifestPath){
        UpdateManifestReader_ := UpdateManifestReader(updateManifestPath)

        relativeWritePaths := UpdateManifestReader_.GetOverwritePaths()
        relativeSkipPaths := UpdateManifestReader_.GetSkipPaths()

        fullSkipPaths := Array()
        loop relativeSkipPaths.Length {
            fullSkipPaths.Push(sourceBaseLocation . "\" . relativeSkipPaths[A_Index])
        }

        this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeWritePaths, fullSkipPaths)
    }

    OverwriteFiles(sourceBaseLocation, destinationBaseLocation, relativeOverwritePaths, fullSkipPaths) {
        loop relativeOverwritePaths.Length {

            relativeOverwritePath := relativeOverwritePaths[A_Index]

            fullOverwritePath := this.ConstructPath(sourceBaseLocation, relativeOverwritePath)
            skippedPath := this.GetSkippedFile(fullOverwritePath, fullSkipPaths)

            ; There are no skipped files/directories in the current overwrite path.
            if (skippedPath == "") {

                ; Overwrite
                copyDestination := this.ConstructPath(destinationBaseLocation, relativeOverwritePath)

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

                if (!DirExist(destinationBaseLocation . "\" . relativeOverwritePath)) {
                    if (!FileExist(destinationBaseLocation . "\" . relativeOverwritePath)) {
                        ; this.Logger.logError("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePath)
                        ; throw Error("Cannot create directory because a file with the same name exists: " destinationBaseLocation . "\" . relativeOverwritePath)
                        DirCreate(destinationBaseLocation . "\" . relativeOverwritePath)
                    }
                    ; MsgBox(destinationBaseLocation . "\" . relativeOverwritePath)
                }
                ; Go deeper if possible, else go back.
                ; MsgBox("Going deeper: " fullOverwritePath . " GOING DEEPER: " this.GetFilesInDirectory(fullOverwritePath, relativeOverwritePath).Length)

                ; If the skippedPath is the same as the current overwritePath, then skip it.
                ; That means if it is a file, the file is skipped, if it is a directory, the directory is skipped.
                if (fullOverwritePath == skippedPath) {
                    ; MsgBox("Skipping path: " fullOverwritePath . " because the fil/directory is designated to be skipped.")
                }
                else { ; If only part of the path is present in the fullSkipPath, then we need to go deeper.
                    this.OverwriteFiles(sourceBaseLocation, destinationBaseLocation, this.GetFilesInDirectory(
                        fullOverwritePath, relativeOverwritePath), fullSkipPaths)
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