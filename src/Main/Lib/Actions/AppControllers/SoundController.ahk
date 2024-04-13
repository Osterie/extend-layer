#Requires AutoHotkey v2.0

; TODO move out of AppControllers folder
class SoundController extends Action{

    playPause(){
        Send("{Media_Play_Pause}")
        ; SoundController.sendCommand("playPause");
    }

    next(){
        Send("{Media_Next}")
        ; SoundController.sendCommand("next");
    }

    previous(){
        Send("{Media_Prev}")
        ; SoundController.sendCommand("previous");
    }
}