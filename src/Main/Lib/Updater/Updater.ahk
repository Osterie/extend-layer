#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; Only run in compiled mode, must be at least 2 argument, up to 6 arguments.
if !A_IsCompiled || A_Args.Length < 2 || A_Args.Length > 6 {
    MsgBox "Update failed. This script should only be run in compiled mode with 2 to 6 arguments."
    ExitApp
}

sourceDir := A_Args[1]
destinationDir := A_Args[2]
mainScript := A_Args.Length >= 3 ? A_Args[3] : ""
latestVersionInfo := A_Args.Length >= 4 ? A_Args[4] : ""
pathToVersionFile := A_Args.Length >= 5 ? A_Args[5] : ""
pathToControlScript := A_Args.Length >= 6 ? A_Args[6] : ""


if !FileExist(sourceDir) {
    MsgBox "Update failed. ❌ Source directory does not exist: " sourceDir
    ExitApp
}
if !FileExist(destinationDir) {
    MsgBox "Update failed. ❌ Destination directory does not exist: " destinationDir
    ExitApp
}
if (mainScript != ""){
    if !FileExist(mainScript) {
        MsgBox "Update failed. ❌ Main script does not exist: " mainScript
        ExitApp
    }
}


; Optional: wait to ensure the main script has exited
Sleep 2000

try {

    controlScriptWasRunning := ProcessExist("controlScript.exe") ? true : false
    if (!closeProcess("controlScript.exe")) {
        throw Error("controlScript did not close in time.")
    }

    ; DirCopy(sourceDir, destinationDir, true) ; true = overwrite

    if (controlScriptWasRunning) {
        ; Restart the control script if it was running
        if (pathToControlScript != ""){

            try{
                Run pathToControlScript
            }
            catch{
                MsgBox "❌ Failed to restart controlScript.exe"
                ; ExitApp
            }
        }
    }
} 
catch Error as err {
    MsgBox "❌ Update failed:`n" err.Message
    ExitApp
}

if (latestVersionInfo != "") {
    try{
        jsonVersionObject := Map()
        jsonVersionObject["version"] := latestVersionInfo
        if (FileExist(pathToVersionFile)){
            FileDelete(pathToVersionFile)
        }
        FileAppend(jxon_dump(jsonVersionObject), pathToVersionFile, "UTF-8")
    }
    catch Error  as err {
        MsgBox "❌ Failed to update version information:`n" err.Message
        ExitApp
    }
}

; Restart the main script if it was provided
if (mainScript != "") {
    try {
        Run mainScript
    } catch Error as err {
        MsgBox "✅ Update applied, but failed to restart main script:`n" err.Message
        ExitApp
    }
}

ExitApp

; TODO move, to processmanager.ahk?
closeProcess(process){
    tries := 0
    while (ProcessExist(process) && tries < 10) {
        pid := ProcessExist(process)
        if pid {
            ProcessWaitClose(pid, 2) ; Wait for 2 seconds
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

Jxon_Dump(obj, indent:="", lvl:=1) {
	if IsObject(obj) {
        If !(obj is Array || obj is Map || obj is String || obj is Number)
			throw Error("Object type not supported.", -1, Format("<Object at 0x{:p}>", ObjPtr(obj)))
		
		if IsInteger(indent)
		{
			if (indent < 0)
				throw Error("Indent parameter must be a postive integer.", -1, indent)
			spaces := indent, indent := ""
			
			Loop spaces ; ===> changed
				indent .= " "
		}
		indt := ""
		
		Loop indent ? lvl : 0
			indt .= indent
        
        is_array := (obj is Array)
        
		lvl += 1, out := "" ; Make #Warn happy
		for k, v in obj {
			if IsObject(k) || (k == "")
				throw Error("Invalid object key.", -1, k ? Format("<Object at 0x{:p}>", ObjPtr(obj)) : "<blank>")
			
			if !is_array ;// key ; ObjGetCapacity([k], 1)
				out .= (ObjGetCapacity([k]) ? Jxon_Dump(k) : escape_str(k)) (indent ? ": " : ":") ; token + padding
			
			out .= Jxon_Dump(v, indent, lvl) ; value
				.  ( indent ? ",`n" . indt : "," ) ; token + indent
		}

		if (out != "") {
			out := Trim(out, ",`n" . indent)
			if (indent != "")
				out := "`n" . indt . out . "`n" . SubStr(indt, StrLen(indent)+1)
		}
		
		return is_array ? "[" . out . "]" : "{" . out . "}"
	
    } Else If (obj is Number)
        return obj
    
    Else ; String
        return escape_str(obj)
	
    escape_str(obj) {
        obj := StrReplace(obj,"\","\\")
        obj := StrReplace(obj,"`t","\t")
        obj := StrReplace(obj,"`r","\r")
        obj := StrReplace(obj,"`n","\n")
        obj := StrReplace(obj,"`b","\b")
        obj := StrReplace(obj,"`f","\f")
        obj := StrReplace(obj,"/","\/")
        obj := StrReplace(obj,'"','\"')
        
        return '"' obj '"'
    }
}
