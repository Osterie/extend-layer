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
            ; initialize row as array
            this.grid[row].Length := this.cols
        }
    }

    getRows() {
        return this.rows
    }

    getCols() {
        return this.cols
    }

    ; Takes parameter of type Square
    setSquare(row, col, squareObject) {
        try {
            this.grid[row][col] := squareObject
            return 1
        }
        catch {
            return -1
        }
    }

    getSquare(row, col) {
        try {
            return this.grid[row][col]
        }
        catch {
            return -1
        }
    }
}

class Square {
    x := 0
    y := 0
    color := 0xffffffff

    __New(x, y, color) {
        this.x := x
        this.y := y
        this.color := color
    }

    getX() {
        return this.x
    }

    getY() {
        return this.y
    }

    getColor() {
        return this.color
    }
}
