#Requires AutoHotkey v2.0

class ArrayUtils {

    ; Creates a one dimensional array that represents a grid,
    ; where each item is a list with a position.
    ; Example creation: [ [1,1], [1,2], [2,1], [2,2] ]
    ; After randomizing might look like:
    ;[ [2,1], [2,2], [1,1], [1,2] ]
    static CreateRandomOneDimensionalGrid(rows, cols) {
        gridToFill := []
        loop rows {
            row := A_Index
            loop cols {
                col := A_Index
                gridToFill.Push([row, col])
            }
        }

        ArrayUtils.Shuffle(gridToFill)
        return gridToFill
    }

    ; Shuffles the original given array, does not return a copy
    ; just shuffles the original array.
    static Shuffle(arr) {
        loop arr.Length {
            i := A_Index
            j := Random(1, arr.Length)
            tmp := arr[i]
            arr[i] := arr[j]
            arr[j] := tmp
        }
    }
}
