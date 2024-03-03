#Requires AutoHotkey v2.0

#Include ".\Keyboard.ahk"
#Include ".\Mouse.ahk"

Class ComputerInputController{

    MouseInput := ""
    KeyboardInput := ""

    __New(){
        this.MouseInput := Mouse()
        this.KeyboardInput := Keyboard()
    }

    ; TODO fix me, does not work when using a modifier key.
    BlockAllInput(){
        this.BlockKeyboard()
        this.BlockMouse()
    }

    UnBlockAllInput(){
        this.UnBlockKeyboard()
        this.UnBlockMouse()
    }

    BlockMouse(){
        this.MouseInput.BlockMovementInput()
    }

    UnBlockMouse(){
        this.MouseInput.UnBlockMovementInput()
    }

    BlockKeyboard(){
        this.KeyboardInput.BlockKeyInput()
    }

    UnBlockKeyboard(){
        this.KeyboardInput.UnBlockKeyInput()
    }
}
