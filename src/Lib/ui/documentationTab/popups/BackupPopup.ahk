#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class BackupPopup extends DocumentationPopup {

    __New(){
        title := "Backup"
        header := "Backup Documentation"
        super.__New(title, header)

        this.createBackupPopup()
        this.show()
    }

    createBackupPopup() {
        sectionWidth := this.getSectionWidth()

        findingFeaturesTitle := "Where to Find Backup Related Features"
        findingFeaturesParagraph := "Going to the 'Updates and Backups' tab will display a button called 'View Backups' which when clicked will display a list of your backups and buttons for creating, deleting and restoring a backup. See the image below for reference."

        managingTitle := "Managing"
        managingParagraph := "Clicking the 'Create Backup' button will create a backup of the application as is. It will include the source code of the version you are currently using, so that you may restore this version in the future if an update breaks something or you are unhappy with a newer version. The backup will also include a copy of you user profiles as they are when you created the backup, however restoring the user profiles as they were is optional."
        managingParagraph .= this.NEW_LINE
        managingParagraph .= "If you wish to delete a backup you can select the desired backup and click the 'Delete Backup' button. You will be prompted for a confirmation and this action cannot be undone."

        restoringBackupTitle := "Restoring a Backup"
        restoringBackupParagraph := "When restoring a backup, you must select the backup you wish to restore to from the list of backups and click the 'Restore Backup' button. This will open a dialog where you must choose if you want to restore just the version, or if you also want to restore to how your user profiles were at the time of that backup."
        restoringBackupParagraph .= this.NEW_LINE
        restoringBackupParagraph .= "The 'Restore backup, but keep current profiles' will revert to the previous version of Extend Layer, but will keep your profiles as they are now (before you revert). This may cause issues."
        restoringBackupParagraph .= this.NEW_LINE
        restoringBackupParagraph .= "The 'Restore backup, including backup's profiles' button will revert to the previous version of Extend Layer and replace your current user profiles with the user profiles of the backup. If you want to keep these user profiles you should export them."
        restoringBackupParagraph .= this.NEW_LINE . this.NEW_LINE
        ; restoringBackupParagraph .= "NOTE! When restoring a backup, make sure the backup size seems to be a reasonable number, if you have multiple backups, you can compare with another backup if the sizes are similiar. "
        ; restoringBackupParagraph .= this.NEW_LINE . this.NEW_LINE

        this.section(findingFeaturesTitle, findingFeaturesParagraph)
        this.image(DocumentationImages.MANAGING_BACKUPS, "w" . sectionWidth)

        this.section(managingTitle, managingParagraph)
        this.section(restoringBackupTitle, restoringBackupParagraph)
    }
}