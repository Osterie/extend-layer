#Requires AutoHotkey v2.0

class ScreenSizeFinder{


    getActiveMonitorSizeObject(){

        dimensions := {width:0, height:0}
        montiorCount := SysGet(80)


        WinGetPos &OutX, &OutY, &OutWidth, &OutHeight, WinTitle, WinText, ExcludeTitle, ExcludeText

        
    }


    get_active_mon_dim() {
        dim := {width:0, height:0}                              ; Object to return with width and height
        SysGet, count, MonitorCount                             ; Get number of monitors
        WinGetActiveStats, title, width, height, x, y           ; Get active window's x/y/width/height
        x := x + width / 2                                      ; Calculate the middle x of the window
        y := y + height / 2                                     ; Calculate the middle y of the window
        Loop, % count {                                         ; Loop through each monitor
            SysGet, mon, Monitor, % A_Index                     ;  Get this monitor's bounds 
            if (x >= monLeft) && (x <= monRight)                ;  if x falls between the left and right
            && (y <= monBottom) && (y >= monTop)                ;  and y falls between top and bottom
                dim.width := Abs(monRight - monLeft)            ;   Use the bounds to calculate the width
                ,dim.height := Abs(monTop - monBottom)          ;   and the height
        } Until (dim.width > 0)                                 ; Break when a width is found
        return dim                                              ; Return the dimension object
    }

    getMonitorSize(activeMonitor){

    }
    
}