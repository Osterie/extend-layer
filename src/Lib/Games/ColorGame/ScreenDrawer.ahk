#Requires AutoHotkey v2.0

#Include <Util\ArrayUtils>

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>
#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

#Include <Games\ColorGame\Mutation>
#Include <Games\ColorGame\ColorStrategies>
#Include <Games\ColorGame\SquareGrid>
#Include <Games\ColorGame\GdipDrawer>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/boards/viewtopic.php?t=6517

class ScreenDrawer {

    gridToFill := 0

    filledGrid := 0 ; SquareGrid object
    cols := 0
    rows := 0
    pixelSize := 10

    mutatorObject := StrengthBasedMutationStrategy()
    mutationCalculator := 0

    drawer := 0

    fillCanvasStrategy := ScreenColorStrategy()

    __New(pixelSize) {
        this.pixelSize := pixelSize
        this.Initialize()
    }

    Initialize() {
        MonitorPrimary := GetPrimaryMonitor()
        M := GetMonitorInfo(MonitorPrimary)

        WALeft := M.WALeft
        WATop := M.WATop
        WARight := M.WARight
        WABottom := M.WABottom
        WAWidth := M.WARight - M.WALeft
        WAHeight := M.WABottom - M.WATop

        this.cols := Floor(WAWidth / this.pixelSize)
        this.rows := Floor(WAHeight / this.pixelSize)

        this.filledGrid := SquareGrid(this.rows, this.cols)
        this.mutationCalculator := MutationStrengthCalculator(this.filledGrid)

        this.timer := ObjBindMethod(this, "MutateCanvas")
        this.timerIsRunning := false

        this.drawer := GdipDrawer(this.pixelSize)

        this.gridToFill := ArrayUtils.CreateRandomOneDimensionalGrid(this.rows, this.cols)

    }

    Reset() {
        this.drawer.Reset()
        this.ResetGrid()
    }

    ResetGrid() {
        this.filledGrid.reset()
        this.gridToFill := ArrayUtils.CreateRandomOneDimensionalGrid(this.rows, this.cols)

    }

    SetFillCanvasStrategy(strategy) {
        this.fillCanvasStrategy := strategy
    }

    FillCanvasStep(batchSize := 1000) {
        lastColor := ""
        pBrush := 0

        range := Min(batchSize, this.gridToFill.Length)

        loop range {
            if (this.gridToFill.Length = 0) {
                break
            }

            cell := this.gridToFill.Pop()
            row := cell[1]
            col := cell[2]

            x := (col - 1) * this.pixelSize
            y := (row - 1) * this.pixelSize

            color := this.fillCanvasStrategy.GetColor(x, y, row, col)
            color := 0xFF000000 | color ; Bit operation to force opaqueness

            if (!pBrush || color != lastColor) {
                if (pBrush) {
                    Gdip_DeleteBrush(pBrush)
                }

                pBrush := Gdip_BrushCreateSolid(color)
                lastColor := color
            }

            squareObject := Square(row, col, color)
            this.filledGrid.setSquare(row, col, squareObject)

            this.drawer.DrawPixel(x, y, pBrush)
        }
        this.drawer.Update()
        if (pBrush) {
            Gdip_DeleteBrush(pBrush)
        }
    }

    canvasIsFilled() {
        return this.gridToFill.Length == 0
    }

    MutateCanvas() {
        lastColor := ""
        pBrush := 0
        numberOfNeighbors := 5

        loop 200 {
            row := Random(1, this.rows)
            col := Random(1, this.cols)

            squareObj := this.filledGrid.getSquare(row, col)
            baseColor := squareObj.getColor()
            ; baseColor := this.mutationCalculator.GetStrongestNeighborColor(row, col)

            ; Of type MutationStrength
            maxStrengthMutationStrength := this.mutationCalculator.GetMaxNeighborStrength(row, col, numberOfNeighbors)

            ; ---- 1. Mutation probability ----
            chance := 1 + (maxStrengthMutationStrength.getTotalStrength() / 0.2)
            if (Random(0, 10) > chance)
                continue

            randomMutation := Floor(Random(0.0, 2) ** 2)
            maxStrengthMutationStrength.addStrengthNumber(randomMutation)
            ; ---- 2. Mutation strength ----
            ; stronger neighbors = stronger mutation
            ; deltaBoost := maxStrengthMutationStrength / 40

            color := this.mutatorObject.Mutate(baseColor, maxStrengthMutationStrength)

            ; ---- 3. Apply ----
            squareObject := Square(row, col, color)
            this.filledGrid.setSquare(row, col, squareObject)

            x := (col - 1) * this.pixelSize
            y := (row - 1) * this.pixelSize

            if (color != lastColor) {
                if (pBrush)
                    Gdip_DeleteBrush(pBrush)
                pBrush := Gdip_BrushCreateSolid(color)
                lastColor := color
            }

            this.drawer.DrawPixel(x, y, pBrush)
        }
        Gdip_DeleteBrush(pBrush)
        this.drawer.Update()
    }
}
