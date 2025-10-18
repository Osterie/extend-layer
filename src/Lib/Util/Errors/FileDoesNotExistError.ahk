#Requires AutoHotkey v2.0

class FileDoesNotExistError extends Error {

    __New(filePath, errorMessage := "File does not exist at: " What:=A_ThisFunc) {
        message := errorMessage . filePath
        super.__New(message, What)
    }
}