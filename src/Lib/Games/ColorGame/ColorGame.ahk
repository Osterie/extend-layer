#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Mutation\Mutation>
#Include <Games\ColorGame\Fill\ColorStrategies>
#Include <Games\ColorGame\Drawing\ScreenDrawer>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class ColorGame {

    interval := 16
    pixelSize := 5

    isRunning := false

    _ScreenDrawer := 0

    timer := 0
    fillTimer := 0

    fillCanvasStepsPerFrame := 200


    fillCanvasStrategy := IColorStrategy()


    __New(fillCanvasStrategy, targetFPS := 10, pixelSize := 5) {
        this.interval := 1000 // targetFPS
        this.pixelSize := pixelSize
        this.fillCanvasStrategy := fillCanvasStrategy
        this.Initialize()
    }

    Initialize() {
        this.timer := ObjBindMethod(this, "mutateCanvas")
        this.fillTimer := ObjBindMethod(this, "fillCanvasStepLoop")
        this.isRunning := false

        this._ScreenDrawer := ScreenDrawer(this.fillCanvasStrategy, this.pixelSize)
    }

    Start() {
        if (this.isRunning)
            return

        this.isRunning := true

        SetTimer(this.fillTimer, this.interval)
    }

    Stop() {
        this.isRunning := false
        SetTimer(this.timer, 0)
    }

    Reset() {
        this._ScreenDrawer.Reset()
    }

    fillCanvasStepLoop() {
        if (!this.isRunning) {
            SetTimer(this.fillTimer, 0)
            return
        }
        if (this._ScreenDrawer.canvasIsFilled()) {
            SetTimer(this.fillTimer, 0)
            SetTimer(this.timer, this.interval)
            return
        }

        this._ScreenDrawer.fillCanvasStep(this.fillCanvasStepsPerFrame)
    }

    mutateCanvas() {
        if (!this.isRunning) {
            return
        }
        steps := 200
        this._ScreenDrawer.mutateCanvas(steps)
    }

    setFillCanvasStepsPerFrame(fillCanvasStepsPerFrame){
        if (!IsInteger(fillCanvasStepsPerFrame)){
            throw TypeError("setFillCanvasStepsPerFrame expected a number, but got: " . type(fillCanvasStepsPerFrame))
        }
        if (fillCanvasStepsPerFrame < 0){
            throw ValueError("fillCanvasStepsPerFrame must be a positive number")
        }
            
        this.fillCanvasStepsPerFrame := fillCanvasStepsPerFrame
    }
}
