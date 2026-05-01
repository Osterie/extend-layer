#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_All>

class BrushLifetimeHandler {

    static GetOrUpdateBrush(&pBrush, &lastColor, color) {
        if (!pBrush || color != lastColor) {
            BrushLifetimeHandler.DeleteBrush(&pBrush)
            pBrush := Gdip_BrushCreateSolid(color)
            lastColor := color
        }
    }

    static DeleteBrush(&pBrush) {
        if (pBrush) {
            Gdip_DeleteBrush(pBrush)
            pBrush := 0
        }
    }
}

class GridMath {
    static ToPixel(row, col, size) {
        return {
            x: (col - 1) * size,
            y: (row - 1) * size
        }
    }
}
