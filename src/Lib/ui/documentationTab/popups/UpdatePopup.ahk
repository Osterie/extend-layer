#Requires AutoHotkey v2.0

#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class UpdatePopup extends DocumentationPopup {

    __New(){
        title := "Update"
        header := "Update Documentation"
        super.__New(title, header)

        this.createUpdatePopup()
        this.show()
    }

    createUpdatePopup() {
        sectionWidth := this.getSectionWidth()

        beforeUpdatingTitle := "Before Updating"
        beforeUpdatingParagraph := "The update feature is still experimental, it is recommended to create a copy of Extend Layer and store this somewhere else before updating."
        
        userProfilesTitle := "User Profiles"
        userProfilesParagraph := "Updating will not affect your user profiles. This includes the Default profile. Sometimes an update will bring changes to the Default profile, and might add new and different Default profiles, but if you use the update feature you will not get these new profiles. You might want to check the repository on github, or the release notes, if there are any new profiles added with the update."
        userProfilesParagraph .= this.NEW_LINE
        userProfilesParagraph .= "NOTE! Since updating won't change your user profiles, your profiles might include out-dated actions after an update, which would result in an error when you try to use the hotkey for that action. You can probably fix this by recreating that hotkey-action."

        whereToFindTitle := "Where to Find Update Related Features"
        whereToFindParagraph := "When a new version of Extend Layer is released, you will be able to update. On the menu bar, to the right of 'Settings', there will appear a new menu option, '🔄Update available!'. This will only appear if the script is run after the update is released. If the script has been running a long while with no restarts, then you might not notice that a new update has been released, since it will not appear on the menu bar. There are however other ways to update. "
        whereToFindParagraph .= this.SPACING
        whereToFindParagraph .= "By going to the 'Updates and Backups' tab you can click the '🔄 Check for Updates'. If a new update is available, this will open the update dialog. Clicking 'Update Extend Layer' will run the updater and you will update to the latest released version. When the update is finished, the script will start on its own again. If you were running the control script, this will also run again."

        releaseNotesTitle := "Release notes"
        releaseNotesParagraph .= "Clicking the '📃 View Release Notes' button will show a list of all the release versions for each Extend. Selecting one of the items will show the release notes for that version."

        backupsTitle := "Backups and Temporary Backups"
        backupsParagraph .= "Updating will automatically create a backup. Incase this does not work and you wish to revert to a backup, updating also creates a temporary backup. Temporary backups can be found in 'C:\Users\<USERNAME>\AppData\Local\Temp\EL\B\'."

        this.section(beforeUpdatingTitle, beforeUpdatingParagraph)
        this.section(userProfilesTitle, userProfilesParagraph)
        
        this.section(whereToFindTitle, whereToFindParagraph)
        this.image(DocumentationImages.UPDATE_AVAILABLE, "h-1 w" . sectionWidth)
        this.image(DocumentationImages.UPDATE_POPUP, "h-1 w" . sectionWidth)
        
        this.section(releaseNotesTitle, releaseNotesParagraph)
        this.image(DocumentationImages.RELEASE_NOTES, "h-1 w" . sectionWidth)
        
        this.section(backupsTitle, backupsParagraph)
    }
}