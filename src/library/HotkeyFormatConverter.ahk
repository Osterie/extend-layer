#Requires AutoHotkey v2.0

class HotkeyFormatConverter{

    static convertToFriendlyHotkeyName(hotkeyNameWithModifiers){

        tmpString := hotkeyNameWithModifiers

        friendlyName := ""

        possibleModifiers := Map()
        possibleModifiers["^"] := "Ctrl + "
        possibleModifiers["#"] := "Win + "
        possibleModifiers["!"] := "Alt + "
        possibleModifiers["+"] := "Shift + "
        possibleModifiers["<"] := "Left "
        possibleModifiers[">"] := "Right "
        possibleModifiers["&"] := "And "
        possibleModifiers["*"] := "Any + "

        possibleModifiers.Default := ""


        index := 0
        stringLength := StrLen(tmpString)
        Loop Parse tmpString{
            index++
            if ( (possibleModifiers[A_LoopField] == "") or index == stringLength) {
                friendlyName .= A_LoopField
            }
            else{
                friendlyName .= possibleModifiers[A_LoopField]
            }
        }
        return friendlyName
    }
}