#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; Must be at least 2 argument, up to 7 arguments.
if (A_Args.Length < 2 || A_Args.Length > 7) {
    MsgBox "Update failed. This script should only be run with 2 to 7 arguments."
    ExitApp
}

; --- Set a visible window title for easier identification ---
DetectHiddenWindows(true)
WinSetTitle("Updater", "ahk_id " A_ScriptHwnd)

; Remove whitespace from all arguments
for index, arg in A_Args {
    A_Args[index] := Trim(arg)
}

sourceDir := A_Args[1] ; The source directory where the updated files are located. Required.
destinationDir := A_Args[2] ; The destination directory where the current version is stored. Required.
callerPid := A_Args.Length >= 3 ? A_Args[3] : "NONE" ; The PID of the caller process that should be waited for. Optional, but highly recommended.
mainScript := A_Args.Length >= 4 ? A_Args[4] : "NONE" ; The main script to restart after the update. Optional.
latestVersionInfo := A_Args.Length >= 5 ? A_Args[5] : "NONE" ; The latest version information to update in the version file. Optional.
pathToVersionFile := A_Args.Length >= 6 ? A_Args[6] : "NONE" ; The path to the version file to update with the latest version information. Optional.
pathToControlScript := A_Args.Length >= 7 ? A_Args[7] : "NONE" ; The path to the control script to restart after the update. Optional.

; Backup directory for the current version, which is created in the temp directory with a timestamp.

; Paths shortened to avoid too long file paths. 
; Full file path would be Temp\extend-layer\Backups\extend-layer-backup[TIMESTAMP].
backupDir := A_Temp . "\EL\B\ELB" . A_Now

if (!DirExist(A_Temp . "\EL")) {
    DirCreate(A_Temp . "\EL") ; Create the extend-layer directory in the temp directory if it does not exist.
}
if (!DirExist(A_Temp . "\EL\B")) {
    DirCreate(A_Temp . "\EL\B") ; Create the backups directory in the temp directory if it does not exist.
}

progressBarGui := Gui("-SysMenu", "Updating Extend Layer...")
progressBarGui.Show("w300 h80")

progressText := progressBarGui.Add("Text", "w280 h20", "")
progressBar := progressBarGui.Add("Progress", "w280 h40 cGreen")

step := 100 / 6

progressText.Value := "Validating arguments..."
progressBar.Value += step
; Check if the source and destination directories exist, and if main script exists, given that it is provided.
checkDirectoriesAndMainScript()

progressText.Value := "Closing main script..."
progressBar.Value += step
; Wait for the caller process to close, for up to 20 seconds.
ProcessWaitClose(callerPid, 20)

progressText.Value := "Creating backup of current version in temporary location..."
progressBar.Value += step
backupCurrentVersion()

progressText.Value := "Updating current version..."
progressBar.Value += step
; Updates the current version by copying files from the given updated source directory to the current destination directory (where extend-layer is stored).
updateCurrentVersion()

progressText.Value := "Updating version file..."
progressBar.Value += step
; Update the version file with the latest version information.
updateVersionFile()

progressText.Value := "Restarting mani script..."
progressBar.Value += step
; Restart the main script if it was provided
restartMainScript()

ExitApp

; TODO backup current version. If update fails, restore the backup.

; ---------------------------
; --------- Functions -------
; ---------------------------

; Check if the source and destination directories exist, and if main script exists, given that it is provided.
checkDirectoriesAndMainScript() {
    if !FileExist(sourceDir) {
        MsgBox "Update failed. ❌ Source directory does not exist: " sourceDir
        ExitApp
    }
    if !FileExist(destinationDir) {
        MsgBox "Update failed. ❌ Destination directory does not exist: " destinationDir
        ExitApp
    }
    if (mainScript != "NONE") {
        if (!FileExist(mainScript)) {
            MsgBox "Update failed. ❌ Main script does not exist: " mainScript
            ExitApp
        }
    }
}

backupCurrentVersion() {
    try {
        ; Createa a backup of the current version before updating.
        ; Backup is placed in windows temp directory with a timestamp.
        DirCopy(destinationDir, backupDir, true) ; true = overwrite
    } catch Error as err {
        MsgBox "❌ Failed to create backup of current version:`n" err.Message
        ExitApp
    }
}

restoreBackup() {
    try {
        ; Restore the backup of the current version.
        ; Backup is placed in windows temp directory with a timestamp.
        if !DirExist(backupDir) {
            MsgBox("❌ Backup directory does not exist: " backupDir)
            ExitApp
        }
        if (DirExist(destinationDir)) {
            DirDelete(destinationDir, true) ; true = recursive delete
        }
        DirCopy(backupDir, destinationDir, true) ; true = overwrite
        MsgBox("✅ Backup restored successfully from: " backupDir)
    } catch Error as err {
        MsgBox("❌ Failed to restore backup of current version:`n"
            . err.Message
            . err.Line
            . "`n You can find the backup at: " backupDir
        )
        ExitApp
    }
}

