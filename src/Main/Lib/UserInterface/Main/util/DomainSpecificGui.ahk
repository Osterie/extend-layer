#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiColorsChanger>


class DomainSpecificGui extends Gui{

    __New(options := "", title := "", eventObj := ""){
        super.__New(options, title, this)
        this.OnEvent('Escape', (*) => this.Destroy())
        this.SetColors()
        this.SetFont("c6688FF Bold")
    }
    
    SetColors(){
        this.BackColor := "051336"

        ; Top bar or whatever it is called
        GuiColorsChanger.DwmSetCaptionColor(this, 0x300f45) ; color is in RGB format
        GuiColorsChanger.DwmSetTextColor(this, 0x27eaf1)
    }
    
    Add(ControlType , Options := "", Text := ""){
        GuiCtrl := super.Add(ControlType, Options, Text)

        controlColor := "060621"
        fontColor := "27eaf1"
        GuiColorsChanger.setControlColor(GuiCtrl, controlColor)
        GuiColorsChanger.setControlTextColor(GuiCtrl, fontColor)

        return GuiCtrl
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

    GetHwnd(){
        return this.Hwnd
    }

    SetOwner(ownerHwnd := ""){
        if (ownerHwnd != ""){
            this.opt("+Owner" . ownerHwnd)
        }
    }
}
