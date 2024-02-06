#Requires AutoHotkey v2.0

class guiControlsRegistry{

    Controls := ""

    __New(){
        this.Controls := Map()
    }

    addControl(controlName, control){
        this.Controls[controlName] := control
    }

    removeControl(controlName){
        this.Controls.Remove(controlName)
    }

    hideControls(){
        for controlName, control in this.Controls{
            control.Opt("Hidden1")
        }
    }
    showControls(){
        for controlName, control in this.Controls{
            control.Opt("Hidden0")
        }
    }


}