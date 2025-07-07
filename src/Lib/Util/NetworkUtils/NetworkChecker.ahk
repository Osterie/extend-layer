#Requires AutoHotkey v2.0

class NetworkChecker {

    ; Checks if there is an internet connection by trying to access a known URL (Google).
    ; Returns true if the connection is successful, false otherwise.
    static isConnectedToInternet() {
        try {
            http := ComObject("WinHttp.WinHttpRequest.5.1")
            http.Open("GET", "http://www.google.com", false)
            http.Send()
            return http.Status = 200
        }
        catch {
            return false
        }
    }
}
