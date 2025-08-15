#Requires AutoHotkey v2.0

#Include <Util\Formaters\PathFormatter>
#Include <Util\FilePathUtils>

; Model for a file path, which helps with the SplitPath functionality, using get methods for getting the different
; parts/attributes of a file path instead of using variable references.
class FilePath {

    FilePathUtils := FilePathUtils()
    PathFormatter := PathFormatter()

    path := ""  ; The absolute path to the file
    fileName := ""  ; The name of the file without extension
    directory := ""  ; The directory of the file
    extension := ""  ; The file extension
    baseName := ""  ; The file name without extension
    drive := ""  ; The drive of the file

    __New(path) {
        if (Type(path) != "String") {
            throw TypeError("Invalid argument: Expected String for path.")
        }
        path := this.PathFormatter.normalizePath(path)  ; Ensure the path is formatted correctly
        
        if (!FileExist(path)) {
            throw Error("File does not exist: " path)
        }

        this.path := this.FilePathUtils.convertToAbsolutePath(path)

        SplitPath(path, &OutFileName, &OutDir, &OutExtension, &OutNameNoExt, &OutDrive)

        this.fileName := OutNameNoExt
        this.directory := OutDir
        this.extension := OutExtension
        this.baseName := OutFileName
        this.drive := OutDrive
    }

    getPath() {
        return this.path
    }

    getDirectory() {
        return this.directory
    }

    getFileName() {
        return this.fileName
    }

    getExtension() {
        return this.extension
    }

    getBaseName() {
        return this.baseName
    }

    getDrive() {
        return this.drive
    }
}