#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <Updater\UpdateChecker>
#Include <Updater\AutoUpdater>

#Include <Shared\Logger>

class UpdateDialog extends DomainSpecificGui{

    Logger := Logger.getInstance()

    __New(){
        super.__New("+Resize +MinSize300x180", "Update")
        this.createMain()
    }

    createMain(){
        if (!NetworkChecker.isConnectedToInternet()){
            this.createNoInternetWarning()
            ; No internet connection, cannot check for updates.
            return
        }
        this.createExperimentalFeatureWarning()
        this.createInfo()
        this.createWarnings()
        this.createUpdateButton()
    }

    createNoInternetWarning(){
        this.SetFont("s14 w700",)
        this.Add("Text", "xm", "No internet connection detected. `n" .
            "Please check your internet connection and try again.")
        this.SetFont("s10 w400",)
    }

    createExperimentalFeatureWarning(){
        this.SetFont("s14 w700",)

        this.Add("Text", "xm", 
            "Experimental Feature! `n" .
            "The updater is still experimental and may not always work as intended! `n" .
            "It is recommended to backup your Extend Layer profile(s) before proceeding with the update. `n" .
            "Please open an issue on github for any issues you encounter."
        )
        this.SetFont("s10 w400",)
    }

    createInfo(){
        UpdateChecker_ := UpdateChecker()
        this.Add("Text",, 
            "A new version of Extend Layer is available. `n" .
            "Current version: " . UpdateChecker_.getCurrentVersion() . "`n" .
            "Newest version: " . UpdateChecker_.getLatestVersionInfo()
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
        if (!NetworkChecker.isConnectedToInternet()){
            MsgBox("No internet connection detected. Please check your internet connection and try again.")
            return
        }
        try{
            autoUpdater_ := AutoUpdater()
            autoUpdater_.updateExtendLayer()
        }
        catch  NetworkError as e{
            this.Logger.logError("Network error occurred while updating: " e.message, e.file, e.line)
            MsgBox("Network error occurred while updating: " e.message)
            return
        }
        catch Error as e{
            this.Logger.logError("Update failed: " e.message, e.file, e.line)
            MsgBox("Update failed: " e.message)
            return
        }
    }
}
