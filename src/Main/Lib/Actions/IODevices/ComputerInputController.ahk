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

    BlockAllInput(){
        this.KeyboardInput.BlockKeyInput()
        this.MouseInput.BlockAllMouseInput()
    }

    UnBlockAllInput(){
        this.KeyboardInput.UnBlockKeyInput()
        this.MouseInput.UnBlockAllMouseInput()
    }
}
