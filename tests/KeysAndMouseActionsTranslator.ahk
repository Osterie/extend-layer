#Requires AutoHotkey v2.0

class KeysAndMouseActionsTranslator{


    actions := []
    times := []

    __New(){

    }

    TranslateFromActions(actionsWithTimes){
        this.actions := []
        this.times := []

        for actionWithTime in actionsWithTimes{
            action := actionWithTime.GetAction()
            time := actionWithTime.GetTime()
            this.actions.push(action)
            this.times.push(time)
        }
    }

    GetTranslatedActions(){
        return this.actions
    }

    GetTranslatedTimes(){
        return this.times
    }


    TranslateFromString(){
        ; TODO implement maybe, might be pretty shit to have.
    }
}