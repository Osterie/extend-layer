#Requires AutoHotkey v2.0

#Include <ui\UpdatesAndBackupsTab\ReleaseNotesGui>
#Include <ui\UpdatesAndBackupsTab\BackupsGui>

#Include <Updater\AutoUpdater>
#Include <Updater\UpdateDialog>

#Include <Util\NetworkUtils\NetworkChecker>

#Include <Infrastructure\Repositories\VersionRepository>

class UpdatesAndBackupsTab {
    guiToAddTo := ""

    __New(guiToAddTo) {
        this.guiToAddTo := guiToAddTo
    }

    createTab() {
        ; Add heading
        this.guiToAddTo.SetFont("w700")
        this.guiToAddTo.Add("Text", "Section", "🔧 Updates && Backups")
        this.guiToAddTo.SetFont("w400")
        
        ; Current Version
        VersionRepository_ := VersionRepository()
        this.guiToAddTo.Add("Text", "xs y+10", "Current Version:")
        this.guiToAddTo.Add("Text", "x+5 yp", VersionRepository_.getCurrentVersion())

        ; Check for Updates Button
        this.createCheckForUpdatesButton()

        ; Release Notes Button
        this.createReleaseNotesButton()

        ; Backups Button
        this.createBackupsButton()
    }

    createCheckForUpdatesButton() {
        button := this.guiToAddTo.Add("Button", "xs y+10 w200", "🔄 Check for &Updates")
        button.OnEvent("Click", (*) => this.checkForUpdates())
    }

    checkForUpdates() {
        if (!NetworkChecker.isConnectedToInternet()){
            MsgBox("No internet connection detected. Please check your internet connection and try again.")
            return
        }
        
        try{
            autoUpdater_ := AutoUpdater.getInstance()
            if (autoUpdater_.updateAvailable()) {
                this.HandleupdateAvailableClicked()
            }
            else{
                MsgBox("You are up-to-date! No updates available.")
            }
        }
        catch NetworkError as e{
            MsgBox("Network error occurred: " e.message)
        }
        catch Error as e{
            MsgBox("Failed to check for updates: " e.message)
        }
    }

    HandleupdateAvailableClicked(){
        try{
            UpdateDialog_ := UpdateDialog()
            UpdateDialog_.show()
        }
        catch NetworkError as e{
            MsgBox("Network error occurred while checking for updates: " e.message)
        }
        catch Error as e{
            MsgBox("An error occurred while checking for updates: " e.message)
        }
    }

    ; Release Notes Button
    createReleaseNotesButton() {
        button := this.guiToAddTo.Add("Button", "xs y+10 w200", "📃 View &Release Notes")
        button.OnEvent("Click", (*) => this.showReleaseNotes())
    }

    showReleaseNotes() {
        ReleaseNotesGui_ := ReleaseNotesGui()
        ReleaseNotesGui_.show()
    }

    createBackupsButton() {
        button := this.guiToAddTo.Add("Button", "xs y+10 w200", "📂 View &Backups")
        button.OnEvent("Click", (*) => this.showBackups())
    }

    showBackups() {
        BackupsGui_ := BackupsGui()
        BackupsGui_.show()
    }
}
