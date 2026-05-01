#Requires AutoHotkey v2.0

#Include <Games\ColorGame\Mutation\Mutation>

class MutationEngine {

    mutationStrategy := StrengthBasedMutationStrategy()
    mutationCalculator := 0
    squareSize := 10

    ; Grid is of type SquareGrid
    grid := 0

    __New(grid, squareSize := 10) {
        this.grid := grid
        this.squareSize := squareSize
        this.mutationCalculator := MutationStrengthCalculator(this.grid)
    }

    ; TODO able to change strategy

    Mutate(steps := 200) {

        numberOfNeighbors := 3

        changes := []

        rows := this.grid.getRows()
        cols := this.grid.getCols()

        loop steps {
            row := Random(1, rows)
            col := Random(1, cols)

            baseColor := this.grid.getSquare(row, col)
            ; baseColor := this.mutationCalculator.GetStrongestNeighborColor(row, col)

            ; type is MutationStrength
            maxStrengthMutationStrength := this.mutationCalculator.GetMaxNeighborStrength(row, col, numberOfNeighbors)
            ; Chance to mutate
            ; chance := 1 + (maxStrengthMutationStrength.getTotalStrength() / 0.2)
            ; if (Random(0, 10) > chance) {
            ;     continue
            ; }

            ; randomMutation := Floor(Random(0.0, 3) ** 2)
            ; maxStrengthMutationStrength.addStrengthNumber(randomMutation)

            color := this.mutationStrategy.Mutate(baseColor, maxStrengthMutationStrength)

            this.grid.setSquare(row, col, color)

            changes.Push({ row: row, col: col, color: color })
        }
        return changes
    }
}
