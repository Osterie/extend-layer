﻿#Requires Autohotkey v2.0

Class Monitor{

    ; red 
    ; green
    ; blue
    ; brightnees

    SetBrightness( brightness, timeout := 1 )
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
        ; VarSetStrCapacity(&gammaRamp, 512*3) ; V1toV2: if 'gammaRamp' is NOT a UTF-16 string, use 'gammaRamp := Buffer(512*3)'
        ; gammaRamp := Buffer(512*3)
        GAMMA_RAMP := Buffer(1536)
        hMonitor := DllCall("user32\MonitorFromWindow", "ptr", 0, "uint", 0x00000002) ; MONITOR_DEFAULTTONEAREST = 0x00000002

        while ((i := A_Index - 1) < 256 ){	
			NumPut("ushort", (r := (red   + 128) * i) > 65535 ? 65535 : r, GAMMA_RAMP,        2 * i)
			NumPut("ushort", (g := (green + 128) * i) > 65535 ? 65535 : g, GAMMA_RAMP,  512 + 2 * i)
			NumPut("ushort", (b := (blue  + 128) * i) > 65535 ? 65535 : b, GAMMA_RAMP, 1024 + 2 * i)
		}
        hDC := DllCall("GetDC", "Uint", 0)
        DllCall("SetDeviceGammaRamp", "Uint", hDC, "ptr", GAMMA_RAMP)
    }

    CycleRed(step, upperLimit){
        gammaRamp := this.getCurrentGamma()
        red := gammaRamp.Get(1)
        red := this.CycleValue(red, step, upperLimit)
        green := gammaRamp.Get(2)
        blue := gammaRamp.Get(3)

        this.setGamma(red, green, blue)
    }

    CycleBlue(step, upperLimit){
        gammaRamp := this.getCurrentGamma()
        red := gammaRamp.Get(1)
        green := gammaRamp.Get(2)
        green := this.CycleValue(green, step, upperLimit)
        blue := gammaRamp.Get(3)

        this.setGamma(red, green, blue)
    }
    
    CycleGreen(step, upperLimit){
        gammaRamp := this.getCurrentGamma()
        red := gammaRamp.Get(1)
        green := gammaRamp.Get(2)
        blue := gammaRamp.Get(3)
        blue := this.CycleValue(blue, step, upperLimit)

        this.setGamma(red, green, blue)
    }

    GetCurrentGamma(){
    
        gammaRamp := Buffer(1536, 0) ; V1toV2: if 'gammaRamp' is a UTF-16 string, use 'VarSetStrCapacity(&gammaRamp, 1536)'
        hDC := DllCall("user32\GetDC", "Ptr", 0, "Ptr")
        DllCall("gdi32\GetDeviceGammaRamp", "Ptr", hDC, "Ptr", gammaRamp)

        gammaRampList := []
        gammaRampList.InsertAt(1 , NumGet(gammaRamp, 2, "ushort") - 128)
        gammaRampList.InsertAt(2 , NumGet(gammaRamp, 512 + 2, "ushort") - 128)
        gammaRampList.InsertAt(3 , NumGet(gammaRamp, 1024 + 2, "ushort") - 128)

        Return gammaRampList

    }

    CycleValue(givenValue, step, upperLimit){
        givenValue += step
        if (givenValue >= upperLimit){
            givenValue := 0
        }
        Return givenValue
    }
}