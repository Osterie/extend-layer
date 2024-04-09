#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiColorsChanger>

#Include <Util\MetaInfo\MetaInfoStorage\Themes\logic\Themes>



; TODO on focus, change color of text and control, so that tab navigation is easiers...
class DomainSpecificGui extends Gui{

    theme := ""

    ; TODO fetch color profile from meta file.
    __New(options := "", title := "", eventObj := ""){
        super.__New(options, title, this)



        this.OnEvent('Escape', (*) => this.Destroy())
        this.UpdateColorTheme()
    }

    GetCurrentTheme(){
        theme := Themes.getInstance().GetTheme(FilePaths.GetCurrentTheme())
        if (theme = ""){
            theme := Themes.getInstance().GetTheme(FilePaths.GetDefaultTheme())
            if (theme = ""){
                Throw Error("Failed to load any theme")
            }
        }
        return theme
    }

    UpdateColorTheme(){
        this.theme := this.GetCurrentTheme()
        this.BackColor := this.theme.BackgroundColor()
        this.SetCaptionColor()
        this.SetFont("c" . this.theme.TextColor() .  " Bold")
        this.UpdateControlsColors()
    }

    UpdateControlsColors(){
        for control in this{
            this.SetControlColor(control)
        }
    }
    
    SetCaptionColor(){
        GuiColorsChanger.DwmSetCaptionColor(this, "0x" this.theme.CaptionColor()) ; color is in RGB format
        GuiColorsChanger.DwmSetTextColor(this, "0x" . this.theme.CaptionFontColor())
    }

    SetControlColor(control){
        GuiColorsChanger.setControlColor(control, this.theme.ControlColor())
        GuiColorsChanger.setControlTextColor(control, this.theme.TextColor())
    }

    Add(ControlType , Options := "", Text := ""){
        guiControl := super.Add(ControlType, Options, Text)
        this.SetControlColor(guiControl)
        return guiControl
    }

    GetHwnd(){
        return this.Hwnd
    }

    SetOwner(ownerHwnd := ""){
        if (ownerHwnd != ""){
            this.opt("+Owner" . ownerHwnd)
        }
    }

    
    ; OnEvent(eventType, param1?, param2?, param3?) {
    ;     ; Check if a control is being added
    ;     msgbox(eventType)
    ;     if (eventType == "ControlAdded") {
    ;         ; Handle the control addition here
    ;         MsgBox "A control was added!"
    ;         ; You can access the control details via param1, param2, param3
    ;         ; For example, param1 contains the control's HWND
    ;     }
    ;     ; Call the base class's OnEvent method
    ;     parameters := Array()
    ;     if IsSet(param1){
    ;         parameters.push(param1)
    ;     }
    ;     if IsSet(param2){
    ;         parameters.push(param2)
    ;     }
    ;     if IsSet(param3){
    ;         parameters.push(param3)
    ;     }
    ;     super.OnEvent(eventType, parameters*)
    ; } 
}
