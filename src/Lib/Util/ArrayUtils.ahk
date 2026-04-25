#Requires AutoHotkey v2.0

class ArrayUtils {
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
