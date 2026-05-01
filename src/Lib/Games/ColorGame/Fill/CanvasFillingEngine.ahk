#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Fill\ColorStrategies>
#Include <Games\ColorGame\Util\utils>

class CanvasFillingEngine {

    squareSize := 10

    ; One dimensional array like this:
    ;[ [1,1], [1,2], [2,1], [2,2] ]
    canvasToFill := 0
    fillCanvasStrategy := 0

    ; Grid is of type SquareGrid
    grid := 0

    __New(grid, canvasToFill, fillCanvasStrategy, squareSize := 10) {
        this.grid := grid
        this.canvasToFill := canvasToFill
        this.squareSize := squareSize
        this.fillCanvasStrategy := fillCanvasStrategy
    }

    Fill(batchSize := 200) {
        changes := []

        range := Min(batchSize, this.canvasToFill.Length)

        loop range {
            cell := this.canvasToFill.Pop()
            row := cell[1]
            col := cell[2]

            pos := GridMath.ToPixel(row, col, this.squareSize)
            color := this.fillCanvasStrategy.GetColor(pos.x, pos.y)

            this.grid.setSquare(row, col, color)

            changes.Push({ row: row, col: col, color: color })
        }

        return changes
    }
}
