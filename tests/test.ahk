#Requires AutoHotkey v2.0

#Include ".\KeysAndMouseAction.ahk"
#Include ".\KeysAndMouseActions.ahk"
#Include ".\InputSender.ahk"
#Include ".\KeysAndMouseActionsTranslator.ahk"


;         DllCall("QueryPerformanceFrequency", "Int64*", &this.freq := 0)

; DllCall("QueryPerformanceCounter", "Int64*", &this.CounterBefore := 0)
; Sleep 1000
; DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)
; MsgBox "Elapsed QPC time is " . (CounterAfter - this.CounterBefore) / freq * 1000 " ms"



Class InputRecorder{

    inputHook := ""
    keysPressedDownTemp := []
    actions := ""

    freq := 0
    CounterBefore := 0
    CounterAfter := 0

    __New(EndKeys := ""){

        this.actions := KeysAndMouseActions()

        this.inputHook := InputHook("V", EndKeys)
        this.inputHook.KeyOpt("{All}", "+N")
        this.inputHook.KeysDown := Map() ;Remembers what key is already down
        this.inputHook.OnKeyDown := this.KeyDown.Bind(this)
        this.inputHook.OnKeyUp := this.KeyUp.Bind(this)
        this.inputHook.OnEnd := this.EndRecording.Bind(this)
    }

    KeyUp(inputHookObject, virtualKeyCode, scanCode){

        keyName := GetKeyName(Format("sc{:X}", scanCode))
        inputHookObject.KeysDown[keyName] := 0

        action := KeysAndMouseAction()
        this.CounterAfter := A_TickCount
        action.setTime((this.CounterAfter - this.CounterBefore)) ; should be the timer for the started char
        this.CounterBefore := A_TickCount

        if (this.keysPressedDownTemp.Length > 1){

            action.SetAction(this.keysPressedDownTemp.Clone())
            indexOfKey := this.GetIndexOfValue(this.keysPressedDownTemp, keyName)
            this.keysPressedDownTemp.RemoveAt(indexOfKey)
        }
        else{
            action.SetAction([keyName])
        }

        this.actions.AddAction(action)
        ToolTip(this.TempArrayToString())

    }

    KeyDown(inputHookObject, virtualKeyCode, scanCode){

        keyName := GetKeyName(Format("sc{:X}", scanCode))

        if (!inputHookObject.KeysDown.Get(keyName, "")){
            inputHookObject.KeysDown[keyName] := 1
        }
        else{
            return
        }

        if (this.keysPressedDownTemp.Length > 0){

            action := KeysAndMouseAction()

            action.SetAction(this.keysPressedDownTemp.Clone())

            this.CounterAfter := A_TickCount
            action.setTime((this.CounterAfter - this.CounterBefore)) ; should be the timer for the started char
            
            this.actions.AddAction(action)
            ToolTip(this.TempArrayToString())
        }

        this.CounterBefore := A_TickCount

        this.AddPressedKeyToTempArray(keyName) 
        keyWait(Format("sc{:X}", scanCode), )
    }

    StartRecording(){
        this.inputHook.Start()
        this.inputHook.Wait()
    }

    EndRecording(inputHookObject){
        msgbox(this.actions.GetActionsAsString())
        msgbox("heiabdp")
        this.inputHook.Stop()
    }

    GetActions(){
        return this.actions
    }

    AddPressedKeyToTempArray(char){
        this.keysPressedDownTemp.Push(char)
    }

    TempArrayToString(){
        stringToReturn := ""

        Loop this.keysPressedDownTemp.Length{
            stringToReturn .= this.keysPressedDownTemp[A_Index]
        }

        return stringToReturn
    }

    GetIndexOfValue(haystack, needle) {
        valueToReturn := 0
        if (IsObject(haystack)) || (haystack.Length != 0){
            for index, value in haystack
                if (value = needle){
                    valueToReturn := index
                }
        }
        return valueToReturn
    }
}

recorder := InputRecorder("{p}")
recorder.StartRecording()
actionsWithTimes := recorder.GetActions()

; translator := KeysAndMouseActionsTranslator()
; translator.TranslateFromActions(actions)

actions := actionsWithTimes.GetActions()
times := actionsWithTimes.GetTimes()


msgbox("press okay to repear actions")
Sleep(2000)

sender := InputSender()
sender.SetInputsAndTimes(actions, times)
sender.SendAllInputsForGivenTimes()
sender.SendInputForGivenTime("a", "b")


*esc::ExitApp