#Requires AutoHotkey v2.0

#Include <Util\Formaters\HotkeyFormatter>

; TODO make this class is able to change hotkeys and actions
class HotkeyConfigurator {

    hotkeyToSendListenersInformation := ""

    originalHotkeyKey := ""
    originalActionFriendly := ""

    __New(hotkeyToSendListenersInformation) {
        this.hotkeyToSendListenersInformation := hotkeyToSendListenersInformation
        this.originalHotkeyKey := this.hotkeyToSendListenersInformation.getHotkeyName()
        this.originalActionFriendly := this.hotkeyToSendListenersInformation.toString()
    }

    ; TODO dont do this here... do it after save+done is clicked...!!
    SetHotkeyKey(newHotkey) {
        this.hotkeyToSendListenersInformation.changeHotkey(newHotkey)
    }

    SetHotkeyAction(newAction) {
        hotkeyKey := this.hotkeyToSendListenersInformation.getHotkeyName()
        this.hotkeyToSendListenersInformation := newAction
        this.hotkeyToSendListenersInformation.changeHotkey(hotkeyKey)
    }

    GetHotkeyInfo() {
        return this.hotkeyToSendListenersInformation
    }

    GetOriginalHotkey() {
        return this.originalHotkeyKey
    }

    GetOriginalAction() {
        return this.originalActionFriendly
    }

    GetHotkey() {
        return this.hotkeyToSendListenersInformation.getHotkeyName()
    }

    GetHotkeyFriendly() {
        return this.hotkeyToSendListenersInformation.getFriendlyHotkeyName()
    }

    GetAction() {
        return this.hotkeyToSendListenersInformation.toString()
    }

}
