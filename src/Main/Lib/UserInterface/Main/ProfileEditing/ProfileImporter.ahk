#Requires AutoHotkey v2.0

class ProfileImporter{

    __New(ExistingProfilesManager){
        this.ExistingProfilesManager := ExistingProfilesManager
    }

    importProfile(){
        selectedFilePath := FileSelect("D", , "Choose the profile to import",)
        ; Guard condition
        if selectedFilePath = ""{
            ; Canceled
            return
        }
        if (!this.profileIsValid(selectedFilePath)){
            msgbox("The folder you selected is not a valid profile. `n" . selectedFilePath)
            return
        }
        try{
            folderName := this.getEndOfPath(selectedFilePath)
            if (this.ExistingProfilesManager.CopyFolderToNewLocation(selectedFilePath, FilePaths.GetPathToProfiles() . "/" . folderName, folderName)){
                msgbox("Successfully imported profile " . folderName)
                ; this.view.UpdateProfilesDropDownMenu()
            }
            else{
                msgbox("Failed to import profile, perhaps a profile with the given name already exists. `n" . selectedFilePath)
            }
        }
        catch Error as e{
            MsgBox("Failed to import profile")
        }
    }

    getEndOfPath(path){
        parts := StrSplit(path, "\")
        return parts[parts.length]
    }

    profileIsValid(profilePath){
        validProfile := false
        filesToBeFound := 2
        amountOfFilesToLookFor := 2
        Loop Files (profilePath . "\*"){
            subFolderName := A_LoopFileName
            if (subFolderName = "Keyboards.json" || subFolderName = "ClassObjects.ini"){
                filesToBeFound--
            }
            amountOfFilesToLookFor -= 1
            if (amountOfFilesToLookFor = -1){
                break
            }
        }
        if (filesToBeFound = 0 && amountOfFilesToLookFor != -1){
            validProfile := true
        }
        else{
            validProfile := false
        }
        return validProfile
    }
}