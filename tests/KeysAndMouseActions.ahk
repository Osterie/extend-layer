#Requires AutoHotkey v2.0

class KeysAndMouseActions{

    actions := []

    __New(){

    }

    AddAction(KeysAndMouseAction){
        this.actions.push(KeysAndMouseAction)
    }

    GetActions(){
        return this.actions
    }

    GetActionsAsString(){
        actionsAsString := ""
        for action in this.actions{
            actionsAsString .= action.getToString() . "`n"
        }
        return actionsAsString
    }
}

