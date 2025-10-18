#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>
#Include <Shared\MetaInfo>

; TODO inheritance importer and exporter?
; TODO move out of ui folder.

class ProfileExporter{

    ; TODO remove the reliance on this...
    __New(ExistingProfilesManager){
        this.ExistingProfilesManager := ExistingProfilesManager
    }

    exportProfile(){
        selectedFilePath := FileSelect("DS", , "Choose a location to save profile",)
        if selectedFilePath = "" {
            ; User cancelled
            return
        }
        try{
            profileName := MetaInfo.getCurrentProfile()
            profilePath := this.ExistingProfilesManager.getFolderPathByName(profileName)
            DirCopy(profilePath, selectedFilePath . "\" . profileName)
        }
        catch Error as e{
            MsgBox("Failed to export profile, perhaps because a folder of that name already exists in " . selectedFilePath)
        }
    }
}