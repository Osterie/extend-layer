#Requires AutoHotkey v2.0

#Include <ui\util\components\Section>
#Include <ui\util\components\DocumentationImage>
#Include <Shared\DocumentationImages>

#Include <ui\documentationTab\popups\DocumentationPopup>

class ProfilePopup extends DocumentationPopup {

    __New(){
        title := "Profile"
        header := "Profile Documentation"
        super.__New(title, header)

        this.createProfilePopup()
        this.show()
    }

    createProfilePopup() {
        sectionWidth := this.getSectionWidth()

        findingFeaturesTitle := "Where to Find Profile Related Features"
        findingFeaturesParagraph := "The profle related features are located beneath the menu bar. You can change the current profile with the current profile dropdown. Edit your user profiles with the 'Edit profile' button. Add preset profiles with the 'Add profile' button. Import/Export profiles with the 'Import profile' and 'Export profile' button."

        userProfilesTitle := "User Profiles"
        userProfilesParagraph := "User profiles are the profiles you have created, or which are created for you. You can view the names of these profiles in the current profile dropdown. Selecting one of the profiles will use that profile as the current profile."
        
        presetProfilesTitle := "Preset Profiles"
        presetProfilesParagraph := "As the name implies, these profiles are presets. You can use a preset profile by adding it through the Add Profile dialog. Each preset profile has a description, which you can change to whatever you want. When adding a preset profile, you must give it a unique name. If a duplicate name is chosen, adding the profile will fail."
        presetProfilesParagraph .= this.NEW_LINE
        presetProfilesParagraph .= "You can view the preset profiles in the Add Profiles dialog."
        
        editingProfilesTitle := "Editing a Profile"
        editingProfilesParagraph := "After opening the Edit Profile dialog you can change different attributes of the profile, and delete it. After selecting the profile to edit by using the dropdown, you can change the name of the profile by clicking 'Change profile name', which opens a dialog where you must write the new name and confim the change. "
        editingProfilesParagraph .= this.NEW_LINE
        editingProfilesParagraph .= "Clicking the 'Delete profile' button will open a dialog where you must type 'yes' to confirm you want to delete the profile. Then it will be deleted."
        editingProfilesParagraph .= this.NEW_LINE
        editingProfilesParagraph .= "Clicking the 'Update description' button after editing the description in the input box, will update the description."
        
        addingProfilesTitle := "Adding a Profile"
        addingProfilesParagraph := "After opening the Add Profile dialog, select the preset profile you want to add, give it a unique name, optionally edit the description, then click 'Add profile'. If you have chosen a unique name, the new profile should be added as one of your user profiles."
        
        importingProfilesTitle := "Importing a Profile"
        importingProfilesParagraph := "Clicking 'Import profile' will open a file dialog. You must choose an exported user profile to import. The exported user profile will be a folder with two files inside it, a json file and a ini file, make sure you select the folder and not its contents. Only importing one profile at a time is supported."
        
        exportingProfilesTitle := "Exporting a Profile"
        exportingProfilesParagraph := "Clicking 'Export profile' will open a file dialog. You must choose the location where you want the profile to be exported. The name of the exported profile will automatically be the same as the name of the exported profile, for example 'Default'. Only one profile can be exported at a time (or you could go to the file location of Extend Layer and copy the user profiles from there). The exported profile can now be imported."

        Section(this, sectionWidth, findingFeaturesTitle, findingFeaturesParagraph)

        Section(this, sectionWidth, userProfilesTitle, userProfilesParagraph)
        DocumentationImage(this, DocumentationImages.USER_PROFILES)

        Section(this, sectionWidth, presetProfilesTitle, presetProfilesParagraph)
        DocumentationImage(this, DocumentationImages.PRESET_PROFILES)
        
        Section(this, sectionWidth, editingProfilesTitle, editingProfilesParagraph)
        DocumentationImage(this, DocumentationImages.EDITING_PROFILES)
        
        Section(this, sectionWidth, addingProfilesTitle, addingProfilesParagraph)
        DocumentationImage(this, DocumentationImages.ADDING_PROFILES)
        
        Section(this, sectionWidth, importingProfilesTitle, importingProfilesParagraph)
        Section(this, sectionWidth, exportingProfilesTitle, exportingProfilesParagraph)
    }
}