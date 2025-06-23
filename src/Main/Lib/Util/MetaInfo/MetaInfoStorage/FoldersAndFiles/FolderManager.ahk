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

    ; Returns true if the folder was added successfully, false if the folder already exists
    addFolderToRegistry(folderName, folderPath) {
        return this.folders.addFolder(folderName, folderPath)
    }

    ; Return true if the folder was removed successfully, false if the folder does not exist
    RemoveFolderFromRegistry(folderName) {
        return this.folders.DeleteFolder(folderName)
    }

    ; Takes the old name of the folder and gives it the new name, this will change the folder name in the registry and on the disk
    ; Renames a folder and returns true if the folder was renamed successfully
    RenameFolder(oldName, newName) {

        folderChanged := false
        if (this.folders.hasFolder(newName)) {
            folderChanged := false
        }
        else{

            if (this.folders.hasFolder(oldName)) {

                oldPath := this.getFolderPathByName(oldName)
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

    CopyFolderToNewLocation(fromFolderPath, toFolderPath, newFolderName){
        
        copiedFolder := false
        
        if(this.folders.hasFolder(newFolderName)){
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

        folderDeleted := false
        
        if (this.folders.hasFolder(folderName)) {

            pathToFolderToBeDeleted := this.getFolderPathByName(folderName)

            try{
                if (this.RemoveFolderFromRegistry(folderName)) {
                    DirDelete(pathToFolderToBeDeleted, true)
                    folderDeleted := true
                }
                else{
                    folderDeleted := false
                }
            }
            catch{
                folderDeleted := false
            }
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

    hasFolder(folderName){
        return this.folders.hasFolder(folderName)
    }
}