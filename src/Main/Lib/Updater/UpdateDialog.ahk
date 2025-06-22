#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <Updater\UpdateChecker>
#Include <Updater\AutoUpdater>

#Include <Shared\Logger>

class UpdateDialog extends DomainSpecificGui{

    UpdateChecker := UpdateChecker()
    Logger := Logger.getInstance()

    __New(){
        super.__New("+Resize +MinSize300x180", "Update Dialog")
        this.createMain()
    }

    createMain(){
        this.createInfo()
        this.createWarnings()
        this.createUpdateButton()
    }

    createInfo(){
        this.Add("Text",, 
            "A new version of Extend Layer is available. `n" .
            "Current version: " . this.UpdateChecker.getCurrentVersion() . "`n" .
            "Newest version: " . this.UpdateChecker.getLatestVersionInfo()
        )
    }

    createWarnings(){
        this.Add("Text",, 
            "Warning: `n" .
            "1. The update process may take a few minutes. `n" .
            "2. If you have created your own autohotkey scripts, they will be deleted."
        )
    }

    createUpdateButton(){
        this.Add("Text",, 
            "Click the button below to update Extend Layer to the latest version. `n" .
            "The script will automatically restart after the update is complete."
        )
        buttonToChangeOriginalHotkey := this.Add("Button", "Default w150 xm", "Update Extend Layer")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.doUpdate())
    }

    doUpdate(){
        autoUpdater_ := AutoUpdater()
        try{
            autoUpdater_.checkForUpdates()
        }
        catch Error as e{
            this.Logger.logError("Update failed: " e.message, e.file, e.line)
            MsgBox("Update failed: " e.message)
            return
        }
    }
}
