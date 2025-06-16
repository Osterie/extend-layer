#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <Util\Logging\Logger>
#Include <Util\Version>

#Include <Updater\UpdateChecker>
#Include <Updater\AutoUpdater>



class UpdateDialog extends DomainSpecificGui{

    UpdateChecker := UpdateChecker()
    Logger := Logger.getInstance()

    __New(){
        super.__New("+Resize +MinSize300x280", "Update Dialog")

        this.CreateMain()
    }

    CreateMain(){
        this.createInfo()
        this.createWarnings()
        this.createUpdateButton()
        ; this.createButtons()
        ; this.Show()
    }

    createInfo(){
        this.currentHotkeyTextControl := this.Add("Text",, "A new version of Extend Layer is available. `n" .
            "Current version: " . this.UpdateChecker.GetCurrentVersion() . "`n" .
            "Newest version: " . this.UpdateChecker.GetLatestVersionInfo() . "`n" .
            "Click the button below to update Extend Layer.")
    }

    createWarnings(){
        this.warningsTextControl := this.Add("Text",, "Warning: `n" .
            "1. The update process may take a few minutes. `n" .
            "2. If you have created your own autohotkey scripts, they will be deleted.`n")
    }

    createCurrentActionControl(){
        this.currentActionTextControl := this.Add("Text", " ", "Action: `n")
        this.updateActionText()
    }

    createUpdateButton(){
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
