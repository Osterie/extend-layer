#Requires AutoHotkey v2.0

; TODO move out of AppControllers folder
class SoundController extends HotkeyAction {

    destroy() {
        ; This method is called when the object is destroyed.
        ; This method is required to be implemented in the subclass of HotkeyAction.
    }

    playPause() {
        Send("{Media_Play_Pause}")
    }

    next() {
        Send("{Media_Next}")
    }

    previous() {
        Send("{Media_Prev}")
    }
}
