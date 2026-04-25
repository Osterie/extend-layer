#Requires AutoHotkey v2.0

class IMutationStrategy {
    Mutate(color, strength, context?) {
        throw Error("Not implemented")
    }

    Clamp(val, min, max) {
        return val < min ? min : val > max ? max : val
    }

    Scale(val) {
        ; return Floor(Sqrt(Abs(val)) * (val < 0 ? -1 : 1))
        return Floor(Log(Abs(val) + 1) * (val < 0 ? -1 : 1))

    }
}

class StrengthBasedMutationStrategy extends IMutationStrategy {
    Mutate(color, strength, context?) {
        mutationStr := strength / 40
        a := (color >> 24) & 0xFF
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        channel := Random(1, 100)

        totalStrength := mutationStr.getTotalStrength()
        if (totalStrength == 0) {
            return color
        }

        redStrength := mutationStr.getRedStrength()
        greenStrength := mutationStr.getGreenStrength()
        blueStrength := mutationStr.getBlueStrength()

        ; base mutation + mutationStr from neighbors
        ; delta := Random(-10, 10) + mutationStr
        ; delta := Round(Random(-10, 10) + mutationStr)

        ; redChance := 100 * (redStrength / totalStrength)
        ; greenChance := 100 * (greenStrength / totalStrength)
        ; blueChance := 100 * (blueStrength / totalStrength)

        redChance := 100 * (Abs(redStrength) / totalStrength)
        greenChance := 100 * (Abs(greenStrength) / totalStrength)
        blueChance := 100 * (Abs(blueStrength) / totalStrength)

        if (channel < redChance) {
            delta := this.Scale(mutationStr.getRedStrength())

            r := this.Clamp(r + delta, 0, 255)
            g := this.Clamp(g - delta, 0, 255)
            b := this.Clamp(b - delta, 0, 255)
        }
        else if (channel < (redChance + greenChance)) {
            delta := this.Scale(mutationStr.getGreenStrength())

            r := this.Clamp(r - delta, 0, 255)
            g := this.Clamp(g + delta, 0, 255)
            b := this.Clamp(b - delta, 0, 255)
        }
        else {
            delta := this.Scale(mutationStr.getBlueStrength())

            r := this.Clamp(r - delta, 0, 255)
            g := this.Clamp(g - delta, 0, 255)
            b := this.Clamp(b + delta, 0, 255)
        }

        return (a << 24) | (r << 16) | (g << 8) | b
    }
}

class RandomMutationStrategy extends IMutationStrategy {

    Mutate(color, strength, context?) {
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
}

; Represent the mutation strength for the red, green and blue values of a color.
; Mutation strength is NOT the actual color. It is the likely hood of a the color changing (mutating)
; Red, green and blue can be negative numbers, you can think of them as how much they will affect the color.
; Can be for example +4 red or -5 red.
class MutationStrength {
    red := 0
    green := 0
    blue := 0

    __New(r, g, b) {
        this.red := r
        this.green := g
        this.blue := b
    }

    addStrengthNumber(number) {
        this.red += number
        this.green += number
        this.blue += number
    }

    addStrength(otherMutationStrength) {
        this.red += otherMutationStrength.getRedStrength()
        this.green += otherMutationStrength.getGreenStrength()
        this.blue += otherMutationStrength.getBlueStrength()
    }

    largerThanSingular(otherMutationStrength) {
        return this.getStrongestValue() > otherMutationStrength.getStrongestValue()
    }

    largerThanTotal(otherMutationStrength) {
        return this.getTotalStrength() > otherMutationStrength.getTotalStrength()
    }

    getTotalStrength() {
        return (Abs(this.red) + Abs(this.green) + Abs(this.blue))
    }

    getAverageStrength() {
        return this.getTotalStrength() / 3
    }

    ; Returns the strongest color value.
    ; For example if red = 5, green = 1 and blue = -6, returns -6
    getStrongestValue() {
        strongest := this.red

        if (Abs(this.green) > Abs(strongest)) {
            strongest := this.green
        }

        if (Abs(this.blue) > Abs(strongest)) {
            strongest := this.blue
        }

        return strongest
    }

