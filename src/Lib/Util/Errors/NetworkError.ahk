#Requires AutoHotkey v2.0

class NetworkError extends Error {
    
    __New(message := "Network error occurred. Please check your internet connection.", What:=A_ThisFunc) {
        super.__New(message, What)
    }
}