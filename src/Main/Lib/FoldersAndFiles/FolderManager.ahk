#Requires AutoHotkey v2.0

#Include ".\FolderRegistry.ahk"

class FolderManager{

    ; A map of folders with folder name as key and folder path as value
    folders := ""

    __New(){
        this.folders := FolderRegistry()
    }

    addSubFoldersToRegistryFromFolder(folderPath){
        this.folders.addSubFoldersFromFolder(folderPath)
    }

    addFolderToRegistry(folderName, folderPath) {
        addedFolder := false
        if (this.folders.addFolder(folderName, folderPath)){
            addedFolder := true
        }
        else{
            addedFolder := false
        }
        return addedFolder
    }

    RemoveFolderFromRegistry(folderName) {
        folderRemoved := false
        if (this.folders.DeleteFolder(folderName)) {
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
        if (this.folders.isInRegistry(newName)) {
            folderChanged := false
        }
        else{

            if (this.folders.isInRegistry(oldName)) {

                oldPath := this.folders.getFolderPathByName(oldName)
                newPath := this.folders.getNewPath(oldPath, oldName, newName)
                
                try{
                    DirMove oldPath, newPath, "R"
                    this.folders.renameFolder(oldName, newName)
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
        
        if(this.folders.isInRegistry(newFolderName)){
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

        pathToFolderToBeDeleted := this.folders.getFolderPathByName(folderName)

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