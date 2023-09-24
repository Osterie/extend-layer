#Requires Autohotkey v2.0

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

        ; DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
		; 	return true
		; throw Error("Unable to set values.`n`nError code: " Format("0x{:X}", A_LastError))

        ; Loop 256
        ; {
        ;     If ( (newRed:=(red+128)*(A_Index-1))>65535 ){
        ;         newRed:=65535
        ;     }
        ;     ; me32 := Buffer(548, 0)
        ;     ; NumPut("Uint", 548, me32)
        ;     NumPut("Ushort", newRed, gammaRamp, 2*(A_Index))
    
        ;     If ( (newGreen:=(green+128)*(A_Index-1))>65535 ){
        ;         newGreen:=65535
        ;     }
        ;     NumPut("Ushort", newGreen, gammaRamp, 512+2*(A_Index-1))
            
        ;     If ( (newBlue:=(blue+128)*(A_Index-1))>65535 ){
        ;         newBlue:=65535
        ;     }
        ;     NumPut("Ushort", newBlue, gammaRamp, 1024+2*(A_Index-1))
        ; }
        ; hDC := DllCall("GetDC", "Uint", 0)
        ; DllCall("SetDeviceGammaRamp", "Uint", hDC, "ptr", gammaRamp)
        ; DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
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
}