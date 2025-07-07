#Requires AutoHotkey v2.0

; A super class for all actions.
class HotkeyAction {

    destroy() {
        className := Type(this)
        throw Error("Class: " . className .
            " HotkeyAction: destroy() method not implemented. Please implement it in the subclass.")
    }
}
