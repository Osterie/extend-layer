#Requires AutoHotkey v2.0

#Include <ui\util\GuiControlsRegistry>
#Include <ui\Util\DomainSpecificGui>
#Include <DataModels\KeyboardLayouts\HotkeyLayer\HotKeyInfo>

#Include ".\AdvancedHotkeyCraftingControl.ahk"
#Include ".\SimpleHotkeyCraftingControl.ahk"

class HotkeyCrafter extends DomainSpecificGui {

    controlsForButtons := ""
    advancedModeCheckBox := ""

    saveEventSubscribers := Array()
    controller := ""
    advancedHotkeyCrafter := ""

    __New(controller) {
        super.__New(, "HotkeyCrafterGui")

        this.controller := controller
        this.controlsForButtons := GuiControlsRegistry()
    }

    Create(originalHotkey := "", destinationKeyMode := false) {
        this.advancedModeCheckBox := this.Add("Checkbox", "xp yp+30", "Advanced Mode")
        this.advancedModeCheckBox.onEvent("Click", (*) => this.advancedModeButtonChangedEvent())

        this.SimpleHotkeyCrafter := SimpleHotkeyCraftingControl(this, "w300 h50", HotkeyFormatter.convertFromFriendlyName(
            originalHotkey, " + "))
        this.SimpleHotkeyCrafter.SubscribeToHotkeySelectedEvent(ObjBindMethod(this, "updateSaveButtonStatus"))

        this.advancedHotkeyCrafter := AdvancedHotkeyCraftingControl(this, "w370 h250 xp yp", this.controller.GetAvailableKeyNames(),
        destinationKeyMode)
        this.advancedHotkeyCrafter.SubscribeToHotkeySelectedEvent(ObjBindMethod(this, "updateSaveButtonStatus"))

        this.advancedHotkeyCrafter.hide()
    }

    ; This is usefol for example setting "Original hotkey: shift + a"  at the top of the window
    SetInformativeTopText(informativeText) {
        informativeTopText := this.Add("Text", "h20 x5 y5", informativeText)
    }

    createButtons() {
        saveButton := this.Add("Button", " w100 h20 xM+20 yp+50", "Save")
        saveButton.OnEvent("Click", (*) => this.NotifyListenersSave())

        cancelButton := this.Add("Button", "w100 h20", "Cancel")
        cancelButton.OnEvent("Click", (*) => this.destroy())

        this.controlsForButtons.addControl("saveButton", saveButton)
        this.controlsForButtons.addControl("cancelButton", cancelButton)

        this.updateSaveButtonStatus(this.SimpleHotkeyCrafter.getKey())
    }

    updateSaveButtonStatus(selectedHotkey) {
        try {
            if (selectedHotkey = "") {
                this.controlsForButtons.GetControl("saveButton").enabled := false
            }
            else {
                this.controlsForButtons.GetControl("saveButton").enabled := true
            }
        }
    }

    advancedModeButtonChangedEvent() {
        if (this.advancedModeCheckBox.Value = true) {
            this.advancedHotkeyCrafter.show()
            this.SimpleHotkeyCrafter.hide()
            this.updateSaveButtonStatus(this.advancedHotkeyCrafter.getKey())
        }
        else {
            this.advancedHotkeyCrafter.hide()
            this.updateSaveButtonStatus(this.SimpleHotkeyCrafter.getKey())
            this.SimpleHotkeyCrafter.show()
        }
    }

    getNewHotkey() {

        hotkeyToReturn := HotKeyInfo("")

        if (this.advancedModeCheckBox.Value = true) {
            hotkeyKey := this.advancedHotkeyCrafter.getKey()
            hotkeyModifiers := this.advancedHotkeyCrafter.getModifiers()
            hotkeyToReturn.setInfoForNormalHotKey(hotkeyKey, hotkeyModifiers)
        }
        else {
            hotkeyToReturn.setInfoForNormalHotKey(this.SimpleHotkeyCrafter.getKey())
        }
        return hotkeyToReturn
    }

    SubscribeToSaveEvent(action) {
        this.saveEventSubscribers.push(action)
    }

    NotifyListenersSave() {
        loop this.saveEventSubscribers.Length {
            this.saveEventSubscribers[A_Index](this.getNewHotkey())
        }
        this.destroy()
    }

    ShowHotkeyCrafterControls() {
        ; Super.show()
        ; this.Show()
        this.advancedModeCheckBox.Opt("Hidden0")
        if (this.advancedModeCheckBox.Value = true) {
            this.advancedHotkeyCrafter.show()
            this.SimpleHotkeyCrafter.Hide()
        }
        else {
            this.SimpleHotkeyCrafter.show()
            this.advancedHotkeyCrafter.hide()
        }
    }

    hide() {
        this.HideHotkeyCrafterControls()
        this.hideButtons()
    }

    hideButtons() {
        this.controlsForButtons.hide()
    }

    HideHotkeyCrafterControls() {
        this.SimpleHotkeyCrafter.hide()
        this.advancedHotkeyCrafter.hide()
        this.advancedModeCheckBox.Opt("Hidden1")
    }
}
