#Requires AutoHotkey v2.0

#Include <ui\Main\Util\DomainSpecificGui>

#Include <Util\Logging\Logger>
#Include <Util\Version>

#Include <Updater\UpdateChecker>
#Include <Updater\AutoUpdater>

class ExtendLayerInProtectedLocationDialog extends DomainSpecificGui{

    Logger := Logger.getInstance()

    __New(){
        super.__New("+Resize +MinSize300x280", "Extend Layer in Protected Location Dialog")
        
        this.CreateMain()
    }
    
    CreateMain(){
        this.SetFont("s10", )
        this.createRecommendationInfo()
        this.createCloseButton()
        this.createChooseAnotherLocationButton()
        this.createSolutionsInfo()
        this.createRunAsAdminButton()
        ; this.createButtons()
        ; this.Show()
    }

    createRecommendationInfo(){
        currentLocation := StrReplace(A_ScriptDir, "\src\Main")
        this.SetFont("s14 w700", )
        this.Add("Text","cBlue", "Extend-layer is placed inside a protected directory, such as Program Files." 
        )

        this.SetFont("s10 w400", )
        this.Add("Text",, "Extend-layer is placed inside a protected directory, such as Program Files. `n" 
            . "Please move the script to a different directory, such as your Documents folder, or the Desktop, and run it from there. `n"
            . "Current location: " currentLocation
        )
    }

    createSolutionsInfo(){
        this.Add("Text",, "NOT RECOMMENDED: `n" 
            . "If you want to run the script from Program Files, you need to run the script as administrator. `n"
            . "Click the button below to run the script as administrator. `n"
            . "Alternatively, right-click on the script and select 'Run as administrator'. "
        )
    }

    createCloseButton(){
        buttonToClose := this.Add("Button", "Default w160 xm", "I Will Move Extend Layer Myself")
        buttonToClose.onEvent("Click", (*) => this.doLetUserMoveExtendLayer())
    }

    doLetUserMoveExtendLayer(){
        ExitApp
    }

    createChooseAnotherLocationButton(){
        buttonToChooseAnotherLocation := this.Add("Button", "Default w160 xm", "Choose Another Location For Extend Layer")
        buttonToChooseAnotherLocation.onEvent("Click", (*) => this.doChooseAnotherLocation())
    }

    createRunAsAdminButton(){
        buttonToRunAsAdmin := this.Add("Button", "Default w160 xm", "Run Extend Layer as Admin")
        buttonToRunAsAdmin.onEvent("Click", (*) => this.doRunAsAdmin())
    }

    doChooseAnotherLocation(){
     selectedFolder := DirSelect("::{20D04FE0-3AEA-1069-A2D8-08002B30309D}")

        ; selectedFolder := DirSelect(, 0, "Select a folder to run Extend Layer from")
        if selectedFolder = ""
            MsgBox "You didn't select a folder."
        else
            result := MsgBox("Are you sure you want to copy Extend Layer to " selectedFolder " ?" , "Confirm Copy", "YesNo")
            if (result = "Yes"){
                try{
                    ; Define original and temporary paths
                    originalUpdater := A_ScriptDir  "\Lib\Updater\Updater.exe"
                    tempUpdater := A_Temp "\Updater.exe"

                    try{
                        DetectHiddenWindows true

                        pid := ProcessExist("Updater.exe")
                        if pid {

                            ; Attempt to close the window gracefully
                            ProcessWaitClose("Updater.exe", 2000)

                            ; Check again after waiting
                            if ProcessExist("Updater.exe") {
                                throw Error("Updater did not close in time.")
                            }
                        } 

                        if (FileExist(tempUpdater)) {
                            FileDelete tempUpdater ; Delete the temporary updater if it exists
                        }

                        FileCopy originalUpdater, tempUpdater, true ; true = overwrite if exists
                    }
                    catch Error as e{
                        throw e
                    }

                    ; Build command-line arguments
                    mainScript := A_ScriptFullPath
                    currentVersion := Version.getInstance().GetCurrentVersion()

                    ; Confirm all critical files exist
                    if !FileExist(tempUpdater) {
                        this.Logger.logError("Failed to copy Updater.exe to temp directory.")
                        throw Error("Failed to copy Updater.exe to temp directory.")
                    }

                    ; Optional debug
                    ; MsgBox "Running updater from: " tempUpdater "`nWith arguments:`n" FilePaths.GetAbsolutePathToRoot() "`n" rootPath "`n" mainScript "`n" currentVersion

                    ; Run updater from temp and exit current app

                    newFolderLocationExists := false
                    pathToCurrentLocation := FilePaths.GetAbsolutePathToRoot()
                    selectedFolder := selectedFolder . "\extend-layer"
                    
                    
                    if (!FileExist(selectedFolder)) {
                        try{
                            DirCreate(selectedFolder) ; Create the directory if it doesn't exist
                            newFolderLocationExists := true
                        }
                        catch Error as e{
                            this.Logger.logError("Failed to create directory: " e.Message, e.File, e.Line)
                            if (InStr(e.Message, "Access is denied")) {
                                MsgBox("You do not have permission to create a directory in the selected location. Please choose a different location.")
                            } else {
                                MsgBox("Failed to create the directory for Extend Layer: " e.Message)
                            }
                        }
                    }
                    else{
                        newFolderLocationExists := true
                    }
                    
                    if (newFolderLocationExists){
                        emptyArgument := ""
                        Run '"' tempUpdater '" "' pathToCurrentLocation '" "' selectedFolder '" "' emptyArgument '" "' emptyArgument '" "' emptyArgument '" "' emptyArgument '"'
                        ExitApp
                        MsgBox("Extend Layer has been copied to " selectedFolder ". You can now run it from there.")
                    }

                }
                catch Error as e{
                    this.Logger.logError("Failed to copy Extend Layer: " e.Message, e.File, e.Line)
                    MsgBox("Failed to copy Extend Layer to the selected location.")
                }
            }
    }

    doRunAsAdmin(){
        ; TODO run as admin.
        try{
            ; Run("*RunAs `" . A_ScriptFullPath . "`")
            Run '*RunAs "' A_AhkPath '" /restart "' A_ScriptFullPath '"'
            ExitApp
        }
        catch Error as e{
            this.Logger.logError("Failed to run Extend Layer as admin: " e.Message, e.File, e.Line)
            MsgBox("Failed to run Extend Layer as administrator.")
        }
    }
}
