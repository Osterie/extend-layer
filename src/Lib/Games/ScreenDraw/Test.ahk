#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>

#Include <Shared\Logger>

#Include <ui\util\GuiColorsChanger>

#Include <Infrastructure\Repositories\ThemesRepository>

; TODO on focus, change color of text and control, so that tab navigation is easiers...
class ColorGame {

    ThemesRepository := ThemesRepository.getInstance()
    theme := ""

    Logger := Logger.getInstance()
    interval := 16

    WALeft := 0
    WATop := 0
    WARight := 0
    WABottom := 0
    WAWidth := 0
    WAHeight := 0

    hwnd1 := 0
    hdc := 0
    G := 0

    pBitmap := 0

    timerIsRunning := false

    gridToFill := [] ; One dimensional
    filledGrid := 0 ; SquareGrid object
    cols := 0
    rows := 0
    cellSize := 20

    __New(targetFPS) {
        this.interval := 1000 // targetFPS
        this.Initialize()
    }

    Initialize() {
        MonitorPrimary := GetPrimaryMonitor()
        M := GetMonitorInfo(MonitorPrimary)
        this.WALeft := M.WALeft
        this.WATop := M.WATop
        this.WARight := M.WARight
        this.WABottom := M.WABottom
        this.WAWidth := M.WARight - M.WALeft
        this.WAHeight := M.WABottom - M.WATop

        this.timer := ObjBindMethod(this, "MutateCanvas")
        this.timerIsRunning := false

        this.cols := Floor(this.WAWidth / this.cellSize)
        this.rows := Floor(this.WAHeight / this.cellSize)

        this.ResetGrid()

        this.InitializeGuiRelated()
    }

    InitializeGuiRelated() {
        if !pToken := Gdip_Startup() {
            MsgBox("Gdiplus failed to start. Please ensure you have gdiplus on your system")
        }

        ; Create a layered window (+E0x80000) that is always on top (+AlwaysOnTop), has no taskbar entry or caption
        Gui1 := Gui("-Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs")
        Gui1.Show("NA")

        ; Get a handle to this window we have created in order to update it later
        this.hwnd1 := WinExist()

        hbm := CreateDIBSection(this.WAWidth, this.WAHeight)
        this.hdc := CreateCompatibleDC()
        obm := SelectObject(this.hdc, hbm)

        this.pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm) ; keep for GetPixel
        this.G := Gdip_GraphicsFromHDC(this.hdc)          ; draw directly to HDC
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

