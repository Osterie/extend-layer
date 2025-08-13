#Requires AutoHotkey v2.0

class FilePathUtils {
    
    ; Converts a relative path to an absolute path.
    ; Uses the current script working directory to resolve the absolute path. 
    convertToAbsolutePath(path) {
        cc := DllCall("GetFullPathNameW", "str", path, "uint", 0, "ptr", 0, "ptr", 0, "uint")
        buf := Buffer(cc*2)
        DllCall("GetFullPathNameW", "str", path, "uint", cc, "ptr", buf, "ptr", 0, "uint")
        return StrGet(buf)
    }
}