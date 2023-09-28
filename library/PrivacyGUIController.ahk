#Requires Autohotkey v2.0
#Include "./CountdownGUI_newV2.ahk"

Class PrivacyGUIController{

    GUIPrivacyBox := ""
    minutes := 3
    seconds := 3
    GUICountdown := CountdownGUI(3,3)

    ; __New(){

    ; }

    CreateGui(){
        this.GUIPrivacyBox := Gui()
        this.GUIPrivacyBox.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
        this.GUIPrivacyBox.BackColor := "Black"
    }

    DestroyGui(){
        this.GUIPrivacyBox.Destroy()
        this.GUICountdown.stopCountdown()
        this.GUICountdown.destroyGui()
    }

    HideGui(){
        this.GUIPrivacyBox.Hide()
        this.GUICountdown.stopCountdown()
        this.GUICountdown.destroyGui()
    }

    ChangeCountdown(minutes, seconds){
        this.minutes := minutes
        this.seconds := seconds
    }
    ; Covers the entire screen with a gui.
    ; Includes a countown to when screen turns off
    HideScreen(){
        this.GUIPrivacyBox.Show("x0 y0 w" . A_ScreenWidth . " h" . A_ScreenHeight . " NoActivate")
        this.GUICountdown.setCountdown(this.minutes, this.seconds)
        this.GUICountdown.createGui()
        this.GUICountdown.showGui()
        this.GUICountdown.startCountdown()
    }
    ; Hides the active window
    HideWindow(){
        this.GUICountdown.stopCountdown()
        this.GUICountdown.destroyGui()
        WinGetPos(&X, &Y, &Width, &Height, "A")
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        this.GUIPrivacyBox.Show("x" . X . " y" . Y . " w" . guiWidth . " h" . guiHeight . " NoActivate")
    }
    ; Hides the tabs of vscode or the current search engine
    HideTabs(){
        this.GUICountdown.stopCountdown()
        this.GUICountdown.destroyGui()
        Title := WinGetTitle("A")
        WinGetPos(&X, &Y, &Width, &Height, "A")
        if (InStr(Title, "Google Chrome") || InStr(Title, "Mozilla Firefox") || InStr(Title, "Edge")){
            guiWidth := Width*0.55
            this.GUIPrivacyBox.Show("x" . X . " y" . Y . " w" . guiWidth . " h40 NoActivate")
        }
        else if (InStr(Title, "Visual Studio")){
            guiX := X+60
            guiY := Y+45
            guiWidth := Width*0.66
            this.GUIPrivacyBox.Show("x" . guiX . " y" . guiY . " w" . guiWidth . " h40 NoActivate")
        }
    }
}