#Requires AutoHotkey v2.0

#Include <Util\ArrayUtils>

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>
#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

#Include <Games\ColorGame\Mutation>
#Include <Games\ColorGame\ColorStrategies>
#Include <Games\ColorGame\SquareGrid>
#Include <Games\ColorGame\ScreenDrawer>

; Thanks to tic (Tariq Porter) for his GDI+ Library
; http://www.autohotkey.com/forum/viewtopic.php?t=32238

class ColorGame {

    interval := 16

    timerIsRunning := false

    gridToFill := [] ; One dimensional
    filledGrid := 0 ; SquareGrid object
    cols := 0
    rows := 0
    cellSize := 10

    mutatorObject := StrengthBasedMutationStrategy()
    mutationCalculator := 0

    drawer := 0

    __New(targetFPS) {
        this.interval := 1000 // targetFPS
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

        this.cols := Floor(WAWidth / this.cellSize)
        this.rows := Floor(WAHeight / this.cellSize)

        this.ResetGrid()

        this.timer := ObjBindMethod(this, "MutateCanvasNew")
        this.timerIsRunning := false

        this.drawer := ScreenDrawer(this.cellSize)
    }

    ResetGrid() {
        this.filledGrid := SquareGrid(this.rows, this.cols)

        this.gridToFill := []
        loop this.rows {
            row := A_Index
            loop this.cols {
                col := A_Index
                this.gridToFill.Push([row, col])
            }
        }

        ArrayUtils.Shuffle(this.gridToFill)
        this.mutationCalculator := MutationStrengthCalculator(this.filledGrid)
    }

    Start() {
        if (this.timerIsRunning) {
            return
        }

        this.timerIsRunning := true

        this.FillCanvasCopyScreen()
        SetTimer(this.timer, this.interval)
    }

    Stop() {
        this.timerIsRunning := false
        SetTimer(this.timer, 0)
    }

    Reset() {
        this.drawer.Reset()
        this.ResetGrid()
    }

    FillCanvasSolid() {
        black := 0xff000000
        ; gray := 0xff808080
        fillStrategy := SolidColorStrategy(black)
        this.FillCanvas(fillStrategy)
    }

    FillCanvasCopyScreen() {
        fillStrategy := ScreenColorStrategy()
        this.FillCanvas(fillStrategy)
    }

    FillCanvasRandom() {
        fillStrategy := RandomColorStrategy()
        this.FillCanvas(fillStrategy)
    }

    FillCanvas(colorStrategy) {

        lastColor := ""
        pBrush := 0
        while (this.gridToFill.Length != 0 && this.timerIsRunning) {

            loop 1000 {
                if (this.gridToFill.Length = 0)
                    break

                cell := this.gridToFill.Pop()
                row := cell[1]
                col := cell[2]

                x := (col - 1) * this.cellSize
                y := (row - 1) * this.cellSize

                color := colorStrategy.GetColor(x, y, row, col)
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
        }
        if (pBrush) {
            Gdip_DeleteBrush(pBrush)
        }
    }



    ; MutateCanvas() {
    ;     lastColor := ""
    ;     pBrush := 0

    ;     loop 200 {
    ;         row := Random(1, this.rows)
    ;         col := Random(1, this.cols)

    ;         squareObj := this.filledGrid.getSquare(row, col)
    ;         ; baseColor := squareObj.getColor()
    ;         baseColor := this.mutationCalculator.GetStrongestNeighborColor(row, col)

    ;         maxStrengthMutationStrength := this.mutationCalculator.GetMaxNeighborStrength(row, col)

    ;         ; ---- 1. Mutation probability ----
    ;         chance := 1 + (maxStrengthMutationStrength / 0.2)
    ;         if (Random(0, 100) > chance)
    ;             continue

    ;         ; ---- 2. Mutation strength ----
    ;         ; stronger neighbors = stronger mutation
    ;         deltaBoost := maxStrengthMutationStrength / 40

    ;         color := this.mutatorObject.MutateColorWithStrengthInfluence(baseColor, deltaBoost)

    ;         ; ---- 3. Apply ----
    ;         squareObject := Square(row, col, color)
    ;         this.filledGrid.setSquare(row, col, squareObject)

    ;         x := (col - 1) * this.cellSize
    ;         y := (row - 1) * this.cellSize

    ;         if (color != lastColor) {
    ;             if (pBrush)
    ;                 Gdip_DeleteBrush(pBrush)
    ;             pBrush := Gdip_BrushCreateSolid(color)
    ;             lastColor := color
    ;         }

    ;         this.drawer.DrawPixel(x, y, pBrush)
    ;     }
    ;     Gdip_DeleteBrush(pBrush)
    ;     this.drawer.Update()
    ; }

    MutateCanvasNew() {
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

            color := this.mutatorObject.MutateColorWithStrengthInfluence(baseColor, maxStrengthMutationStrength)

            ; ---- 3. Apply ----
            squareObject := Square(row, col, color)
            this.filledGrid.setSquare(row, col, squareObject)

            x := (col - 1) * this.cellSize
            y := (row - 1) * this.cellSize

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
