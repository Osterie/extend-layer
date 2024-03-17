#Requires AutoHotkey v2.0

#Include <UserInterface\Main\util\GuiControlsRegistry>

; TODO Simple and advanced should inherit from someone.
class SimpleHotkeyCraftingControl{


    GuiToAddTo := ""
    controlsForSimpleHotkeys := ""

    __New(GuiToAddTo, position, originalHotkey){
        this.controlsForSimpleHotkeys := guiControlsRegistry()
        this.GuiToAddTo := GuiToAddTo
        ; msgbox(originalHotkey)

        simpleHotkeyCraftingBox := this.GuiToAddTo.Add("GroupBox", "Section " . position, "Simple hotkey crafting:")
        hotkeyDynamicInput := this.GuiToAddTo.Add("Hotkey", "w250 h20 xs+10 ys+20") ;yp sets the control's position to the left of the previous one...
        hotkeyDynamicInput.Value := originalHotkey
        ; hotkeyDynamicInput.OnEvent("Change", (*) => this.updateSaveButtonStatus(hotkeyDynamicInput.Value))

        this.controlsForSimpleHotkeys.addControl("simpleHotkeyCraftingBox", simpleHotkeyCraftingBox)
        this.controlsForSimpleHotkeys.addControl("HotkeyDynamicInput", hotkeyDynamicInput)
    }

    Show(){
        this.controlsForSimpleHotkeys.showControls()
    }

    Hide(){
        this.controlsForSimpleHotkeys.hideControls()
    }

    GetKey(){
        return this.controlsForSimpleHotkeys.getControl("HotkeyDynamicInput").Value
    }
}