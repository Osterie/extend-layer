#Requires AutoHotkey v1.1.36.02

Class Monitor{

    ; red 
    ; green
    ; blue
    ; brightnees

    SetBrightness( ByRef brightness := 50, timeout = 1 )
    {
        if ( brightness >= 0 && brightness <= 100 )
        {
            For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightnessMethods" )
                property.WmiSetBrightness( timeout, brightness )	
        }
         else if ( brightness > 100 )
         {
             brightness := 100
         }
         else if ( brightness < 0 )
         {
             brightness := 0
         }
    }
    
    GetCurrentBrightness()
    {
        For property in ComObjGet( "winmgmts:\\.\root\WMI" ).ExecQuery( "SELECT * FROM WmiMonitorBrightness" )
            currentBrightness := property.CurrentBrightness	
    
        return currentBrightness
    }
    
    ; Each parameter takes values from 0 to 255
    ; Change gamma of display, 0 dark, 128 normal, 255 bright
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

    GetCurrentGamma(){
    
        VarSetCapacity(gammaRamp, 1536, 0)
        hDC := DllCall("user32\GetDC", Ptr,0, Ptr)
        DllCall("gdi32\GetDeviceGammaRamp", Ptr,hDC, Ptr,&gammaRamp)

        gammaRampList := []
        gammaRampList["Red"]   := NumGet(gammaRamp,        2, "ushort") - 128
        gammaRampList["Green"] := NumGet(gammaRamp,  512 + 2, "ushort") - 128
        gammaRampList["Blue"]  := NumGet(gammaRamp, 1024 + 2, "ushort") - 128

        Return gammaRampList

    }
}