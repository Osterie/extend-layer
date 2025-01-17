#Requires AutoHotkey v2.0

#Include <ui\Main\util\Menus\ImprovedMenu>

class SettingsMenu extends ImprovedMenu{

    closeScriptOnGuiCloseText := "Stop script on GUI close"

    __New(callback){
        this.callback := callback
        this.CreateMenuBar()
    }

    CreateMenuBar(){
        this.Add(this.closeScriptOnGuiCloseText, (clicked, *) => this.HandleCloseScriptOnGuiCloseClicked(clicked))
        this.CheckCurrentCloseScriptOnGuiCloseValue()
    }

    CheckCurrentCloseScriptOnGuiCloseValue(){
        closeScriptOnGuiCloseValue := FilePaths.GetCloseScriptOnGuiClose()
        if (closeScriptOnGuiCloseValue){
            this.Check(this.closeScriptOnGuiCloseText)
        }
        else{
            this.Uncheck(this.closeScriptOnGuiCloseText)
        }
    }

    HandleCloseScriptOnGuiCloseClicked(clicked){
        closeScript := !FilePaths.GetCloseScriptOnGuiClose()
        FilePaths.SetCloseScriptOnGuiClose(closeScript)
        this.CheckCurrentCloseScriptOnGuiCloseValue()

        if (closeScript){
            MsgBox("The script will now stop when the GUI is closed.")
        }
        else{
            MsgBox("The script will now continue running when the GUI is closed.")
        }

        this.callback()
    }
}