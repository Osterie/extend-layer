#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Mutation>
#Include <Games\ColorGame\ColorStrategies>
#Include <Games\ColorGame\ScreenDrawer>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class ColorGame {

    interval := 16

    timerIsRunning := false

    drawer := 0

    fillCanvasStrategy := ScreenColorStrategy()

    __New(targetFPS) {
        this.interval := 1000 // targetFPS
        this.Initialize()
    }

    Initialize() {
        this.timer := ObjBindMethod(this, "MutateCanvas")
        this.timerIsRunning := false

        cellSize := 10
        this.drawer := ScreenDrawer(cellSize)
    }

    Start() {
        if (this.timerIsRunning) {
            return
        }

        this.timerIsRunning := true

        this.FillCanvas()
        SetTimer(this.timer, this.interval)
    }

    Stop() {
        this.timerIsRunning := false
        SetTimer(this.timer, 0)
    }

    Reset() {
        this.drawer.Reset()
    }

    FillCanvas() {
        while (!this.drawer.canvasIsFilled() && this.timerIsRunning) {
            this.drawer.FillCanvasStep()
        }
    }

    MutateCanvas() {
        this.drawer.MutateCanvas()
    }

    SetFillCanvasStrategy(strategy) {
        this.fillCanvasStrategy := strategy
    }
}
