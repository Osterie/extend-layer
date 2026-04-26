#Requires AutoHotkey v2.0

#Include <Util\ArrayUtils>

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

; Strategies for which order to get points in a space.
; returns for example:
; [[2,1], [1,2], [1,1], [2,2]]
; This tells whoever uses it to do some operation on the point [2,1], and then [1,2] etc.
class IOrdertrategy {
    ; Number of rows and cols to fill. for example if 2 and 2 will return something like:
    ; [[1,1], [1,2], [2,1], [2,2]]
    ; This array tells whoever uses it which order get points in space
    GetArray(rows, cols) {
        throw Error("GetColor not implemented")
    }
}

class RandomOrder extends IOrdertrategy {
    GetArray(rows, cols) {
        return ArrayUtils.CreateRandomOneDimensionalGrid(rows, cols)
    }
}

class LinearOrder extends IOrdertrategy {
    GetArray(rows, cols) {
        return ArrayUtils.CreateOneDimensionalGrid(rows, cols)
    }
}
