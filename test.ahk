
SetGamma(red, green, blue){
    VarSetCapacity(gammaRamp, 512*3)
    Loop,	256
    {
        If  (newRed:=(red+128)*(A_Index-1))>65535
             newRed:=65535
        NumPut(newRed, gammaRamp, 2*(A_Index-1), "Ushort")

        If  (newGreen:=(green+128)*(A_Index-1))>65535
            newGreen:=65535
        NumPut(newGreen, gammaRamp,  512+2*(A_Index-1), "Ushort")
        
        If  (newBlue:=(blue+128)*(A_Index-1))>65535
            newBlue:=65535
        NumPut(newBlue, gammaRamp, 1024+2*(A_Index-1), "Ushort")
    }
    hDC := DllCall("GetDC", "Uint", 0)
    DllCall("SetDeviceGammaRamp", "Uint", hDC, "Uint", &gammaRamp)
    DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
}
SetGamma(0, 0, 0)






; u :: max brightns toggle for normal
; j :: min brightness toggle for normal


; i :: gamma min, toggle for normal
; o :: gamma normal toggle for normal

; k :: change gamma red
; l :: change gamma green
; ø :: change gamam blue
