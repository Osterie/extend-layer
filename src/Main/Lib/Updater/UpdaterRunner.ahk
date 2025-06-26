#Requires AutoHotkey v2.0

#Include <Shared\Logger>
#Include <Shared\FilePaths>

class UpdaterRunner {

    Logger := Logger.getInstance()

    ORIGINAL_UPDATER_LOCATION := A_ScriptDir "\Lib\Updater\Updater.ahk"
    TEMPORARY_UPDATER_LOCATION := A_Temp "\Updater.ahk"

    
    runUpdater(sourceDirectory, destinationDirectory, rerunMainScript := false, newVersion := "") {
        this.prepare()
        this.execute(sourceDirectory, destinationDirectory, rerunMainScript, newVersion)
    }

    prepare(){
        if (!FileExist(this.ORIGINAL_UPDATER_LOCATION)) {
            this.Logger.logError("Updater.ahk does not exist in the expected location: " this.ORIGINAL_UPDATER_LOCATION)
            throw Error("Updater.ahk does not exist in the expected location: " this.ORIGINAL_UPDATER_LOCATION)
        }

        hwnd := WinExist("Updater ahk_class AutoHotkey")

        processSuccessfullyClosed := true
        if hwnd {
            updaterPid := WinGetPID("ahk_id " hwnd)
            if (!closeProcess(updaterPid)) {
                this.Logger.logError("Failed to close Updater.ahk before copying.")
                throw Error("Failed to close Updater.ahk before copying.")
            } 
        }
        
        try {
            ; Delete the temporary updater if it exists, then copy the original updater to the temporary location
            if (FileExist(this.TEMPORARY_UPDATER_LOCATION)) {
                FileDelete(this.TEMPORARY_UPDATER_LOCATION)
            }
            FileCopy(this.ORIGINAL_UPDATER_LOCATION, this.TEMPORARY_UPDATER_LOCATION, true) ; true = overwrite if exists
        }
        catch Error as e {
            this.Logger.logError("Failed to copy Updater.ahk to temporary location: " e.Message, "AutoUpdater.ahk", A_LineNumber)
            throw Error("Failed to copy Updater.ahk to temporary location: " e.Message)
        }

        ; Confirm updater was copied successfully to the temporary location
        if !FileExist(this.TEMPORARY_UPDATER_LOCATION) {
            this.Logger.logError("Failed to copy Updater.ahk to temp directory.")
            throw Error("Failed to copy Updater.ahk to temp directory.")
        }
    }

    execute(sourceDirectory, destinationDirectory, rerunMainScript, newVersion) {

        if (!FileExist(this.TEMPORARY_UPDATER_LOCATION)) {
            this.Logger.logError("Failed to copy Updater.ahk to temp directory.")
            throw Error("Failed to copy Updater.ahk to temp directory.")
        }
        
        ; Command line arguments to pass to the updater executable
        pid := DllCall("GetCurrentProcessId", "UInt") ; PID of the currently running script, will be closed by the updated.
        
        
        version := newVersion ; New version to update to, if provided. For example "v0.4.6-alpha"
        ; TODO create FilePaths get methods.
        pathToVersionFile := FilePaths.GetAbsolutePathToRoot() . "config\Version.json" ; Path to the version file to update with the latest version information.
        pathToControlScript := FilePaths.GetAbsolutePathToRoot() . "src\controlScript.ahk" ; Path to the control script to restart after the update (only restarts if it is running).
        
        emptyArgument := ""
        if (newVersion = "") {
            version := emptyArgument
            pathToVersionFile := emptyArgument
        }
        
        mainScript := A_ScriptFullPath ; Path to the main script, which will be restarted by the updater.
        if (rerunMainScript = false){
            mainScript := emptyArgument ; If rerunMainScript is false, we do not pass the main script path to the updater.
        } 

        ; Build command-line arguments
        args := '"' sourceDirectory '" "' destinationDirectory '" "' pid '" "' mainScript '" "' version '" "' pathToVersionFile '" "' pathToControlScript '"'

        ; Run updater from temporary location with given argumetns
        Run '"' this.TEMPORARY_UPDATER_LOCATION '" ' args

        ; Exit the current script after running the updater, which is responsible for updating the current version.
        ExitApp
    }

}

; TODO move, but not to ProcessManager, because it is an action class.
closeProcess(process) {
    DetectHiddenWindows(true)
    tries := 0
    while (ProcessExist(process) && tries < 10) {
        pid := ProcessExist(process)
        if pid {
            ProcessClose(pid)
            Sleep 500 ; Wait for 0.5 seconds
            tries++
            if !ProcessExist(process) {
                return true
            }
        }
    }
    if !ProcessExist(process) {
        return true
    }
    return false
}