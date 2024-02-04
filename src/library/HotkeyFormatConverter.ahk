#Requires AutoHotkey v2.0

class HotkeyFormatConverter{

    mapModifiersToFriendly := Map()


    static convertToFriendlyHotkeyName(hotkeyNameWithModifiers, delimiter := " + "){

        friendlyName := ""

        mapModifiersToFriendly := Map()
        mapModifiersToFriendly.Default := ""

        mapModifiersToFriendly["^"] := "Ctrl" . delimiter
        mapModifiersToFriendly["#"] := "Win" . delimiter
        mapModifiersToFriendly["!"] := "Alt" . delimiter
        mapModifiersToFriendly["+"] := "Shift" . delimiter
        mapModifiersToFriendly["<"] := "Left "
        mapModifiersToFriendly[">"] := "Right "
        mapModifiersToFriendly["&"] := "And "
        mapModifiersToFriendly["*"] := "Any" . delimiter
        


        index := 0
        stringLength := StrLen(hotkeyNameWithModifiers)
        Loop Parse hotkeyNameWithModifiers{
            index++
            if ( (mapModifiersToFriendly[A_LoopField] == "") or index == stringLength) {
                friendlyName .= A_LoopField
            }
            else{
                friendlyName .= mapModifiersToFriendly[A_LoopField]
            }
        }
        return friendlyName
    }

    static convertFromFriendlyName(friendlyHotkeyNameWithModifiers, delimiter := " + "){

        friendlyName := ""

        mapModifiersFromFriendly := Map()
        mapModifiersFromFriendly.Default := ""

        mapModifiersFromFriendly["Ctrl"] := "^"
        mapModifiersFromFriendly["Win"] := "#"
        mapModifiersFromFriendly["Alt"] := "!"
        mapModifiersFromFriendly["Shift"] := "+"
        mapModifiersFromFriendly["Left "] :=  "<"
        mapModifiersFromFriendly["Right "] :=  ">"
        mapModifiersFromFriendly["And "] :=  "&"
        mapModifiersFromFriendly["Any"] := "*"

        
        parsedHotkey := StrSplit(friendlyHotkeyNameWithModifiers, delimiter)
        stringLength := parsedHotkey.Length
        
        For index, modifierOrKey in parsedHotkey{

            if ( (mapModifiersFromFriendly[modifierOrKey] == "") or index == stringLength) {
                friendlyName .= modifierOrKey
            }
            else{
                friendlyName .= mapModifiersFromFriendly[modifierOrKey]
            }
        }
        return friendlyName

    }

}