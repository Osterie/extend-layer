#Requires AutoHotkey v2.0

#Include <Shared\FilePaths>

; Used to log errors and information to logger file.
; This class is a singleton, meaning only one instance can exist at a time, use the getInstance() method to retrieve it. instead of creating a new instance.
class Logger {
    static instance := false

    logDir := FilePaths.GetPathToLogs()
    logFile := this.logDir . "\error.log"

    __New() {
        ; Emtpy
    }

    ; Returns the singleton instance of Logger
    static getInstance() {
        if (Logger.instance = false){
            Logger.instance := Logger()
        }
        return Logger.instance
    }

    ; Logs an informational message to the log file with a timestamp.
    logInfo(msg) {
        msg := this.constructTimestampedMessage(msg, "INFO")
        this.writeToLog(msg)
    }

    logWarning(msg) {
        msg := this.constructTimestampedMessage(msg, "WARNING")
        this.writeToLog(msg)
    }

    ; Logs an error message to the log file with a timestamp and optional file and line information.
    logError(msg, file := "", line := "") {
        errorMessage := this.constructErrorMessage(msg, file, line)
        this.writeToLog(errorMessage)
    }

    ; --------------
    ; PRIATE METHODS
    ; --------------

    ; Constructs a timestamped message with the given type (default is "ERROR")
    constructTimestampedMessage(msg, type := "ERROR") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        return "[" timestamp "] [" type "] " msg
    }

    ; Constructs an error message with optional file and line information
    constructErrorMessage(msg, file := "", line := "") {
        errorMessage := this.constructTimestampedMessage(msg, "ERROR")
        if (file != ""){
            errorMessage .= " File: " file
        }
        if (line != ""){
            errorMessage .= ", Line: " line
        }
        return errorMessage
    }

    ; Write the message to the log file
    ; Checks if the log directory exists, creates it if not,
    ; and ensures the log file does not exceed a certain size
    writeToLog(msg) {
        this.ensureLogFileSize()
        FileAppend(msg "`n", this.logFile)
    }
    
    ; Check if the log directory exists, if not, creates it
    checkAndCreateLogDir() {
        if DirExist(this.logDir) {
            return
        }

        try{
            DirCreate(this.logDir)
            FileAppend("", this.logFile)
        }
        catch (Error as e) {
            if (InStr(e.Message, "Access is denied")){
                MsgBox("You do not have permission to create a log directory. Please move extend layer to a non-protected folder. Alternatively, but not recommended, run the script as an administrator.")
            }
        }
    }
    
    ; Ensure the log file does not exceed a certain size (5MB)
    ; If it does, delete the file
    ensureLogFileSize() {
        this.checkAndCreateLogDir()
        try{
            currentSize := FileGetSize(this.logFile, "M")
        } catch {
            currentSize := 0
            FileAppend("", this.logFile) ; Create the file if it doesn't exist
        }
        if (currentSize > 5) { ; 5MB
            FileDelete(this.logFile)
        }
    }
}
