#Requires AutoHotkey v2.0

class UrlUtils {
    
    ; Checks if the given string is a valid URL.
    static isUrl(url) {
        isUrl := false

        startOfText := SubStr(url, 1, 8)
        if (startOfText = "https://") {
            isUrl := true
        }
        else if (startOfText = "http://") {
            isUrl := true
        }

        return isUrl
    }
}