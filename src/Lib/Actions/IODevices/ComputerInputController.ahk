#Requires AutoHotkey v2.0

#Include ".\Keyboard.ahk"
#Include ".\Mouse.ahk"
#Include <Actions\HotkeyAction>

class ComputerInputController extends HotkeyAction {

    MouseInput := ""
    KeyboardInput := ""

    __New() {
        this.MouseInput := Mouse()
        this.KeyboardInput := Keyboard()
    }

    destroy() {
        ; This method is called when the object is destroyed.
        ; This method is required to be implemented in the subclass of HotkeyAction.
        this.UnBlockAllInput()
    }

    BlockAllInput() {
        this.BlockKeyboard()
        this.BlockMouse()
    }

    UnBlockAllInput() {
        this.UnBlockKeyboard()
        this.UnBlockMouse()
    }

    BlockKeyboard() {
        this.KeyboardInput.BlockKeyInput()
    }

    UnBlockKeyboard() {
        this.KeyboardInput.UnBlockKeyInput()
    }

    BlockMouse() {
        this.MouseInput.BlockAllMouseInput()
    }

    UnBlockMouse() {
        this.MouseInput.UnBlockAllMouseInput()
    }
}
