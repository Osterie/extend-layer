#Requires AutoHotkey v2.0

#Include <ui\Main\util\GuiControlsRegistry>

; TODO Simple and advanced should inherit from someone.
class SimpleHotkeyCraftingControl{


    GuiToAddTo := ""
    controlsForSimpleHotkeys := ""
    hotkeySavedEventSubscribers := ""

    __New(GuiToAddTo, position, originalHotkey){
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.GuiToAddTo := GuiToAddTo
        this.hotkeySavedEventSubscribers := Array()
        ; msgbox(originalHotkey)

        simpleHotkeyCraftingBox := this.GuiToAddTo.Add("GroupBox", "Section " . position, "Simple hotkey crafting:")
        hotkeyDynamicInput := this.GuiToAddTo.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        hotkeyDynamicInput.Value := originalHotkey
        hotkeyDynamicInput.OnEvent("Change", (*) => this.NotifyListenersHotkeyChanged())

        this.controlsForSimpleHotkeys.addControl("simpleHotkeyCraftingBox", simpleHotkeyCraftingBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", hotkeyDynamicInput)
    }

    SubscribeToHotkeySelectedEvent(event){
        this.hotkeySavedEventSubscribers.push(event)
    }

    NotifyListenersHotkeyChanged(){
        for event in this.hotkeySavedEventSubscribers{
            event(this.GetKey())
        }
    }

    Show(){
        this.controlsForSimpleHotkeys.show()
    }

    Hide(){
        this.controlsForSimpleHotkeys.hide()
    }

    GetKey(){
        return this.controlsForSimpleHotkeys.getControl("HotkeyDynamicInput").Value
    }
}