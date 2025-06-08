#Requires AutoHotkey v2.0
#SingleInstance Force
#NoTrayIcon

; Only run in compiled mode and with 5 arguments
if !A_IsCompiled || A_Args.Length != 5 {
    MsgBox "This script should only be run in compiled mode with 5 arguments."
    ExitApp
}

sourceDir     := A_Args[1]
destinationDir := A_Args[2]
mainScript     := A_Args[3]
latestVersionInfo := A_Args[4]
pathToVersionFile := A_Args[5]

if !FileExist(sourceDir) {
    MsgBox "❌ Source directory does not exist: " sourceDir
    ExitApp
}
if !FileExist(destinationDir) {
    MsgBox "❌ Destination directory does not exist: " destinationDir
    ExitApp
}
if !FileExist(mainScript) {
    MsgBox "❌ Main script does not exist: " mainScript
    ExitApp
}


; Optional: wait to ensure the main script has exited
Sleep 2000

try {
    DetectHiddenWindows("on")
    controlScriptIsRunning := false
    If WinExist("controlScript.exe"){
        controlScriptIsRunning := true
        WinWaitClose("controlScript.exe", "", 5000) ; Wait for it to close, timeout after 5 seconds
    }

    DirCopy(sourceDir, destinationDir, true) ; true = overwrite

    if (controlScriptIsRunning) {
        ; Restart the control script if it was running
        MsgBox(A_ScriptDir "\controlScript.exe" " will be restarted.")
        Run A_ScriptDir "\controlScript.exe"
    }
} 
catch Error as err {
    MsgBox "❌ Update failed:`n" err.Message
    ExitApp
}

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

; Restart the main script
try {
    Run mainScript
} catch Error as err {
    MsgBox "✅ Update applied, but failed to restart main script:`n" err.Message
}

ExitApp




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
