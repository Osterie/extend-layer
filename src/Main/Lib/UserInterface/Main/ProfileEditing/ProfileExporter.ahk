#Requires AutoHotkey v2.0

; TODO inheritance importer and exporter?
class ProfileExporter{

    __New(ExistingProfilesManager){
        this.ExistingProfilesManager := ExistingProfilesManager
    }

    exportProfile(){
        selectedFilePath := FileSelect("DS", , "Choose a location to save profile",)
        if selectedFilePath = ""{
            ; Canceled
        }
        else{
            
            try{
                profileName := FilePaths.GetCurrentProfile()
                profilePath := this.ExistingProfilesManager.getFolderPathByName(profileName)
                DirCopy(profilePath, selectedFilePath . "/" . profileName)
            }
            catch Error as e{
                MsgBox("Failed to export profile, perhaps because a folder of that name already exists in " . selectedFilePath)
            }
        }
    }
}