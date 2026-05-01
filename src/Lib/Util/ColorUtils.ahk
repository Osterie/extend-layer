#Requires AutoHotkey v2.0

class ColorUtils {
    static HSLtoRGB(h, s, l) {
        return
    }

    ; static RGBtoHSL(r, g, b){
    ;     return
    ; }

    static ConvertBGRtoRGB(color) {
        ; Shift the bits so that only the 8 relevant remain and them keep only them
        b := (color >> 16) & 0xFF
        g := (color >> 8) & 0xFF
        r := color & 0xFF
        ; Moves bits to correct position combines them into an integer
        return (r << 16) | (g << 8) | b
    }
}

; HSL to/from RGB conversion functions by [VxE]. Freely avalable @ http://www.autohotkey.com/community/viewtopic.php?f=2&t=88707

HSLtoARGB(hue, sat := 1, lum := 0.5) { ; Function by [VxE]. See > http://www.wikipedia.org/wiki/HSV_color_space
    ; Converts a hue/sat/lum into a 24-bit RGB color code. Input: 0 <= hue <= 360, 0 <= sat <= 1, 0 <= lum <= 1.

    MsgBox(hue)
    static i24 := 0xFFFFFF, i40 := 0xFFFFFF0000, hx := "0123456789ABCDEF"

    ; Transform the decimal inputs into 24-bit integers. Integer arithmetic is nice..
    sat := Round(sat * i24) & i24
    lum := Round(lum * i24) & i24
    hue := (hue * 0xB60B60 >> 8) & i24 ; conveniently, 360 * 0xB60B60 = 0xFFFFFF00

    ; Determine the chroma value and put it in the 'sat' var since the saturation value is not used after this.

    sat := lum + Round(sat * (i24 - Abs(i24 - lum - lum)) / 0x1FFFFFE)

    ; Calculate the base values for red and blue (green's base value is the hue)
    red := hue < 0xAAAAAA ? hue + 0x555555 : hue - 0xAAAAAA
    blu := hue < 0x555555 ? hue + 0xAAAAAA : hue - 0x555555

    ; Run the blue value through the cases
    if (blu < 0x2AAAAB)
        blu := sat + 2 * (i24 - 6 * blu) * (lum - sat) / i24 >> 16
    else if (blu < 0x800000)
        blu := sat >> 16
    else if (blu < 0xAAAAAA)
        blu := sat + 2 * (i24 - 6 * (0xAAAAAA - blu)) * (lum - sat) / i24 >> 16
    else
        blu := 2 * lum - sat >> 16

    ; Run the red value through the cases
    if (red < 0x2AAAAB)
        red := sat + 2 * (i24 - 6 * red) * (lum - sat) / i24 >> 16
    else if (red < 0x800000)
        red := sat >> 16
    else if (red < 0xAAAAAA)
        red := sat + 2 * (i24 - 6 * (0xAAAAAA - red)) * (lum - sat) / i24 >> 16
    else
        red := 2 * lum - sat >> 16

    ; Run the green value through the cases
    if (hue < 0x2AAAAB)
        hue := sat + 2 * (i24 - 6 * hue) * (lum - sat) / i24 >> 16
    else if (hue < 0x800000)
        hue := sat >> 16
    else if (hue < 0xAAAAAA)
        hue := sat + 2 * (i24 - 6 * (0xAAAAAA - hue)) * (lum - sat) / i24 >> 16
    else
        hue := 2 * lum - sat >> 16

    ; Return the values in RGB as a hex integer
    return "0x" SubStr(hx, (red >> 4) + 1, 1) SubStr(hx, (red & 15) + 1, 1)
    . SubStr(hx, (hue >> 4) + 1, 1) SubStr(hx, (hue & 15) + 1, 1)
    . SubStr(hx, (blu >> 4) + 1, 1) SubStr(hx, (blu & 15) + 1, 1)
} ; END - HSLtoARGB( hue, sat, lum )

HSL_Hue(RGB) { ; Function by [VxE]. Returns the HSL hue of the input 24-bit RGB code.
    ; Returns a floating point value less than 360 but not less than 0.

    blu := 255 & (RGB)
    grn := 255 & (RGB >> 8)
    red := 255 & (RGB >> 16)

    if (blu = grn) && (blu = red)
        return 0 + 0.0
    else if (blu < grn)
        if (red < blu)
            return 60 * (blu - red) / (grn - red) + 120
        else if (grn < red)
            return 60 * (grn - blu) / (red - blu)
        else
            return 60 * (blu - red) / (grn - blu) + 120
    else
        if (red < grn)
            return 60 * (red - grn) / (blu - red) + 240
        else if (blu < red)
            return 60 * (grn - blu) / (red - grn) + (blu = grn ? 0 : 360)
        else
            return 60 * (red - grn) / (blu - grn) + 240
} ; END - HSL_Hue( RGB )

HSL_Sat(RGB) { ; Function by [VxE]. Returns the HSL saturation of the input 24-bit RGB code.
    ; Returns a floating point value between 0 and 1, inclusive.

    blu := 255 & (RGB)
    grn := 255 & (RGB >> 8)
    red := 255 & (RGB >> 16)

    if (blu = grn) && (blu = red)
        return 0 + 0.0
    else if (blu < grn)
        if (red < blu)
            return (grn - red) / (255 - Abs(255 - grn - red))
        else if (grn < red)
            return (red - blu) / (255 - Abs(255 - red - blu))
        else
            return (grn - blu) / (255 - Abs(255 - grn - blu))
    else
        if (red < grn)
            return (blu - red) / (255 - Abs(255 - blu - red))
        else if (blu < red)
            return (red - grn) / (255 - Abs(255 - red - grn))
        else
            return (blu - grn) / (255 - Abs(255 - blu - grn))
} ; END - HSL_Sat( RGB )

HSL_Lum(RGB) { ; Function by [VxE]. Returns the HSL lightness of the input 24 bit color.
    ; Returns a floating point value between 0 and 1, inclusive.

    blu := 255 & (RGB)
    grn := 255 & (RGB >> 8)
    red := 255 & (RGB >> 16)

    if (blu < grn)
        if (red < blu)
            return (red + grn) / 510
        else if (grn < red)
            return (blu + red) / 510
        else
            return (blu + grn) / 510
    else
        if (red < grn)
            return (red + blu) / 510
        else if (blu < red)
            return (grn + red) / 510
        else
            return (grn + blu) / 510
} ; END - HSL_Lum( RGB )
