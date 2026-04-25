#Requires AutoHotkey v2.0

#Include <Games\Gdip\Tariq_Porter_GDIP_Library\Gdip_Toolbox>

class IColorStrategy {
    GetColor(x, y, row, col) {
        throw Error("GetColor not implemented")
    }
}

class SolidColorStrategy extends IColorStrategy {
    __New(color) {
        this.color := color
    }

    GetColor(x, y, row, col) {
        return this.color
    }
}

class ScreenColorStrategy extends IColorStrategy {
    GetColor(x, y, row, col) {
        return this.ConvertBGRtoRGB(GetPixelColorBuffered(x, y))
    }

    ConvertBGRtoRGB(color) {
        b := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        r := color & 0xFF
        return (r << 16) | (g << 8) | b
    }
}

class RandomColorStrategy extends IColorStrategy {
    GetColor(x, y, row, col) {
        return Random(0, 0xFFFFFF)
    }
}
