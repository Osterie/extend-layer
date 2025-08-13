#Requires AutoHotkey v2.0

class UrlSanitizer {

    ; Sanitizes a URL by removing the protocol and "www" prefix.
    static sanitizeUrl(url) {
        url := StrReplace(url, "https://www", "")
        url := StrReplace(url, "http://www", "")
        url := StrReplace(url, "https://", "")
        url := StrReplace(url, "http://", "")
        return url
    }
}