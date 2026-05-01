#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>
#Include <Util\ColorUtils>

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
        return ColorUtils.ConvertBGRtoRGB(GetPixelColorBuffered(x, y))
    }

    ; ConvertBGRtoRGB(color) {
    ;     ; Shift the bits so that only the 8 relevant remain and them keep only them
    ;     b := (color >> 16) & 0xFF
    ;     g := (color >> 8) & 0xFF
    ;     r := color & 0xFF
    ;     ; Moves bits to correct position combines them into an integer
    ;     return (r << 16) | (g << 8) | b
    ; }
}

class RandomColorStrategy extends IColorStrategy {
    _GetColor(x, y) {
        return Random(0x000000, 0xFFFFFF)
    }
}

class ColorAsFunctionOfPositionStrategy extends IColorStrategy {

    ; Function which takes paramters (x, y) and returns a value, which
    ; will represent the hue value in hsl, which gets converted to rgb when GetColor is called.
    __New() {
        this.colorFunction := (x, y) => x+y
    }

    setFunction(colorFunction) {
        this.colorFunction := colorFunction
    }

    _GetColor(x, y) {

        ; Since this.colorFunction stores a anonymous Func, which is not bound with "this",
        ; .Call is used, which avoids issues with injection of this.

        ; ColorHLSToRGB excpects hue, saturation and lightness to be from 0-240.
        ; Which is why hue is multiplied with 2/3
        hue := Mod(this.colorFunction.Call(x, y), 360) * 0.666667
        saturation := 120
        lightness := 120

        ; TODO find more effienect calculation from hsl to rgb than DLL call
        bgr := DllCall("shlwapi.dll\ColorHLSToRGB"
            , "UShort", hue
            , "UShort", saturation
            , "UShort", lightness)

        return ColorUtils.ConvertBGRtoRGB(bgr)
        ; return HSLtoARGB(hue, 1, 1)
    }
}
