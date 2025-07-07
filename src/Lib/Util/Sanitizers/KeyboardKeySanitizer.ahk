#Requires AutoHotkey v2.0

; TODO use more?

#Include <Infrastructure\Repositories\KeyNamesRepository>


class KeyboardKeySanitizer{

    static GetSanitizedKeyName(keyName){

        KeyNamesRepo := KeyNamesRepository()
        keyNames := KeyNamesRepo.getKeyNames()

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

    ; TODO move from here to somewhere else.
    static sanitizeUrl(url){
        url := StrReplace(url, "https://www", "")
        url := StrReplace(url, "http://www", "")
        url := StrReplace(url, "https://", "")
        url := StrReplace(url, "http://", "")
        return url
    }
}