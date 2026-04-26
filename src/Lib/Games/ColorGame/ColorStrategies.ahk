#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

; Strategies for getting the color at a position on the screen
; Can be used to get the exact color at a position on the screen (ScreenColorStrategy)
; Or just for getting a solid or random color instead, etc.
class IColorStrategy {
    GetColor(x, y) {
        color := this._GetColor(x, y)
        return 0xFF000000 | color ; Ensures opacity using bitwise OR
    }

    _GetColor(x, y) {
        throw Error("_GetColor not implemented")
    }
}

class SolidColorStrategy extends IColorStrategy {
    __New(color) {
        this.color := color
    }

    _GetColor(x, y) {
        return this.color
    }
}

class ScreenColorStrategy extends IColorStrategy {
    _GetColor(x, y) {
        return this.ConvertBGRtoRGB(GetPixelColorBuffered(x, y))
    }

    ConvertBGRtoRGB(color) {
        ; Shift the bits so that only the 8 relevant remain and them keep only them
        b := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        r := color & 0xFF
        ; Moves bits to correct position combines them into an integer
        return (r << 16) | (g << 8) | b
    }
}

class RandomColorStrategy extends IColorStrategy {
    _GetColor(x, y) {
        return Random(0x000000, 0xFFFFFF)
    }
}
