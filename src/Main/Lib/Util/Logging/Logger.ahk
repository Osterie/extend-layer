#Requires AutoHotkey v2.0

#Include <Util\MetaInfo\MetaInfoStorage\FoldersAndFiles\FilePaths\FilePaths>

class Logger {
    static instance := false

    logDir := FilePaths.GetPathToLogs()
    logFile := this.logDir . "/error.log"

    __New() {
        this.checkAndCreateLogDir()
    }

    static getInstance() {
        if !Logger.instance
            Logger.instance := Logger()
        return Logger.instance
    }

    ; Optional: log info
    logInfo(msg) {
        msg := this.constructTimestampedMessage(msg, "INFO")
        this.writeToLog(msg)
    }

    logError(msg, file := "", line := "") {
        errorMessage := this.constructErrorMessage(msg, file, line)
        this.writeToLog(errorMessage)
    }

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
        this.checkAndCreateLogDir()
        this.ensureLogFileSize()
        FileAppend(msg "`n", this.logFile)
    }

    ; Check if the log directory exists, if not, creates it
    checkAndCreateLogDir() {
        if !DirExist(this.logDir) {
            DirCreate(this.logDir)
        }
    }

    ; Ensure the log file does not exceed a certain size (5MB)
    ; If it does, delete the file
    ensureLogFileSize() {
        currentSize := FileGetSize(this.logFile, "M")
        if (currentSize > 5) { ; 5MB
            FileDelete(this.logFile)
        }
    }
}