        this.Shuffle(this.gridToFill)
    }

    Shuffle(arr) {
        loop arr.Length {
            i := A_Index
            j := Random(1, arr.Length)
            tmp := arr[i]
            arr[i] := arr[j]
            arr[j] := tmp
        }
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
        Gdip_GraphicsClear(this.G)
        UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)
        this.ResetGrid()
    }

    DoDrawing() {
        this.FillCanvas()
        this.MutateCanvas()
    }

    FillCanvas() {
        pPen := Gdip_CreatePen(0xff808080, this.cellSize)
        color := 0xff808080
        pBrush := Gdip_BrushCreateSolid(color)

        while (this.gridToFill.Length != 0) {

            loop 200 {
                if (this.gridToFill.Length = 0)
                    break

                cell := this.gridToFill.Pop()

                row := cell[1]
                col := cell[2]

                squareObject := Square(row, col, color)
                this.filledGrid.setSquare(row, col, squareObject)

                x := (col - 1) * this.cellSize
                y := (row - 1) * this.cellSize

                ; Gdip_DrawRectangle(this.G, pPen, x, y, this.cellSize, this.cellSize)
                Gdip_FillRectangle(this.G, pBrush, x, y, this.cellSize, this.cellSize)
            }

            UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)

            Gdip_DeletePen(pPen)
        }

    }

    ; MutateCanvas() {
    ;     loop 50 {
    ;         row := Random(1, this.filledGrid.Length)
    ;         col := Random(1, this.filledGrid[row].Length)
    ;         squareObject := this.filledGrid[row][col]

    ;         this.GetMaxNeighborStrength(row, col)

    ;         color := this.MutateColor(squareObject.getColor())
    ;         pBrush := Gdip_BrushCreateSolid(color)
    ;         newSquare := Square(row, col, color)
    ;         this.filledGrid[row][col] := newSquare

    ;         x := (col - 1) * this.cellSize
    ;         y := (row - 1) * this.cellSize

    ;         Gdip_FillRectangle(this.G, pBrush, x, y, this.cellSize, this.cellSize)

    ;         UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)
    ;         Gdip_DeleteBrush(pBrush)
    ;     }
    ; }

    MutateCanvas() {
        loop 200 {
            row := Random(1, this.rows)
            col := Random(1, this.cols)

            squareObj := this.filledGrid.getSquare(row, col)
            ; baseColor := squareObj.getColor()
            baseColor := this.GetStrongestNeighborColor(row, col)

            maxStrength := this.GetMaxNeighborStrength(row, col)

            ; ---- 1. Mutation probability ----
            chance := 1 + (maxStrength / 0.2)
            if (Random(0, 100) > chance)
                continue

            ; ---- 2. Mutation strength ----
            ; stronger neighbors = stronger mutation
            deltaBoost := maxStrength / 40

            color := this.MutateColorWithInfluence(baseColor, deltaBoost)

            ; ---- 3. Apply ----
            squareObject := Square(row, col, color)
            this.filledGrid.setSquare(row, col, squareObject)

            x := (col - 1) * this.cellSize
            y := (row - 1) * this.cellSize

            pBrush := Gdip_BrushCreateSolid(color)
            Gdip_FillRectangle(this.G, pBrush, x, y, this.cellSize, this.cellSize)
            Gdip_DeleteBrush(pBrush)
        }

        UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)
    }

    MutateColorWithInfluence(color, boost) {
        a := (color >> 24) & 0xFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        channel := Random(1, 3)

        ; base mutation + boost from neighbors
        ; delta := Random(-10, 10) + boost
        delta := Round(Random(-10, 10) + boost)

        if (channel = 1)
            r := this.Clamp(r + delta, 0, 170)
        else if (channel = 2)
            g := this.Clamp(g + delta, 0, 170)
        else
            b := this.Clamp(b + delta, 0, 170)

        return (a << 24) | (r << 16) | (g << 8) | b
    }

    MutateColor(color) {
        ; Extract ARGB
        a := (color >> 24) & 0xFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        channel := Random(1, 3)
        delta := Random(-10, 10)

        if (channel = 1)
            r := this.Clamp(r + delta, 0, 255)
        else if (channel = 2)
            g := this.Clamp(g + delta, 0, 255)
        else
            b := this.Clamp(b + delta, 0, 255)

        return (a << 24) | (r << 16) | (g << 8) | b
    }

    Clamp(val, min, max) {
        return val < min ? min : val > max ? max : val
    }

    ; Choose a point, the average mutation strength for that area is the average mutation strength
    ; of the point itself and its 8 neighbors (3x3)
    ; CalculateAverageMutationStrength(x, y) {
    ;     total := 0
    ;     count := 0

    ;     loop 3 {
    ;         row_offset := A_Index - 2
    ;         loop 3 {
    ;             col_offset := A_Index - 2

    ;             nx := x + row_offset
    ;             ny := y + col_offset

    ;             ; bounds check
    ;             if (nx < 1 || nx > this.rows)
    ;                 continue
    ;             if (ny < 1 || ny > this.cols)
    ;                 continue

    ;             squareObj := this.filledGrid[nx][ny]
    ;             total += this.GetMutationStrength(squareObj.getColor())
    ;             count++
    ;         }
    ;     }

    ;     return count ? total / count : 0
    ; }

    GetMaxNeighborStrength(x, y) {
        max := 0

        loop 3 {
            row_offset := A_Index - 2
            loop 3 {
                col_offset := A_Index - 2

                nx := x + row_offset
                ny := y + col_offset

                ; skip out-of-bounds
                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObject := this.filledGrid.getSquare(nx,ny)
                strength := this.GetMutationStrength(squareObject.getColor())

                if (strength > max)
                    max := strength
            }
        }

        return max
    }

    GetStrongestNeighborColor(x, y) {
        max := -1
        bestColor := 0xff808080

        loop 3 {
            row_offset := A_Index - 2
            loop 3 {
                col_offset := A_Index - 2

                nx := x + row_offset
                ny := y + col_offset

                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObject := this.filledGrid.getSquare(nx,ny)
                color := squareObject.getColor()
                strength := this.GetMutationStrength(color)

                if (strength > max) {
                    max := strength
                    bestColor := color
                }
            }
        }

        return bestColor
    }

    GetMutationStrength(color) {
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        ; distance from gray (128,128,128)
        return Abs(r - 128) + Abs(g - 128) + Abs(b - 128)
    }

    DrawPixel(x, y, size, pen) {
        Gdip_DrawRectangle(this.G, pen, x, y, size, size)
    }

    DrawCircle() {
        ; Get a random colour for the background and foreground of hatch style used to fill the ellipse,
        ; as well as random brush style, x and y coordinates and width/height
        RandBackColour := Random(0.0, 0xffffffff)
        RandForeColour := Random(0.0, 0xffffffff)
        RandBrush := Random(0, 53)
        RandElipseWidth := Random(1, 200)
        RandElipseHeight := Random(1, 200)
        RandElipsexPos := Random(this.WALeft, this.WAWidth - RandElipseWidth)
        RandElipseyPos := Random(this.WATop, this.WAHeight - RandElipseHeight)

        ; Create the random brush
        pBrush := Gdip_BrushCreateHatch(RandBackColour, RandForeColour, RandBrush)

        ; Fill the graphics of the bitmap with an ellipse using the brush created
        Gdip_FillEllipse(this.G, pBrush, RandElipsexPos, RandElipseyPos, RandElipseWidth, RandElipseHeight)

        ; Update the specified window
        UpdateLayeredWindow(this.hwnd1, this.hdc, this.WALeft, this.WATop, this.WAWidth, this.WAHeight)

        ; Delete the brush as it is no longer needed and wastes memory
        Gdip_DeleteBrush(pBrush)
    }
}

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

        this.Init()
    }

    Init() {
        this.grid := []

        this.grid.Length := this.rows
        loop this.rows {
            row := A_Index
            this.grid[row] := []  ; initialize row as array
            this.grid[row].Length := this.cols
        }
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

class Mutator {

    MutateColorWithInfluence(color, boost) {
        a := (color >> 24) & 0xFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        channel := Random(1, 3)

        ; base mutation + boost from neighbors
        ; delta := Random(-10, 10) + boost
        delta := Round(Random(-10, 10) + boost)

        if (channel = 1)
            r := this.Clamp(r + delta, 0, 170)
        else if (channel = 2)
            g := this.Clamp(g + delta, 0, 170)
        else
            b := this.Clamp(b + delta, 0, 170)

        return (a << 24) | (r << 16) | (g << 8) | b
    }

    MutateColor(color) {
        ; Extract ARGB
        a := (color >> 24) & 0xFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        channel := Random(1, 3)
        delta := Random(-10, 10)

        if (channel = 1)
            r := this.Clamp(r + delta, 0, 255)
        else if (channel = 2)
            g := this.Clamp(g + delta, 0, 255)
        else
            b := this.Clamp(b + delta, 0, 255)

        return (a << 24) | (r << 16) | (g << 8) | b
    }

    Clamp(val, min, max) {
        return val < min ? min : val > max ? max : val
    }

    ; Choose a point, the average mutation strength for that area is the average mutation strength
    ; of the point itself and its 8 neighbors (3x3)
    ; CalculateAverageMutationStrength(x, y) {
    ;     total := 0
    ;     count := 0

    ;     loop 3 {
    ;         row_offset := A_Index - 2
    ;         loop 3 {
    ;             col_offset := A_Index - 2

    ;             nx := x + row_offset
    ;             ny := y + col_offset

    ;             ; bounds check
    ;             if (nx < 1 || nx > this.rows)
    ;                 continue
    ;             if (ny < 1 || ny > this.cols)
    ;                 continue

    ;             squareObj := this.filledGrid[nx][ny]
    ;             total += this.GetMutationStrength(squareObj.getColor())
    ;             count++
    ;         }
    ;     }

    ;     return count ? total / count : 0
    ; }

    GetMaxNeighborStrength(x, y) {
        max := 0

        loop 3 {
            row_offset := A_Index - 2
            loop 3 {
                col_offset := A_Index - 2

                nx := x + row_offset
                ny := y + col_offset

                ; skip out-of-bounds
                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObject := this.filledGrid.getSquare(nx,ny)
                strength := this.GetMutationStrength(squareObject.getColor())

                if (strength > max)
                    max := strength
            }
        }

        return max
    }

    GetStrongestNeighborColor(x, y) {
        max := -1
        bestColor := 0xff808080

        loop 3 {
            row_offset := A_Index - 2
            loop 3 {
                col_offset := A_Index - 2

                nx := x + row_offset
                ny := y + col_offset

                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObject := this.filledGrid.getSquare(nx,ny)
                color := squareObject.getColor()
                strength := this.GetMutationStrength(color)

                if (strength > max) {
                    max := strength
                    bestColor := color
                }
            }
        }

        return bestColor
    }

    GetMutationStrength(color) {
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        ; distance from gray (128,128,128)
        return Abs(r - 128) + Abs(g - 128) + Abs(b - 128)
    }

}

class Muation {
    red := 0
    green := 0
    blue := 0

    __New(r, g, b) {
        red := r
        green := g
        blue := b
    }
}