updateCurrentVersion() {
    try {

        hwnd := WinExist("ControlScript ahk_class AutoHotkey")

        controlScriptWasRunning := false
        if (hwnd != 0) {
            controlScriptPid := WinGetPID("ahk_id " hwnd)
            controlScriptWasRunning := ProcessExist(controlScriptPid) ? true : false
            if (!closeProcess(controlScriptPid)) {
                throw Error("controlScript did not close in time.")
            }
        }

        DirDelete(destinationDir, true) ; true = recursive delete

        DirCopy(sourceDir, destinationDir, true) ; true = overwrite

        ; Restart the control script if it was running
        if (controlScriptWasRunning) {
            restartControlScript()
        }
    }
    catch Error as err {
        MsgBox("❌ Update failed:`n"
            . err.Message
            . "`nLine: " err.Line
            . "`nFile: " err.File
            . "`nAttempting to restore backup..."
        )
        restoreBackup() ; Restore the backup if update fails
        ExitApp
    }
}

restartControlScript() {
    if (pathToControlScript == "NONE") {
        return ; No control script path provided, nothing to restart
    }
    try {
        Run pathToControlScript
    } catch Error as err {
        MsgBox "✅ Update applied, but failed to restart controlScript.ahk:`n" err.Message
    }
}

; Update the version file with the latest version information.
updateVersionFile() {
    if (latestVersionInfo = "NONE") {
        return ; No version info provided, nothing to update
    }

    try {
        jsonVersionObject := Map()
        jsonVersionObject["version"] := latestVersionInfo
        if (FileExist(pathToVersionFile)) {
            FileDelete(pathToVersionFile)
        }
        FileAppend(jxon_dump(jsonVersionObject), pathToVersionFile, "UTF-8")
    }
    catch Error as err {
        MsgBox "❌ Failed to update version information:`n" err.Message
        ExitApp
    }
}

; Restart the main script if it was provided
restartMainScript() {
    if (mainScript != "NONE") {
        try {
            Run mainScript
        } catch Error as err {
            MsgBox "✅ Update applied, but failed to restart main script:`n" err.Message
            ExitApp
        }
    }
}

; ---------------------------
; --------- Helpers ---------
; ---------------------------

; TODO move, to processmanager.ahk?
closeProcess(process) {
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

Jxon_Dump(obj, indent := "", lvl := 1) {
    if IsObject(obj) {
        if !(obj is Array || obj is Map || obj is String || obj is Number)
            throw Error("Object type not supported.", -1, Format("<Object at 0x{:p}>", ObjPtr(obj)))

        if IsInteger(indent) {
            if (indent < 0)
                throw Error("Indent parameter must be a postive integer.", -1, indent)
            spaces := indent, indent := ""

            loop spaces ; ===> changed
                indent .= " "
        }
        indt := ""

        loop indent ? lvl : 0
            indt .= indent

        is_array := (obj is Array)

        lvl += 1, out := "" ; Make #Warn happy
        for k, v in obj {
            if IsObject(k) || (k == "")
                throw Error("Invalid object key.", -1, k ? Format("<Object at 0x{:p}>", ObjPtr(obj)) : "<blank>")

            if !is_array ;// key ; ObjGetCapacity([k], 1)
                out .= (ObjGetCapacity([k]) ? Jxon_Dump(k) : escape_str(k)) (indent ? ": " : ":") ; token + padding

            out .= Jxon_Dump(v, indent, lvl) ; value
            . (indent ? ",`n" . indt : ",") ; token + indent
        }

        if (out != "") {
            out := Trim(out, ",`n" . indent)
            if (indent != "")
                out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent) + 1)
        }

        return is_array ? "[" . out . "]" : "{" . out . "}"

    } else if (obj is Number)
        return obj
    else ; String
        return escape_str(obj)

    escape_str(obj) {
        obj := StrReplace(obj, "\", "\\")
        obj := StrReplace(obj, "`t", "\t")
        obj := StrReplace(obj, "`r", "\r")
        obj := StrReplace(obj, "`n", "\n")
        obj := StrReplace(obj, "`b", "\b")
        obj := StrReplace(obj, "`f", "\f")
        obj := StrReplace(obj, "/", "\/")
        obj := StrReplace(obj, '"', '\"')

        return '"' obj '"'
    }
}
