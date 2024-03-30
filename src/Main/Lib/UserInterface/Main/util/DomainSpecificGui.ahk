#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiColorsChanger>
#Include <UserInterface\Main\util\Themes>


; TODO on focus, change color of text and control, so that tab navigation is easiers...
class DomainSpecificGui extends Gui{

    theme := ""

    ; TODO fetch color profile from meta file.
    __New(options := "", title := "", eventObj := ""){
        super.__New(options, title, this)

        this.theme := Themes.blueIsh()

        this.OnEvent('Escape', (*) => this.Destroy())
        this.BackColor := this.theme.BackgroundColor()
        this.SetColors()
        this.SetFont("c" . this.theme.TextColor() .  " Bold")
    }

    SetColorProfile(){

    }
    
    SetColors(){
        ; Top bar or whatever it is called
        GuiColorsChanger.DwmSetCaptionColor(this, "0x" this.theme.CaptionColor()) ; color is in RGB format
        ; TODO add color for this too
        GuiColorsChanger.DwmSetTextColor(this, "0x" . this.theme.TextColor())
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
