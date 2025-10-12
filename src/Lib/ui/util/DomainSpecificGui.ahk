#Requires AutoHotkey v2.0

#Include <Shared\Logger>

#Include <ui\util\GuiColorsChanger>

#Include <Infrastructure\Repositories\ThemesRepository>

; TODO on focus, change color of text and control, so that tab navigation is easiers...
class DomainSpecificGui extends Gui{

    ThemesRepository := ThemesRepository.getInstance()
    theme := ""

    Logger := Logger.getInstance()

    __New(options := "", title := "", eventObj := this){
        super.__New(options, title, eventObj)
        this.OnEvent('Escape', (*) => this.destroy())
        this.UpdateColorTheme()
        this.SetFont("s8", "Verdana")
    }

    UpdateColorTheme(){
        this.theme := this.ThemesRepository.getCurrentTheme()
        ; this.BackColor := this.theme.BackgroundColor()
        this.BackColor := this.theme.ControlColor()
        this.SetCaptionColor()
        this.SetCurrentThemeFontColor()
        this.UpdateControlsColors()
    }

    SetCurrentThemeFontColor(){
        this.SetFont("c" . this.theme.TextColor() .  " Bold")
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
        try{
            GuiColorsChanger.setControlTextColor(control, this.theme.TextColor())
        }
        catch ValueError as e{
            ; the control does not support setting text color
        }
        catch Error as e{
            this.Logger.logError("Failed to set control color: " e.Message)
            throw e
        }
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
}
