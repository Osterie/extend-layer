#Requires AutoHotkey v2.0

; TODO move out of AppControllers folder
class SoundController extends HotkeyAction{

    playPause(){
        Send("{Media_Play_Pause}")
    }

    next(){
        Send("{Media_Next}")
    }

    previous(){
        Send("{Media_Prev}")
    }
}