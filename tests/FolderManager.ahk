#Requires AutoHotkey v2.0

class FolderManager{

    ; A map of folders with folder name as key and folder path as value
    Folders := ""

    __New(){
        this.Folders := Map()
    }

    addFolder(folderName, folderPath) {
        folderAdded := false
        if (this.isInRegistry(folderName)) {
            folderAdded := false
        }
        else{
            this.folders[folderName] := folderPath
            folderAdded := true
        }
        return folderAdded
    }

    renameFolder(oldName, newName) {

        folderChanged := false



        if (this.isInRegistry(newName)) {
            folderChanged := false
        }
        else{
            if (this.isInRegistry(oldName)) {
                oldPath := this.folders[oldName]
                newPath := this.getNewPath(oldPath, oldName, newName)

                DirMove oldPath, newPath, "R"

                this.folders[newName] := this.folders[oldName]
                this.folders.Delete(oldName)
                folderChanged := true
            }
            else{
                folderChanged := false
            }
        }
        return folderChanged
    }

    deleteFolder(folderName) {
        folderDeleted := false
        if (this.isInRegistry(folderName)) {
            this.folders.Delete(folderName)
            folderDeleted := true
        }
        else{
            folderDeleted := false
        }
        return folderDeleted
    }

    getfolderPathByName(folderName) {
        return this.folders[folderName]
    }

    getfolderNames() {
        folderNames := []
        for key in this.folders {
            folderNames.Push(key)
        }
        return folderNames
    }

    ; Returns true if the given folder is already in the registry
    isInRegistry(folderName){
        return this.folders.Has(folderName)
    }

    getNewPath(oldPath, oldName, newName){

        lastPositionFoundOfOldNameInOldPath := InStr(oldPath, oldName,,-1, -1)
        ; The absolute path to the folder of the currently open file.
        pathWithoutOldOrNewName := SubStr(oldPath, 1, lastPositionFoundOfOldNameInOldPath-1)
        pathWithNewName := pathWithoutOldOrNewName . newName
        return pathWithNewName

    }
}