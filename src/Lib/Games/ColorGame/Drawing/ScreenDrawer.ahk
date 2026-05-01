#Requires AutoHotkey v2.0

#Include <Util\ArrayUtils>
#Include <Util\ScreenDimensions>
#Include <Util\PerformanceUtils>

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>
#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

#Include <Games\ColorGame\Mutation\Mutation>
#Include <Games\ColorGame\Mutation\MutationEngine>
#Include <Games\ColorGame\Fill\OrderStrategies>
#Include <Games\ColorGame\Fill\ColorStrategies>
#Include <Games\ColorGame\Util\SquareGrid>
#Include <Games\ColorGame\Drawing\GdipDrawer>
#Include <Games\ColorGame\Fill\CanvasFillingEngine>
#Include <Games\ColorGame\Util\utils>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class ScreenDrawer {

    ; One dimensional array like this:
    ;[ [1,1], [1,2], [2,1], [2,2] ]
    gridToFill := 0

    filledGrid := 0 ; SquareGrid object
    cols := 0
    rows := 0
    squareSize := 10

    ; Type MutationEngine
    _MutationEngine := 0
    ; Type CanvasFillingEngine
    _CanvasFillingEngine := 0

    drawer := 0

    fillCanvasStrategy := IColorStrategy()

    __New(fillCanvasStrategy, squareSize) {
        this.squareSize := squareSize
        this.fillCanvasStrategy := fillCanvasStrategy
        this.Initialize()
    }

    Initialize() {
        ; dimension is of type Dimensions
        dimension := ScreenDimensions.GetWorkArea()
        this.cols := Floor(dimension.width / this.squareSize)
        this.rows := Floor(dimension.height / this.squareSize)

        this.gridToFill := this.createGridToFill()
        this.filledGrid := SquareGrid(this.rows, this.cols)

        this.drawer := GdipDrawer(this.squareSize)

        this._MutationEngine := MutationEngine(this.filledGrid, this.squareSize)

        this._CanvasFillingEngine := CanvasFillingEngine(this.filledGrid, this.gridToFill, this.fillCanvasStrategy,
            this.squareSize)
    }

    Reset() {
        this.drawer.Reset()
        this.resetGrid()
    }

    fillCanvasStep(batchSize := 1000) {
        changes := this._CanvasFillingEngine.Fill(batchSize)
        this.renderChanges(changes)
    }

    mutateCanvas(steps := 200) {
        ; Timer.start()
        changes := this._MutationEngine.Mutate(steps)
        ; MsgBox("Elapsed QPC time is " . Timer.Stop())

        ; Timer.start()
        this.renderChanges(changes)
        ; MsgBox("Elapsed QPC time is " . Timer.Stop())
    }

    renderChanges(changes) {
        lastColor := ""
        pBrush := 0

        for _, change in changes {
            row := change.row
            col := change.col
            color := change.color

            pos := GridMath.ToPixel(row, col, this.squareSize)
            BrushLifetimeHandler.GetOrUpdateBrush(&pBrush, &lastColor, color)
            this.drawer.DrawPixel(pos.x, pos.y, pBrush)
        }
        this.drawer.Update()
    }

    resetGrid() {
        this.filledGrid.reset()
        this.gridToFill := this.createGridToFill()
    }

    createGridToFill() {
        return ArrayUtils.CreateRandomOneDimensionalGrid(this.rows, this.cols)
    }

    canvasIsFilled() {
        return this.gridToFill.Length == 0
    }
}
