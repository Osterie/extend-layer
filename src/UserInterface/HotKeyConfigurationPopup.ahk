#Requires AutoHotkey v2.0


#Include ".\HotkeyCrafterGui.ahk"
#Include "..\library\HotkeyFormatConverter.ahk"

class HotKeyConfigurationPopup{

    mainGui := ""

    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""
    currentHotkeyTextElement := ""

    hotkeyElement := ""
    originalHotkey := ""
    currentHotkeyCommand := ""

    saveButton := ""

    undoDeletionButton := ""
    hotkeyDeleted := false

    

    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){

        this.originalHotkey := hotkeyCommand
        this.currentHotkeyCommand := hotkeyCommand

        this.mainGui := Gui()
        this.mainGui.opt("+Resize +MinSize600x560")
        
        this.currentHotkeyTextElement := this.mainGui.AddText(" ", "Hotkey: `n" . hotkeyCommand)
        this.setCurrentHotkeyText(hotkeyCommand)
        
        
        newActionText := this.mainGui.AddText(" ", "Action: `n" . hotkeyAction)
        newActionText.SetFont("s10", "Arial")
        this.SetTextAndResize(newActionText, "Action: `n" . hotkeyAction)

        this.undoDeletionButton := this.mainGui.AddButton("Default w80 ym", "Undo deletion")
        this.undoDeletionButton.onEvent("Click", (*) => this.undoDeletionButtonClickedEvent())
        this.undoDeletionButton.Opt("Hidden1")
        ; undoButton := this.mainGui.AddButton("Default w80", "Undo")  


        buttonToChangeOriginalHotkey := this.mainGui.AddButton("Default w80 xm", "Change original hotkey")
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.buttonToChangeOriginalHotkeyClickedEvent())
        
        
        buttonToChangeOriginalAction := this.mainGui.AddButton("Default w80", "Change original action")
        this.saveButton := this.mainGui.AddButton("Default w80", "Save+Done")
        
        
        ; currentHotkeyInfo := data.GetHotkey(hotkeyCommand)
        ; if (currentHotkeyInfo.hotkeyIsObject()){
        ;     this.CreateHotKeyMaker(this.mainGui)
        ;     this.createHotkeyMethodCall(this.mainGui, hotkeyAction)
        ; }
        ; else{

        ; }
        this.mainGui.Show()
    }


    buttonToChangeOriginalHotkeyClickedEvent(){
        this.mainGui.Hide()

        hotkeyCrafter := HotkeyCrafterGui(this.currentHotkeyCommand, "..\..\resources\keyNames\keyNames.txt")
        hotkeySavedEventAction := ObjBindMethod(this, "saveButtonClickedForHotkeyCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)

        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForHotkeyCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)

        hotkeyDeleteEventAction := ObjBindMethod(this, "deleteButtonClickedForHotkeyCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addDeleteButtonClickEventAction(hotkeyDeleteEventAction)


        hotkeyCrafter.Show()
    }

    addSaveButtonClickedEvent(event){
        this.saveButton.onEvent("Click", event)
    }

    undoDeletionButtonClickedEvent(){
        this.hotkeyDeleted := false
        this.undoDeletionButton.Opt("Hidden1")
        this.setCurrentHotkeyText(this.currentHotkeyCommand)
    }

    cancelButtonClickedForHotkeyCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    saveButtonClickedForHotkeyCrafterEvent(hotkeyCrafter, savedButton, idk){
        
        this.hotkeyDeleted := false
        this.undoDeletionButton.Opt("Hidden1")

        newHotkey := HotkeyFormatConverter.convertToFriendlyHotkeyName(hotkeyCrafter.getNewHotkey(), " + ")
        this.setCurrentHotkeyText(newHotkey)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()

    }

    deleteButtonClickedForHotkeyCrafterEvent(hotkeyCrafter, savedButton, idk){
        
        this.hotkeyDeleted := true
        this.undoDeletionButton.Opt("Hidden0")

        this.setCurrentHotkeyText(this.currentHotkeyCommand)
        
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    CreateHotKeyMaker(){
        manuallyCreateHotkeyCheckbox := this.mainGui.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        this.hotkeyElement := this.mainGui.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := this.mainGui.Add("Edit", "xm w300 h20", this.currentHotkeyCommand)
        this.manuallyCreatHotkeyElement.Opt("Hidden1")

        this.addWinKeyAsModifierElement := this.mainGui.Add("CheckBox",, "Add win key as modifier")

    }

    manuallyCreateHotkeyCheckboxClickEvent(checkbox){
        if (checkbox.Value == 1){
            ; on, manually create hotkey
            this.hotkeyElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Opt("Hidden0")
            if (this.addWinKeyAsModifierElement.Value == 1){
                this.manuallyCreatHotkeyElement.Value := "#"    
            }
            this.addWinKeyAsModifierElement.Opt("Hidden1")
            this.manuallyCreatHotkeyElement.Value .= this.hotkeyElement.Value


        }
        else{
            ; off create hotkey by pressing keys
            this.hotkeyElement.Opt("Hidden0")
            this.addWinKeyAsModifierElement.Opt("Hidden0")
            this.manuallyCreatHotkeyElement.Opt("Hidden1")

        }
    }

    setCurrentHotkeyText(newHotkey){
        this.currentHotkeyCommand := newHotkey
        this.currentHotkeyTextElement.Value := ("Hotkey: `n" . newHotkey)

        if (this.hotkeyDeleted = true){
            this.currentHotkeyTextElement.SetFont("s10 cRed")
        }
        else if (this.originalHotkey != newHotkey){
            this.currentHotkeyTextElement.SetFont("s10 cBlue")
        }
        else{
            this.currentHotkeyTextElement.SetFont("s10 cBlack")
        }

        this.SetTextAndResize(this.currentHotkeyTextElement, this.currentHotkeyTextElement.Value )
    }

    ; TODO creat a class for this...
    SetTextAndResize(textCtrl, text) {
        textCtrl.Move(,, GetTextSize(textCtrl, text)*)
        textCtrl.Value := text
        textCtrl.Gui.Show('AutoSize')
    
        GetTextSize(textCtrl, text) {
            static WM_GETFONT := 0x0031, DT_CALCRECT := 0x400
            hDC := DllCall('GetDC', 'Ptr', textCtrl.Hwnd, 'Ptr')
            hPrevObj := DllCall('SelectObject', 'Ptr', hDC, 'Ptr', SendMessage(WM_GETFONT,,, textCtrl), 'Ptr')
            height := DllCall('DrawText', 'Ptr', hDC, 'Str', text, 'Int', -1, 'Ptr', buf := Buffer(16), 'UInt', DT_CALCRECT)
            width := NumGet(buf, 8, 'Int') - NumGet(buf, 'Int')
            DllCall('SelectObject', 'Ptr', hDC, 'Ptr', hPrevObj, 'Ptr')
            DllCall('ReleaseDC', 'Ptr', textCtrl.Hwnd, 'Ptr', hDC)
            return [Round(width * 96/A_ScreenDPI), Round(height * 96/A_ScreenDPI)]
        }
    }

    getHotkey(){
        hotkeyToReturn := ""
        if (this.hotkeyDeleted != true){
            hotkeyToReturn := this.currentHotkeyCommand
        }

        return hotkeyToReturn
    }

    destroy(){
        this.mainGui.Destroy()
    }

    getHotkeyFormatted(){
        hotkeyToReturn := ""
        if (this.hotkeyDeleted != true){
            hotkeyToReturn := HotkeyFormatConverter.convertFromFriendlyName(this.currentHotkeyCommand)
        }
        else{
            hotkeyToReturn := ""
        }
        return hotkeyToReturn
    }
}
