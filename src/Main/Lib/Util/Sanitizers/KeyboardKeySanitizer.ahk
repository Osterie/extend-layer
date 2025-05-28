#Requires AutoHotkey v2.0

class KeyboardKeySanitizer{

    static GetSanitizedKeyName(keyName){
        keyNames := KeyNamesReader().ReadKeyNamesFromTextFileObject(FileOpen(FilePaths.GetPathToKeyNames(), "rw", "UTF-8")).GetKeyNames()
        if (keyNames.Has(keyName)){
            return keyName
        }
        else{
            return ""
        }
    }

    static IsValidKeyName(keyName){
        return this.GetSanitizedKeyName(keyName) != ""
    }

    static sanitizeUrl(url){
        url := StrReplace(url, "https://www", "")
        url := StrReplace(url, "http://www", "")
        url := StrReplace(url, "https://", "")
        url := StrReplace(url, "http://", "")
        return url
    }
}