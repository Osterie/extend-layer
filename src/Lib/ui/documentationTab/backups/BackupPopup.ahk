#Requires AutoHotkey v2.0

#Include <ui\util\Section>

#Include <ui\documentationTab\DocumentationPopup>

class BackupPopup extends DocumentationPopup {

    __New(){
        super.__New("Update")

        this.createBackupPopup()
        this.show()
    }

    createBackupPopup() {
        this.SetFont("s16 Bold")
        this.Add("Text", "0x800000", "Backup Documentation Page")
        this.SetFont("s10")


        NEW_LINE := "`n"

        text := "WHERE IS?" . NEW_LINE
        text .= "Going to the 'Documentation and Backups' tab will display a button called 'View Backups' which when clicked will display a list of your backups and buttons for creating, deleting and restoring a backup. [IMAGE] (above or below this text, i think above."
        text .= NEW_LINE . NEW_LINE
        
        text .= "MANAGING" . NEW_LINE
        text .= "Clicking the Create backup button will create a backup of the application as is. It will include the source code of the version you are currently using, so that you may resotre this version in the future if a backup breaks something or you are unhappy with a newer version. The backup will also include a copy of you user profiles as they are when you created the backup, however restoring the user profiles as they were is optional. If you wish to delete a backup you can select the desired backup and click the 'Delete Backup' button. You will be prompted for a confirmation and this action cannot be undone."
        text .= NEW_LINE . NEW_LINE
        
        text .= "RESTORING A BACKUP" . NEW_LINE
        text .= "When restoring a backup, you must select the backup you wish to restore to from the list of backups, and click the 'Restore Backup' button. This will open a dialog where you must choose if you want to restore just the version, or if you also want to restore to how your user profiles were at the time of that backup."
        text .= NEW_LINE
        text .= "The 'Restore backup, but keep current profiles' will revert to the previous version of Extend Layer, but will keep your profiles as they are now (before you revert). This may cause issues."
        text .= NEW_LINE 
        text .= "The 'Restore backup, including backup's profiles' button will revert to the previous version of Extend Layer and replace your current user profiles with the user profiles of the backup. If you want to keep these user profiles you should export them."

        text .= NEW_LINE . NEW_LINE
        text .= "NOTE! When restoring a backup, make sure the size seems to be a reasonable number, if you have multiple backups, you can compare with another backup if the sizes are similiar."

        ; this.Add("Edit", "xp yp+30 h325 w625", text)
        ; this.Add("Edit", "xp yp+600 h325 w625", text)


        ; this.Add("Edit", "xp yp+30 h300 w625", "")

        Section(this, "Where is", "Going to the 'Documentation and Backups' tab will display a button called 'View Backups' which when clicked will display a list of your backups and buttons for creating, deleting and restoring a backup. [IMAGE] (above or below this text, i think above.", "w400")
        
        Section(this, "Managing", "Going to the 'Clicking the Create backup button will create a backup of the application as is. It will include the source code of the version you are currently using, so that you may resotre this version in the future if a backup breaks something or you are unhappy with a newer version. The backup will also include a copy of you user profiles as they are when you created the backup, however restoring the user profiles as they were is optional. If you wish to delete a backup you can select the desired backup and click the 'Delete Backup' button. You will be prompted for a confirmation and this action cannot be undone.", "w400")
        
        Section(this, "Restoring a backup", "When restoring a backup, you must select the backup you wish to restore to from the list of backups, and click the 'Restore Backup' button. This will open a dialog where you must choose if you want to restore just the version, or if you also want to restore to how your user profiles were at the time of that backup. The 'Restore backup, but keep current profiles' will revert to the previous version of Extend Layer, but will keep your profiles as they are now (before you revert). This may cause issues. The 'Restore backup, including backup's profiles' button will revert to the previous version of Extend Layer and replace your current user profiles with the user profiles of the backup. If you want to keep these user profiles you should export them. \n NOTE! When restoring a backup, make sure the size seems to be a reasonable number, if you have multiple backups, you can compare with another backup if the sizes are similiar. ", "w400")

        

        ; this.Add("Text", "xm ym w400 h20 Center", "Backup Documentation Page")
        ; this.Add("Text", "xm+10 ym+30 w380 h200", "This is where the backup documentation content will go.")

    }
}