#Requires AutoHotkey v2.0

class KeysAndMouseActions{

    actionsWithTimes := []

    __New(){

    }

    AddAction(KeysAndMouseAction){
        this.actionsWithTimes.push(KeysAndMouseAction)
    }

    GetActionsWithTimes(){
        return this.actionsWithTimes
    }

    GetActions(){
        actions := []
        for action in this.actionsWithTimes{
            actions.push(action.action)
        }
        return actions
    }

    GetTimes(){
        times := []
        for action in this.actionsWithTimes{
            times.push(action.time)
        }
        return times
    }

    GetActionsAsString(){
        actionsAsString := ""
        for action in this.actionsWithTimes{
            actionsAsString .= action.getToString() . "`n"
        }
        return actionsAsString
    }
}

