#Requires AutoHotkey v2.0

#Include ".\FolderRegistry.ahk"

class FolderManager{

    ; A map of folders with folder name as key and folder path as value
    Folders := ""

    __New(){
        this.Folders := FolderRegistry()
    }

    addSubFoldersToRegistryFromFolder(folderPath){
        this.Folders.addSubFoldersFromFolder(folderPath)
    }

    addFolderToRegistry(folderName, folderPath) {
        this.Folders.addFolder(folderName, folderPath)
    }

    RemoveFolderFromRegistry(folderName) {
        folderRemoved := false
        if (this.Folders.DeleteFolder(folderName)) {
            folderRemoved := true
        }
        else{
            folderRemoved := false
        }
        return folderRemoved
    }

    ; Takes the old name of the folder and gives it the new name, this will change the folder name in the registry and on the disk
    ; Renames a folder and returns true if the folder was renamed successfully
    RenameFolder(oldName, newName) {

        folderChanged := false
        if (this.FoldersisInRegistry(newName)) {
            folderChanged := false
        }
        else{

            if (this.Folders.isInRegistry(oldName)) {

                oldPath := this.folders[oldName]
                newPath := this.getNewPath(oldPath, oldName, newName)
                
                try{
                    DirMove oldPath, newPath, "R"
                    this.folders[newName] := newPath
                    this.folders.Delete(oldName)
                    folderChanged := true
                }
                catch{
                    folderChanged := false
                }
            }
            else{
                folderChanged := false
            }
        }
        return folderChanged
    }

    ; MoveFolder(){
        ; Todo implement
    ; }

    CopyFolderToNewLocation(fromFolderPath, toFolderPath, oldFolderName, newFolderName){
        
        copiedFolder := false
        
        if(this.Folders.isInRegistry(newFolderName)){
            copiedFolder := false
        }
        else{
            DirCopy(fromFolderPath, toFolderPath)
            this.addFolderToRegistry(newFolderName, toFolderPath)
            copiedFolder := true
        }
        
        return copiedFolder
    }

    DeleteFolder(folderName) {

        pathToFolderToBeDeleted := this.Folders.getFolderPathByName(folderName)

        if (this.RemoveFolderFromRegistry(folderName)) {
            DirDelete(pathToFolderToBeDeleted, true)
            folderDeleted := true
        }
        else{
            folderDeleted := false
        }

        return folderDeleted
    }

    getMostRecentlyAddedFolder() {
        return this.folders.getMostRecentlyAddedFolder()
    }

    getFolderPathByName(folderName) {
        return this.folders.getFolderPathByName(folderName)
    }

    getFolderNames() {
        return this.folders.getFolderNames()
    }

    getFirstFoundFolderIndex(folderName){
        return this.folders.getFirstFoundFolderIndex(folderName)
    }
}