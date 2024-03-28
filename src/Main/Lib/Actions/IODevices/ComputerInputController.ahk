#Requires AutoHotkey v2.0

#Include ".\Keyboard.ahk"
#Include ".\Mouse.ahk"
#Include <Actions\Action>

Class ComputerInputController extends Action{

    MouseInput := ""
    KeyboardInput := ""

    __New(){
        this.MouseInput := Mouse()
        this.KeyboardInput := Keyboard()
    }

    BlockAllInput(){
        this.BlockKeyboard()
        this.BlockMouse()
    }

    UnBlockAllInput(){
        this.UnBlockKeyboard()
        this.UnBlockMouse()
    }

    BlockKeyboard(){
        this.KeyboardInput.BlockKeyInput()
    }

    UnBlockKeyboard(){
        this.KeyboardInput.UnBlockKeyInput()
    }

    BlockMouse(){
        this.MouseInput.BlockAllMouseInput()
    }

    UnBlockMouse(){
        this.MouseInput.UnBlockAllMouseInput()
    }
}
