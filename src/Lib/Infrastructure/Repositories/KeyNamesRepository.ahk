#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Util\JsonParsing\JXON>
#Include <Shared\Logger>

class KeyNamesRepository {

    keyNames := Array()
    pathToKeyNames := ""
    Logger := Logger.getInstance()

    __New(pathToKeyNames := FilePaths.GetPathToKeyNames()) {
        this.pathToKeyNames := pathToKeyNames
        this.keyNames := this.readKeyNamesFromFile()
    }

    getKeyNames() {
        return this.keyNames
    }

    readKeyNamesFromFile() {
        if (!FileExist(this.pathToKeyNames)) {
            this.Logger.logError("Key names file does not exist at: " . this.pathToKeyNames)
            throw Error("Key names file does not exist at: " . this.pathToKeyNames)
        }

        fileObjectOfKeyNames := FileOpen(this.pathToKeyNames, "rw", "UTF-8")

        keyNames := this.ReadKeyNamesFromTextFileObject(fileObjectOfKeyNames)

        if (keyNames.Length == 0) {
            Logger.logError("No key names found in the file: " . this.pathToKeyNames)
            throw Error("No key names found in the file: " . this.pathToKeyNames)
        }

        return keyNames
    }

    ReadKeyNamesFromTextFileObject(fileObj) {

        if (Type(fileObj) != "File") {
            throw Error("Invalid file object provided to ReadKeyNamesFromTextFileObject")
        }

        keyNames := Array()

        keyNamesStream := fileObj.Read()
        keyNamesSplitted := StrSplit(keyNamesStream, "`n")
        loop keyNamesSplitted.Length {
            keyName := keyNamesSplitted[A_index]
            if (keyName != "") {
                keyNames.Push(keyName)
            }
        }

        return keyNames
    }
}
