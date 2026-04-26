#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Mutation>
#Include <Games\ColorGame\ColorStrategies>
#Include <Games\ColorGame\ScreenDrawer>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class ColorGame {

    interval := 16

    isRunning := false

    _ScreenDrawer := 0

    fillCanvasStrategy := ScreenColorStrategy()

    __New(targetFPS) {
        this.interval := 1000 // targetFPS
        this.Initialize()
    }

    Initialize() {
        this.timer := ObjBindMethod(this, "MutateCanvas")
        this.isRunning := false

        cellSize := 5
        this._ScreenDrawer := ScreenDrawer(cellSize)
    }

    Start() {
        if (this.isRunning) {
            return
        }

        this.isRunning := true

        this.FillCanvas()
        SetTimer(this.timer, this.interval)
    }

    Stop() {
        this.isRunning := false
        SetTimer(this.timer, 0)
    }

    Reset() {
        this._ScreenDrawer.Reset()
    }

    FillCanvas() {
        while (!this._ScreenDrawer.canvasIsFilled() && this.isRunning) {
            this._ScreenDrawer.fillCanvasStep()
        }
    }

    MutateCanvas() {
        steps := 200
        this._ScreenDrawer.MutateCanvas(steps)
    }

    setFillCanvasStrategy(strategy) {
        this._ScreenDrawer.setFillCanvasStrategy(strategy)
    }
}
