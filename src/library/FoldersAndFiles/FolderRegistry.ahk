#Requires AutoHotkey v2.0

Class FolderRegistry{

    ; A map of folders with folder name as key and folder path as value
    Folders := ""

    __New(){
        this.Folders := Map()
    }

    addSubFoldersFromFolder(folderPath){
        Loop Files folderPath . "\*", "D"{
            subFolderName := A_LoopFileName
            this.addFolder(subFolderName, folderPath . "\" . subFolderName)
        }
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

    ; Takes the old name of the folder and gives it the new name, this will change the folder name in the registry and on the disk
    ; Renames a folder and returns true if the folder was renamed successfully
    ; RenameFolder(oldName, newName) {

    ;     folderChanged := false
    ;     if (this.isInRegistry(newName)) {
    ;         folderChanged := false
    ;     }
    ;     else{

    ;         if (this.isInRegistry(oldName)) {

    ;             oldPath := this.folders[oldName]
    ;             newPath := this.getNewPath(oldPath, oldName, newName)
                
    ;             try{
    ;                 DirMove oldPath, newPath, "R"
    ;                 this.folders[newName] := newPath
    ;                 this.folders.Delete(oldName)
    ;                 folderChanged := true
    ;             }
    ;             catch{
    ;                 folderChanged := false
    ;             }
    ;         }
    ;         else{
    ;             folderChanged := false
    ;         }
    ;     }
    ;     return folderChanged
    ; }

    DeleteFolder(folderName) {
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

    getMostRecentlyAddedFolder() {
        lastKey := ""
        For key in this.folders{
            lastKey := key
        }

        return lastKey
    }

    getFolderPathByName(folderName) {
        return this.folders[folderName]
    }

    getFolderNames() {
        folderNames := []
        for key in this.folders {
            folderNames.Push(key)
        }
        return folderNames
    }

    getFirstFoundFolderIndex(folderName){
        foundIndex := -1
        indexFound := false
        for key in this.folders {
            if (key == folderName && !indexFound) {
                foundIndex := A_Index
                indexFound := true
            }
        }
        return foundIndex
    }

    ; Returns true if the given folder is already in the registry
    ; Private method
    isInRegistry(folderName){
        return this.folders.Has(folderName)
    }

    ; Private method
    getNewPath(oldPath, oldName, newName){

        lastPositionFoundOfOldNameInOldPath := InStr(oldPath, oldName,,-1, -1)
        ; The absolute path to the folder of the currently open file.
        pathWithoutOldOrNewName := SubStr(oldPath, 1, lastPositionFoundOfOldNameInOldPath-1)
        pathWithNewName := pathWithoutOldOrNewName . newName
        return pathWithNewName

    }
}