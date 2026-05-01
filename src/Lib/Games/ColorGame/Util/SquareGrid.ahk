#Requires AutoHotkey v2.0

class SquareGrid {
    grid := [] ; Two dimensional

    rows := 0
    cols := 0

    __New(rows, cols) {
        if (rows < 0 || cols < 0) {
            throw ValueError("rows or cols is negative")
        }

        this.rows := rows
        this.cols := cols

        this.init()
    }

    init() {
        this.reset()
    }

    reset() {
        this.grid := []

        this.grid.Length := this.rows
        loop this.rows {
            row := A_Index
            this.grid[row] := []
            this.grid[row].Length := this.cols
        }
    }

    getRows() {
        return this.rows
    }

    getCols() {
        return this.cols
    }

    setSquare(row, col, color) {
        this.grid[row][col] := color
    }

    getSquare(row, col) {
        if (row < 1 || row > this.rows || col < 1 || col > this.cols) {
            throw ValueError("Out of bounds")
        }
        return this.grid[row][col]
    }
}
