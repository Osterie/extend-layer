#Requires AutoHotkey v2.0

class SpotifyController extends Action{

    playPause(){
        Send("{Media_Play_Pause}")
        ; SpotifyController.sendCommand("playPause");
    }

    next(){
        Send("{Media_Next}")
        ; SpotifyController.sendCommand("next");
    }

    previous(){
        Send("{Media_Prev}")
        ; SpotifyController.sendCommand("previous");
    }
}