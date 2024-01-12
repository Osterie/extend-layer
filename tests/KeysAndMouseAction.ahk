#Requires AutoHotkey v2.0

class KeysAndMouseAction{
    action := ""
    time := ""

    ; TODO should find some good way to validate parameters...

    __New(){
        this.action := ""
        this.time := ""
    }

    setAction(action){
        this.action := action
    }

    setTime(time){
        this.time := time
    }

    getAction(){
        return this.action
    }

    getTime(){
        return this.time
    }

    getToString(){
        return "Action: " . this.action . " Time: " . this.time
    }
}