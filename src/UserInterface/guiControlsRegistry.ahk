#Requires AutoHotkey v2.0

class guiControlsRegistry{

    Controls := ""

    __New(){
        this.Controls := Map()
    }

    addControl(controlName, control){
        this.Controls[controlName] := control
    }

    getControl(controlName){
        return this.Controls[controlName]
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

    setValuesFalse(){
        for controlName, control in this.Controls{
            control.Value := false
        }
    }

    setValuesTrue(){
        for controlName, control in this.Controls{
            control.Value := true
        }
    }

    disableControls(){
        for controlName, control in this.Controls{
            control.Enabled := false
        }
    }

    enableControls(){
        for controlName, control in this.Controls{
            control.Enabled := true
        }
    }


}