    setRedStrength(red) {
        this.red := red
    }
    setGreenStrength(green) {
        this.green := green
    }

    setBlueStrength(blue) {
        this.blue := blue
    }

    getRedStrength() {
        return this.red
    }
    getGreenStrength() {
        return this.green
    }
    getBlueStrength() {
        return this.blue
    }

    addRedStrength(red) {
        this.red += red
    }
    addGreenStrength(green) {
        this.green += green
    }
    addBlueStrength(blue) {
        this.blue += blue
    }

    Clone() {
        return MutationStrength(this.red, this.green, this.blue)
    }

    ; getHue
    ; getLightness
    ; getSaturation
}

class MutationStrengthCalculator {

    grid := 0
    rows := 0
    cols := 0

    ; Grid is of type SquareGrid
    __New(grid) {
        this.setGrid(grid)
    }

    ; Grid is of type SquareGrid
    setGrid(grid) {
        this.grid := grid
        this.rows := this.grid.getRows()
        this.cols := this.grid.getCols()
    }

    ; Choose a point, the average mutation strength for that area is the average mutation strength
    ; of the point itself and its neighbors (a x a neighbors)
    ; No checks for IsNumber or > 0 are done for extra performance i guess...
    CalculateAverageMutationStrength(x, y, numberOfNeighbors) {
        totalStrength := MutationStrength(0, 0, 0)
        count := 0

        loop numberOfNeighbors {
            row_offset := A_Index - numberOfNeighbors + 1
            loop numberOfNeighbors {
                col_offset := A_Index - numberOfNeighbors + 1

                nx := x + row_offset
                ny := y + col_offset

                ; bounds check
                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObj := this.grid[nx][ny]
                totalStrength.addStrength(this.GetMutationStrength(squareObj.getColor()))
                count++
            }
        }

        r := count ? totalStrength.getRedStrength() / count : 0
        g := count ? totalStrength.getGreenStrength() / count : 0
        b := count ? totalStrength.getBlueStrength() / count : 0

        return MutationStrength(r, g, b)
        ; return count ? total / count : 0
    }

    GetMaxNeighborStrength(x, y, numberOfNeighbors) {
        max := MutationStrength(0, 0, 0)

        loop numberOfNeighbors {
            row_offset := A_Index - numberOfNeighbors + 1
            loop numberOfNeighbors {
                col_offset := A_Index - numberOfNeighbors + 1

                nx := x + row_offset
                ny := y + col_offset

                ; skip out-of-bounds
                if (nx < 1 || nx > this.rows)
                    continue
                if (ny < 1 || ny > this.cols)
                    continue

                squareObject := this.grid.getSquare(nx, ny)
                strength := this.GetMutationStrength(squareObject.getColor())

                ; TODO can also change this to largerThanSingular and check if that gives cool results
                if (strength.largerThanTotal(max)) {
                    max := strength.Clone()
                }
            }
        }

        return max
    }

    ; GetStrongestNeighborColor(x, y, numberOfNeighbors) {
    ;     max := MutationStrength(0,0,0)
    ;     bestColor := 0xff808080

    ;     loop numberOfNeighbors {
    ;         row_offset := A_Index - numberOfNeighbors + 1
    ;         loop numberOfNeighbors {
    ;             col_offset := A_Index - numberOfNeighbors + 1

    ;             nx := x + row_offset
    ;             ny := y + col_offset

    ;             if (nx < 1 || nx > this.rows)
    ;                 continue
    ;             if (ny < 1 || ny > this.cols)
    ;                 continue

    ;             squareObject := this.grid.getSquare(nx, ny)
    ;             color := squareObject.getColor()
    ;             strength := this.GetMutationStrength(color)

    ;             if (strength > max) {
    ;                 max := strength
    ;                 bestColor := color
    ;             }
    ;         }
    ;     }

    ;     return bestColor
    ; }

    GetMutationStrength(color) {
        r := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        b := color & 0xFF

        ; distance from gray (128,128,128)
        ; distance from black (0,0,0)

        return MutationStrength(r, g, b)
        ; return Abs(r - 128) + Abs(g - 128) + Abs(b - 128)
    }
}
