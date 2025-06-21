#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <Updater\UpdaterRunner>

#Include <Shared\Logger>

class ExtendLayerInProtectedLocationDialog extends DomainSpecificGui {

    Logger := Logger.getInstance()

    __New() {
        super.__New("+Resize +MinSize300x280", "Extend Layer in Protected Location Dialog")
        this.createMain()
    }

    createMain() {
        this.SetFont("s10",)
        this.createRecommendationInfo()
        this.createCloseButton()
        this.createChooseAnotherLocationButton()
        this.createSolutionsInfo()
        this.createRunAsAdminButton()
    }

    createRecommendationInfo() {
        currentLocation := StrReplace(A_ScriptDir, "\src\Main")
        this.SetFont("s14 w700",)
        this.Add("Text", "cBlue", "Extend-layer is placed inside a protected directory, such as Program Files.")

        this.SetFont("s10 w400",)
        this.Add("Text", , "Extend-layer is placed inside a protected directory, such as Program Files. `n"
            . "Please move the script to a different directory, such as your Documents folder, or the Desktop, and run it from there. `n"
            . "Current location: " . currentLocation
        )
    }

    createSolutionsInfo() {
        this.Add("Text", , "NOT RECOMMENDED: `n"
            . "If you want to run the script from Program Files, you need to run the script as administrator. `n"
            . "Click the button below to run the script as administrator. `n"
            . "Alternatively, right-click on the script and select 'Run as administrator'. "
        )
    }

    createCloseButton() {
        buttonToClose := this.Add("Button", "Default w160 xm", "I Will Move Extend Layer Myself")
        buttonToClose.onEvent("Click", (*) => this.doLetUserMoveExtendLayer())
    }

    createChooseAnotherLocationButton() {
        buttonToChooseAnotherLocation := this.Add("Button", "Default w160 xm",
            "Choose Another Location For Extend Layer"
        )
        buttonToChooseAnotherLocation.onEvent("Click", (*) => this.doChooseAnotherLocation())
    }

    createRunAsAdminButton() {
        buttonToRunAsAdmin := this.Add("Button", "Default w160 xm", "Run Extend Layer as Admin")
        buttonToRunAsAdmin.onEvent("Click", (*) => this.doRunAsAdmin())
    }

    doLetUserMoveExtendLayer() {
        ExitApp
    }

    doRunAsAdmin() {
        try {
            Run('*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"')
            ExitApp
        }
        catch Error as e {
            this.Logger.logError("Failed to run Extend Layer as admin: " e.Message, e.File, e.Line)
            MsgBox("Failed to run Extend Layer as administrator.")
        }
    }

    doChooseAnotherLocation() {

        selectedFolder := this.chooseFolder()
        if (selectedFolder = "") {
            return
        }

        copyDestination := selectedFolder . "\extend-layer"

        if (!this.createNewFolderLocation(copyDestination)) {
            return
        }

        try {
            ; Copy Extend Layer to the selected folder
            this.copyExtendLayerToSelectedLocation(copyDestination)
            ExitApp
        }
        catch Error as e {
            this.Logger.logError("Failed to copy Extend Layer: " e.Message, e.File, e.Line)
            MsgBox("Failed to copy Extend Layer to the selected location.")
        }
    }

    ; Opens a folder selection dialog starting in "This PC" and returns the selected folder path.
    ; If the user cancels the dialog or does not select a folder, it returns an empty string.
    chooseFolder() {
        ; Allows the user to select a folder in This PC
        selectedFolder := DirSelect("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")
        if (selectedFolder = "") {
            MsgBox ("You didn't select a folder.")
            return ""
        }

        confirmation := MsgBox("Are you sure you want to copy Extend Layer to " selectedFolder " ?", "Confirm Copy", "YesNo")
        if (confirmation != "Yes") {
            return ""
        }
        return selectedFolder
    }

    ; Creates a new folder at the specified location if it does not already exist.
    createNewFolderLocation(newFolderLocation) {
        if (FileExist(newFolderLocation)) {
            return true ; The directory already exists, no need to create it
        }
        
        newFolderLocationExists := false
        try {
            DirCreate(newFolderLocation) ; Create the directory if it doesn't exist
            newFolderLocationExists := true
        }
        catch Error as e {
            this.Logger.logError("Failed to create directory: " e.Message, e.File, e.Line)
            if (InStr(e.Message, "Access is denied")) {
                MsgBox("You do not have permission to create a directory in the selected location. Please choose a different location.")
            } 
            else {
                MsgBox("Failed to create the directory for Extend Layer: " e.Message)
            }
        }

        return newFolderLocationExists
    }

    copyExtendLayerToSelectedLocation(pathToNewLocation) {
        pathToCurrentLocation := FilePaths.GetAbsolutePathToRoot()

        UpdaterRunner_ := UpdaterRunner()
        UpdaterRunner_.execute(pathToCurrentLocation, pathToNewLocation)
    }
}
