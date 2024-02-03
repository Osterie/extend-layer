#Requires AutoHotkey v2.0


#Include ".\HotkeyCrafterGui.ahk"

class HotKeyConfigurationPopup{

    hotkeyElement := ""
    hotkeyCommand := ""
    manuallyCreatHotkeyElement := ""
    addWinKeyAsModifierElement := ""

    CreatePopupForHotkeyRegistry(data, rowNumber, hotkeyCommand, hotkeyAction){

        this.hotkeyCommand := hotkeyCommand

        guiToAddTo := Gui()
        guiToAddTo.opt("+Resize +MinSize600x560")
        
        ; guiToAddTo.Add("Text", "w300 h20", "Original hotkey:") 
        originalHotkeyText := guiToAddTo.AddText(" ", "Original hotkey: `n" . hotkeyCommand)
        newActionText := guiToAddTo.AddText(" ", "Original action: `n" . hotkeyAction)

        originalHotkeyText.SetFont("s10", "Arial")
        newActionText.SetFont("s10", "Arial")

        this.SetTextAndResize(originalHotkeyText, "Original hotkey: `n" . hotkeyCommand )
        this.SetTextAndResize(newActionText, "Original action: `n" . hotkeyAction)

        buttonToChangeOriginalHotkey := guiToAddTo.AddButton("Default w80", "Change original hotkey")
        buttonToChangeOriginalAction := guiToAddTo.AddButton("Default w80", "Change original action")
        saveButton := guiToAddTo.AddButton("Default w80", "Save+Done")

        buttonToChangeOriginalHotkey.onEvent("Click", (*) => this.buttonToChangeOriginalHotkeyClickedEvent(guiToAddTo, hotkeyCommand))
        
        ; currentHotkeyInfo := data.GetHotkey(hotkeyCommand)
        ; if (currentHotkeyInfo.hotkeyIsObject()){
        ;     this.CreateHotKeyMaker(guiToAddTo)
        ;     this.createHotkeyMethodCall(guiToAddTo, hotkeyAction)
        ; }
        ; else{

        ; }
        guiToAddTo.Show()
    }

    buttonToChangeOriginalHotkeyClickedEvent(guiToAddTo, hotkeyCommand){
        guiToAddTo.Hide()


        hotkeyCrafter := HotkeyCrafterGui(hotkeyCommand)
        
        hotkeySavedEventAction := ObjBindMethod(this, "hotkeyCrafterHotkeySavedEvent", hotkeyCrafter)

        hotkeyCrafter.addSaveButtonClickEventAction(hotkeySavedEventAction)




        hotkeyCrafter.Show()
        ; guiToAddTo.Destroy()

        ; this.GuiObject.Add("Text", "w300 h20", "New Action For Hotkey:")
        ; this.hotkeyStaticInput := this.GuiObject.Add("Edit", "w300 h20")

        ; this.CreateHotKeyMaker(guiToAddTo)
        ; this.createHotkeyMethodCall(guiToAddTo, hotkeyCommand)
        ; guiToAddTo.Show()
    }

    hotkeyCrafterHotkeySavedEvent(hotkeyCrafter, savedButton, idk){
        newHotkey := hotkeyCrafter.getNewHotkey()
        hotkeyCrafter.Destroy()
        

    }

    CreateHotKeyMaker(guiToAddTo){
        manuallyCreateHotkeyCheckbox := guiToAddTo.Add("CheckBox", , "Manually create hotkey")
        manuallyCreateHotkeyCheckbox.onEvent("Click", (*) => this.manuallyCreateHotkeyCheckboxClickEvent(manuallyCreateHotkeyCheckbox))

        this.hotkeyElement := guiToAddTo.Add("Hotkey", )
        this.manuallyCreatHotkeyElement := guiToAddTo.Add("Edit", "xm w300 h20", this.hotkeyCommand)
        this.manuallyCreatHotkeyElement.Opt("Hidden1")

        this.addWinKeyAsModifierElement := guiToAddTo.Add("CheckBox",, "Add win key as modifier")

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

    createHotkeyMethodCall(guiToAddTo, hotkeyAction){
        ; inputValue := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyAction)
        guiToAddTo.Add("Text", "xm w300 h20", "New Action For Hotkey:")

        inputValue := guiToAddTo.Add("Edit", "xm w300 h20", hotkeyAction)
        
        SaveButton := guiToAddTo.Add("Button", "w100 h20", "Save")
        CancelButton := guiToAddTo.Add("Button", "w100 h20", "Cancel")
        DeleteButton := guiToAddTo.Add("Button", "w100 h20", "Delete")
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