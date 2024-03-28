#Requires Autohotkey v2.0
#Include "..\Clock\CountdownDisplay.ahk"


#Include <Actions\Action>

Class ScreenPrivacyController extends Action{

    ; TODO, perhaps this could be combined with monitor.ahk, or something similar with a different name?
    GUIPrivacyBox := ""
    minutes := 3
    seconds := 0
    GUICountdown := CountdownDisplay(3,0)

    CreateGui(){
        this.GUIPrivacyBox := Gui()
        this.GUIPrivacyBox.Opt("-Caption +AlwaysOnTop +Owner +LastFound")
        this.GUIPrivacyBox.BackColor := "Black"
    }

    Destroy(){
        this.GUIPrivacyBox.Destroy()
        this.GUICountdown.StopCountdown()
        this.GUICountdown.Destroy()
    }

    Hide(){
        this.GUIPrivacyBox.Hide()
        
        try{
            this.GUICountdown.StopCountdown()
            this.GUICountdown.Destroy()
        }
    }

    ChangeCountdown(minutes, seconds){
        this.minutes := minutes
        this.seconds := seconds
        this.GUICountdown.SetCountdown(this.minutes, this.seconds)
    }
    ; Covers the entire screen with a gui.
    ; Includes a countown to when screen turns off
    ; TODO: should have the timer on the same gui, not a different one, creates bug if the screen hider part is clicked.
    HideScreen(){
        this.GUIPrivacyBox.Show("x0 y0 w" . A_ScreenWidth . " h" . A_ScreenHeight . " NoActivate")
        
        ; this.GUICountdown.SetCountdown(this.minutes, this.seconds)
        this.GUICountdown.CreateGui()
        this.GUICountdown.Show()
        this.GUICountdown.StartCountdown()
    }
    ; Hides the active window
    HideWindow(){
        try{
            this.GUICountdown.StopCountdown()
            this.GUICountdown.Destroy()
        }

        WinGetPos(&X, &Y, &Width, &Height, "A")
        guiWidth := Width*0.7
        guiHeight := Height*0.7
        this.GUIPrivacyBox.Show("x" . X . " y" . Y . " w" . guiWidth . " h" . guiHeight . " NoActivate")
    }
    ; Hides the tabs of vscode or the current search engine
    HideTabs(){
        try{
            this.GUICountdown.StopCountdown()
            this.GUICountdown.Destroy()
        }
        ; TODO make this work for more browsers 
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