#Requires AutoHotkey v2.0


#Include ".\HotkeyCrafterGui.ahk"

class HotKeyConfigurationPopup{

    mainGui := ""

    hotkeyElement := ""
    hotkeyCommand := ""
    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""

    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){

        this.hotkeyCommand := hotkeyCommand

        this.mainGui := Gui()
        this.mainGui.opt("+Resize +MinSize600x560")
        
        ; this.mainGui.Add("Text", "w300 h20", "Original hotkey:") 
        originalHotkeyText := this.mainGui.AddText(" ", "Original hotkey: `n" . hotkeyCommand)
        newActionText := this.mainGui.AddText(" ", "Original action: `n" . hotkeyAction)


        originalHotkeyText.SetFont("s10", "Arial")
        newActionText.SetFont("s10", "Arial")

        this.SetTextAndResize(originalHotkeyText, "Original hotkey: `n" . hotkeyCommand )
        this.SetTextAndResize(newActionText, "Original action: `n" . hotkeyAction)


        ; revertButton := this.mainGui.AddButton("Default w80 ym", "Revert")
        ; undoButton := this.mainGui.AddButton("Default w80", "Undo")  


        buttonToChangeOriginalHotkey := this.mainGui.AddButton("Default w80", "Change original hotkey")
        buttonToChangeOriginalAction := this.mainGui.AddButton("Default w80", "Change original action")
        saveButton := this.mainGui.AddButton("Default w80", "Save+Done")

        
        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.buttonToChangeOriginalHotkeyClickedEvent(hotkeyCommand))
        
        ; currentHotkeyInfo := data.GetHotkey(hotkeyCommand)
        ; if (currentHotkeyInfo.hotkeyIsObject()){
        ;     this.CreateHotKeyMaker(this.mainGui)
        ;     this.createHotkeyMethodCall(this.mainGui, hotkeyAction)
        ; }
        ; else{

        ; }
        this.mainGui.Show()
    }


    buttonToChangeOriginalHotkeyClickedEvent(hotkeyCommand){
        this.mainGui.Hide()

        hotkeyCrafter := HotkeyCrafterGui(hotkeyCommand)
        
        hotkeySavedEventAction := ObjBindMethod(this, "saveButtonClickedForHotkeyCrafterEvent", hotkeyCrafter)

        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)




        hotkeyCrafterClosedEvent := ObjBindMethod(this, "cancelButtonClickedForHotkeyCrafterEvent", hotkeyCrafter)
        hotkeyCrafter.addCloseEventAction(hotkeyCrafterClosedEvent)
        hotkeyCrafter.addCancelButtonClickEventAction(hotkeyCrafterClosedEvent)


        hotkeyCrafter.Show()
        ; this.mainGui.Destroy()

        ; this.GuiObject.Add("Text", "w300 h20", "New Action For Hotkey:")
        ; this.hotkeyStaticInput := this.GuiObject.Add("Edit", "w300 h20")

        ; this.CreateHotKeyMaker(this.mainGui)
        ; this.createHotkeyMethodCall(this.mainGui, hotkeyCommand)
        ; this.mainGui.Show()
    }

    cancelButtonClickedForHotkeyCrafterEvent(hotkeyCrafter, *){
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }



    saveButtonClickedForHotkeyCrafterEvent(hotkeyCrafter, savedButton, idk){
        newHotkey := hotkeyCrafter.getNewHotkey()
        hotkeyCrafter.Destroy()
        this.mainGui.Show()
    }

    CreateHotKeyMaker(){
        manuallyCreateHotkeyCheckbox := this.mainGui.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        this.hotkeyElement := this.mainGui.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := this.mainGui.Add("Edit", "xm w300 h20", this.hotkeyCommand)
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

    createHotkeyMethodCall(hotkeyAction){
        ; inputValue := this.mainGui.Add("Edit", "xm w300 h20", hotkeyAction)
        this.mainGui.Add("Text", "xm w300 h20", "New Action For Hotkey:")

        inputValue := this.mainGui.Add("Edit", "xm w300 h20", hotkeyAction)
        
        SaveButton := this.mainGui.Add("Button", "w100 h20", "Save")
        CancelButton := this.mainGui.Add("Button", "w100 h20", "Cancel")
        DeleteButton := this.mainGui.Add("Button", "w100 h20", "Delete")
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
    
}


; test := HotKeyConfigurationPopup()

; test.CreatePopupForHotkeyRegistry(0, 0, "^!+a", "test")
