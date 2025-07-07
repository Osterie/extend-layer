#Requires AutoHotkey v2.0

#Include <Shared\Logger>

; TODO use more.
class PathFormatter {

    Logger := Logger.getInstance()

    ; Formats an array of paths by normalizing each path.
    ; This includes removing trailing backslashes, replacing forward slashes with backslashes,
    ; and ensuring that double backslashes are replaced with single backslashes.
    ; Returns the formatted array of paths.
    formatPaths(paths) {
        loop paths.Length {
            paths[A_Index] := this.normalizePath(paths[A_Index])
        }
        return paths
    }

    ; Remove trailing backslashes (except for root like "C:\")
    ; Replace forward slashes with backslashes
    ; Replace double backslashes with single backslash
    normalizePath(path) {
        pathLengthBefore := StrLen(path)
        path := this.normalize(path)
        pathLengthAfter := StrLen(path)

        if (pathLengthAfter < pathLengthBefore) {
            this.Logger.logInfo("Normalized path: " . path)
        }
        return path
    }

    normalize(path) {
        if (InStr(path, "/")) {
            this.Logger.logInfo("Path contains forward slashes, normalizing: " . path)
        }
        if (InStr(path, "\\")) {
            this.Logger.logInfo("Path contains double backslashes, normalizing: " . path)
        }

        path := StrReplace(path, "/", "\") ; Replace forward slashes with backslashes
        path := StrReplace(path, "\\", "\") ; Replace double backslashes with single backslash

        while (StrLen(path) > 3 && SubStr(path, -1) == "\") {
            path := SubStr(path, 1, -1)
        }

        return path
    }
}
